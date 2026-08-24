from flask import Flask, request, jsonify
from flask_cors import CORS
from pymongo import MongoClient
from werkzeug.utils import secure_filename

import csv
import io
import os
import uuid
import math
import pandas as pd
from datetime import datetime, timezone, date


app = Flask(__name__)
CORS(app)

# MongoDB connection
MONGO_URI = os.getenv("MONGO_URI", "mongodb://localhost:27017/")
mongo_client = MongoClient(MONGO_URI)

db = mongo_client["cropbio"]

# Metadata for each uploaded file
uploads_collection = db["crop_uploads"]

# Actual row data from each uploaded file
rows_collection = db["crop_upload_rows"]


def clean_cell_value(value):
    """
    Converts values into JSON/MongoDB-safe values.
    This does not normalize column names.
    """
    if value is None:
        return ""

    if isinstance(value, float) and math.isnan(value):
        return ""

    if isinstance(value, (datetime, date)):
        return value.isoformat()

    return value


def pad_rows(rows):
    """
    Makes all rows equal in length.
    This is not column normalization; it only prevents missing cells
    when some rows are shorter than others.
    """
    if not rows:
        return []

    max_columns = max(len(row) for row in rows)

    padded_rows = []
    for row in rows:
        padded = list(row)

        while len(padded) < max_columns:
            padded.append("")

        padded_rows.append(padded)

    return padded_rows


def parse_csv_file(file_bytes):
    """
    Reads CSV without requiring any fixed columns.
    """
    encodings = ["utf-8-sig", "utf-8", "latin-1"]

    last_error = None

    for encoding in encodings:
        try:
            text = file_bytes.decode(encoding)
            reader = csv.reader(io.StringIO(text))
            rows = [row for row in reader]
            break
        except Exception as e:
            last_error = e
            rows = None

    if rows is None:
        raise ValueError(f"Unable to decode CSV file: {last_error}")

    # Remove fully empty rows only
    rows = [
        row for row in rows
        if any(str(cell).strip() for cell in row)
    ]

    return pad_rows(rows)


def parse_excel_file(file_bytes):
    """
    Reads Excel without requiring any fixed columns.
    Uses the first sheet by default.
    """
    excel_buffer = io.BytesIO(file_bytes)

    # header=None keeps the first row as ordinary data first,
    # so we can manually treat it as the header without pandas renaming columns.
    df = pd.read_excel(
        excel_buffer,
        header=None,
        dtype=object,
        keep_default_na=False,
    )

    rows = df.values.tolist()

    # Remove fully empty rows only
    rows = [
        row for row in rows
        if any(str(cell).strip() for cell in row)
    ]

    cleaned_rows = []
    for row in rows:
        cleaned_rows.append([clean_cell_value(cell) for cell in row])

    return pad_rows(cleaned_rows)


def parse_uploaded_file(file_bytes, file_name):
    """
    Detects file type by filename extension, not content type.
    This is important because Flutter may still send Excel as text/csv
    depending on your MultipartFile contentType setting.
    """
    extension = file_name.rsplit(".", 1)[-1].lower() if "." in file_name else ""

    if extension == "csv":
        return parse_csv_file(file_bytes)

    if extension in ["xlsx", "xls"]:
        return parse_excel_file(file_bytes)

    # Fallback: try CSV first
    try:
        return parse_csv_file(file_bytes)
    except Exception:
        raise ValueError("Unsupported file type. Please upload CSV, XLSX, or XLS.")


@app.route("/uploadCropData", methods=["POST"])
def upload_crop_data():
    try:
        uploaded_file = request.files.get("file")
        selected_year = request.form.get("year", "")
        selected_season = request.form.get("season", "")

        if uploaded_file is None:
            return jsonify({
                "success": False,
                "message": "No file uploaded.",
                "inserted_count": 0,
            }), 400

        original_file_name = uploaded_file.filename or "uploaded_file"
        safe_file_name = secure_filename(original_file_name)

        file_bytes = uploaded_file.read()

        if not file_bytes:
            return jsonify({
                "success": False,
                "message": "Uploaded file is empty.",
                "inserted_count": 0,
            }), 400

        rows = parse_uploaded_file(file_bytes, safe_file_name)

        if not rows:
            return jsonify({
                "success": False,
                "message": "No readable rows found in the uploaded file.",
                "inserted_count": 0,
            }), 400

        # First row is treated as the header exactly as provided.
        columns = [str(cell) for cell in rows[0]]
        data_rows = rows[1:]

        if not columns:
            return jsonify({
                "success": False,
                "message": "No columns found in the uploaded file.",
                "inserted_count": 0,
            }), 400

        if not data_rows:
            return jsonify({
                "success": False,
                "message": "The uploaded file has headers but no data rows.",
                "inserted_count": 0,
            }), 400

        upload_id = str(uuid.uuid4())
        uploaded_at = datetime.now(timezone.utc)

        # Store upload metadata once.
        uploads_collection.insert_one({
            "upload_id": upload_id,
            "file_name": safe_file_name,
            "original_file_name": original_file_name,
            "year": selected_year,
            "season": selected_season,
            "columns": columns,
            "column_count": len(columns),
            "row_count": len(data_rows),
            "uploaded_at": uploaded_at,
        })

        # Store each row as values array.
        # This preserves all columns, including duplicate or blank column names.
        documents = []

        for row_index, row in enumerate(data_rows, start=1):
            values = [clean_cell_value(value) for value in row]

            documents.append({
                "upload_id": upload_id,
                "row_index": row_index,
                "file_name": safe_file_name,
                "year": selected_year,
                "season": selected_season,
                "values": values,
                "uploaded_at": uploaded_at,
            })

        # Insert in batches for large files.
        batch_size = 1000
        inserted_count = 0

        for start in range(0, len(documents), batch_size):
            batch = documents[start:start + batch_size]
            result = rows_collection.insert_many(batch)
            inserted_count += len(result.inserted_ids)

        return jsonify({
            "success": True,
            "message": "File uploaded successfully.",
            "upload_id": upload_id,
            "file_name": safe_file_name,
            "year": selected_year,
            "season": selected_season,
            "column_count": len(columns),
            "row_count": len(data_rows),
            "inserted_count": inserted_count,
            "columns": columns,
        }), 200

    except Exception as e:
        return jsonify({
            "success": False,
            "message": f"Upload failed: {str(e)}",
            "inserted_count": 0,
        }), 500


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)