import math
import os
from flask import Flask, jsonify, request, send_from_directory, abort
from pymongo import MongoClient
from bson.objectid import ObjectId
import json
from flask_cors import CORS
from bson import ObjectId
from urllib.parse import quote_plus
from config import MONGO_URI, DB_NAME, COLLECTIONS, MONGO_URI_LOCAL, EMAIL_ADDRESS,EMAIL_PASSWORD ,FRONTEND_VERIFY_URL
import certifi
import pandas as pd
from datetime import datetime
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from itsdangerous import URLSafeTimedSerializer

# Token generator
serializer = URLSafeTimedSerializer("SECRET_KEY_123")


def send_verification_email(user_email):

    try:

        # Generate token
        token = serializer.dumps(
            user_email,
            salt="email-verification"
        )

        verification_link = (
            f"{FRONTEND_VERIFY_URL}/{token}"
        )

        subject = "Verify Your CropBio Account"

        body = f"""
Hello,

Thank you for registering with CropBio.

Please verify your email by clicking the link below:

{verification_link}

If you did not create this account, ignore this email.

CropBio Team
"""

        msg = MIMEMultipart()
        msg["From"] = EMAIL_ADDRESS
        msg["To"] = user_email
        msg["Subject"] = subject

        msg.attach(
            MIMEText(body, "plain")
        )

        # Send email
        with smtplib.SMTP(
            "smtp.gmail.com", 587
        ) as server:

            server.starttls()

            server.login(
                EMAIL_ADDRESS,
                EMAIL_PASSWORD
            )

            server.send_message(msg)

        return True, token

    except Exception as e:

        print("Email send error:", e)

        return False, None

# Create a MongoDB client
# client = MongoClient(MONGO_URI_LOCAL,tlsCAFile=certifi.where())
client = MongoClient(MONGO_URI)
# Create a database
db = client[DB_NAME]

# Check if the database exists
if DB_NAME in client.list_database_names():
    print(f"Database '{DB_NAME}' already exists")
else:
    print(f"Database '{DB_NAME}' created")


collections = {}
# Check and create collections
for cols in COLLECTIONS:
    if cols not in db.list_collection_names():
        db.create_collection(cols)
        print(f"Collection '{cols}' created.")
    else:
        print(f"Collection '{cols}' already exists.")
    collections[cols] = db[cols]


#     <------------- Initialize the API --------->
app = Flask(__name__)
app = Flask(__name__, static_folder="static")
# CORS(app, resources={r"/api/*": {"origins": "*"}})

CORS(app)

plant_samples_collection = collections["plant_samples"]
crop_samples_collection = collections["crop_samples"]
plots_collection = collections["plots"]
# collection = collections["crops"]
userCollection = collections['users']
# classroomCollection = collectionss['Classroom']
# notesCollection = collectionss['Notes']


# UPLOAD_FOLDER = './uploads'
# app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER



# Folder to save uploaded files
CROP_UPLOAD_FOLDER = "uploads\\CROP_DATA"
PLOT_UPLOAD_FOLDER = "uploads\\PLOT_DATA"
os.makedirs(CROP_UPLOAD_FOLDER, exist_ok=True)
os.makedirs(PLOT_UPLOAD_FOLDER, exist_ok=True)



# Upload a CSV File that is parsed to be inputted in the database

# Define which columns make a record unique
unique_keys = ["CODE"]  # change to your actual unique columns

@app.route("/uploadCropData", methods=["POST"])
def upload_file():

    if "file" not in request.files:
        return jsonify({"success": False, "message": "No file part"}), 400

    file = request.files["file"]

    if file.filename == "":
        return jsonify({"success": False, "message": "No selected file"}), 400

    if not file.filename.endswith(".csv"):
        return jsonify({"success": False, "message": "File must be CSV"}), 400


    selected_year = request.form.get("year")
    selected_season = request.form.get("season")
    seasonal_crops_collection = selected_year + "_" + selected_season + "_crops"

    if seasonal_crops_collection not in db.list_collection_names():
        db.create_collection(seasonal_crops_collection)
        print(f"Collection '{seasonal_crops_collection}' created.")

    seasonal_crops_collections = db[seasonal_crops_collection]
    # Timestamped folder
    now = datetime.now()
    now_str = now.strftime("%Y_%m_%d_%H_%M_%S")
    updated_folder = os.path.join(CROP_UPLOAD_FOLDER, selected_year, selected_season, now_str)
    os.makedirs(updated_folder, exist_ok=True)

    file_path = os.path.join(updated_folder, file.filename)
    file.save(file_path)

    try:
        # Read CSV with fallback
        try:
            df = pd.read_csv(file_path, encoding='utf-8')
        except UnicodeDecodeError:
            df = pd.read_csv(file_path, encoding='latin1')

        # Clean column names
        df.columns = [col.strip().replace(' ', '_') for col in df.columns]

        # Strip strings
        df = df.apply(lambda col: col.str.strip() if col.dtype == "object" else col)

        # Replace blanks / "*no data"
        df.replace(to_replace=["", "*no data"], value=None, inplace=True)

        if df.empty:
            return jsonify({"success": False, "message": "CSV has no data"}), 400

        # Build set of existing keys in MongoDB
        existing_keys = set()
        for doc in seasonal_crops_collections.find({}, {k: 1 for k in unique_keys}):
            key_tuple = tuple(doc.get(k) for k in unique_keys)
            existing_keys.add(key_tuple)

        # Filter new records only
        new_records = []
        for _, row in df.iterrows():
            key_tuple = tuple(row.get(k) for k in unique_keys)
            if key_tuple not in existing_keys:
                new_records.append(row.to_dict())
                existing_keys.add(key_tuple)  # avoid duplicates within CSV itself

        if not new_records:
            os.remove(file_path)
            return jsonify({"success": True, "filename": file.filename,
                            "inserted_count": 0, "message": "All records are duplicates"}), 200
        


        # Insert new records
        result = seasonal_crops_collections.insert_many(new_records)

        return jsonify({
            "success": True,
            "filename": file.filename,
            "inserted_count": len(result.inserted_ids)
        }), 200

    except pd.errors.EmptyDataError:
        return jsonify({"success": False, "message": "CSV is empty"}), 400
    except Exception as e:
        import traceback
        traceback.print_exc()
        return jsonify({"success": False, "message": str(e)}), 500







@app.route("/getCropSummary", methods=["GET"])
def get_crop_summary():

    selected_season = request.args.get("season", "dry")

    current_year = datetime.now().year
    found_collection = None
    selected_year = None

    # Loop backwards until a collection is found
    for year in range(current_year, current_year - 20, -1):  # limit to last 20 years
        collection_name = f"{year}_{selected_season}_crops"
        if collection_name in db.list_collection_names():
            found_collection = collection_name
            selected_year = str(year)
            break

    if not found_collection:
        return jsonify({
            "success": False,
            "message": "No available crop data found for any recent year"
        }), 404

    seasonal_crops_collections = db[found_collection]

    try:
        # Total number of records
        total_accessions = seasonal_crops_collections.count_documents({})

        # Distinct crop types
        crop_types = seasonal_crops_collections.distinct("CROP_TYPE")
        total_crop_types = len(crop_types)

        # Distinct plots
        plots = seasonal_crops_collections.distinct("PLOT")
        total_plots = len(plots)

        # Distinct fields
        fields = seasonal_crops_collections.distinct("FIELD")
        total_fields = len(fields)

        response_data = {
            "success": True,
            "filters": {
                "year": selected_year,
                "season": selected_season,
                "collection_used": found_collection
            },
            "data": {
                "total_accessions": total_accessions,
                "total_crop_types": total_crop_types,
                "total_plots": total_plots,
                "total_fields": total_fields,
                "crop_types_list": crop_types,
                "plots_list": plots
            }
        }

        # CLEAN NaN BEFORE RETURNING
        response_data = clean_for_json(response_data)

        return jsonify(response_data), 200
    except Exception as e:
        import traceback
        traceback.print_exc()
        return jsonify({"success": False, "message": str(e)}), 500
    
    
# @app.route("/uploadPlotData", methods=["POST"])
# def upload_plot_file():
#     if "file" not in request.files:
#         return jsonify({"success": False, "message": "No file part"}), 400

#     file = request.files["file"]

#     if file.filename == "":
#         return jsonify({"success": False, "message": "No selected file"}), 400

#     if not file.filename.endswith(".csv"):
#         return jsonify({"success": False, "message": "File must be CSV"}), 400

#     selected_year = request.form.get("year")
#     selected_season = request.form.get("season")
#     seasonal_plot_collection = selected_year + "_" + selected_season + "_plots"

#     if seasonal_plot_collection not in db.list_collection_names():
#         db.create_collection(seasonal_plot_collection)
#         print(f"Collection '{seasonal_plot_collection}' created.")
#     # Timestamped folder
#     seasonal_plot_collections = db[seasonal_plot_collection]
#     now = datetime.now()
#     now_str = now.strftime("%Y_%m_%d_%H_%M_%S")
#     updated_folder = os.path.join(PLOT_UPLOAD_FOLDER, selected_year, selected_season,  now_str)
#     os.makedirs(updated_folder, exist_ok=True)

#     file_path = os.path.join(updated_folder, file.filename)
#     file.save(file_path)
#     try:
#         # --- Read CSV with headers ---
#         try:
#             df = pd.read_csv(file_path, header=0, encoding='utf-8')
#         except UnicodeDecodeError:
#             df = pd.read_csv(file_path, header=0, encoding='latin1')

#         if df.empty:
#             return jsonify({"success": False, "message": "CSV has no data"}), 400

#         # --- Normalize headers ---
#         df.columns = [col.strip().replace(" ", "_").upper() for col in df.columns]

#         # --- Define expected columns ---
#         column_headers = [
#             "FIELD", "PLOT", "PLANT_SAMPLE", "CODE", "LAT",
#             "LON", "LENGTH", "WIDTH",
#             "PLANT_SPACING", "ROW_SPACING", "SOIL_TYPE",
#             "SOIL_MOISTURE", "SOIL_TEMPERATURE", "PLANT_HEIGHT"
#         ]

#         # --- Fill missing columns with None ---
#         for col in column_headers:
#             if col not in df.columns:
#                 df[col] = None

#         # --- Reorder columns ---
#         df = df[column_headers]

#         # --- Strip strings ---
#         df = df.apply(lambda col: col.str.strip() if col.dtype == "object" else col)

#         # --- Replace blanks / "*no data" with None ---
#         df.replace(to_replace=["", "*no data"], value=None, inplace=True)

#         # --- Safe type enforcement ---
#         dtype_map = {
#             "FIELD": str,
#             "PLOT": str,
#             "PLANT_SAMPLE": str,
#             "CODE": str,
#             "LAT": float,
#             "LON": float,
#             "LENGTH": float,
#             "WIDTH": float,
#             "PLANT_SPACING": float,
#             "ROW_SPACING": float,
#             "SOIL_TYPE": str,
#             "SOIL_MOISTURE": float,
#             "SOIL_TEMPERATURE": float,
#             "PLANT_HEIGHT": float
#         }

#         def safe_convert(x, col_type):
#             if x is None:
#                 return None
#             try:
#                 return col_type(x)
#             except (ValueError, TypeError):
#                 return None



#         # --- Parse Lat/Lon if in degrees/minutes format ---
#         def parse_coord(coord):
#             if coord is None:
#                 return None
#             try:
#                 coord = str(coord).replace("Â°", ":").replace("°", ":")
#                 parts = coord.split(":")
#                 deg = float(parts[0])
#                 minutes = float(parts[1])
#                 return deg + minutes / 60
#             except:
#                 return None

#         if 'LAT' in df.columns:
#             df['LAT'] = df['LAT'].apply(parse_coord)
#         if 'LON' in df.columns:
#             df['LON'] = df['LON'].apply(parse_coord)



#         for col, col_type in dtype_map.items():
#             if col in df.columns:
#                 df[col] = df[col].apply(lambda x: safe_convert(x, col_type))


#         # --- Avoid duplicates in MongoDB ---
#         unique_keys = ["FIELD", "PLOT", "PLANT_SAMPLE", "CODE"]
#         existing_keys = set()
#         for doc in seasonal_plot_collections.find({}, {k: 1 for k in unique_keys}):
#             key_tuple = tuple(doc.get(k) for k in unique_keys)
#             existing_keys.add(key_tuple)

#         new_records = []
#         for _, row in df.iterrows():
#             key_tuple = tuple(row.get(k) for k in unique_keys)
#             if key_tuple not in existing_keys:
#                 new_records.append(row.to_dict())
#                 existing_keys.add(key_tuple)

#         if not new_records:
#             os.remove(file_path)
#             return jsonify({
#                 "success": True,
#                 "filename": file.filename,
#                 "inserted_count": 0,
#                 "message": "All records are duplicates"
#             }), 200
        




#         # --- Insert new records ---
#         result = seasonal_plot_collections.insert_many(new_records)

#         return jsonify({
#             "success": True,
#             "filename": file.filename,
#             "inserted_count": len(result.inserted_ids)
#         }), 200

#     except pd.errors.EmptyDataError:
#         return jsonify({"success": False, "message": "CSV is empty"}), 400
#     except Exception as e:
#         import traceback
#         traceback.print_exc()
#         return jsonify({"success": False, "message": str(e)}), 500






@app.route("/uploadPlotData", methods=["POST"])
def upload_plot_file():
    if "file" not in request.files:
        return jsonify({"success": False, "message": "No file part"}), 400

    file = request.files["file"]

    if file.filename == "":
        return jsonify({"success": False, "message": "No selected file"}), 400

    if not file.filename.endswith(".csv"):
        return jsonify({"success": False, "message": "File must be CSV"}), 400

    selected_year = request.form.get("year")
    selected_season = request.form.get("season")
    seasonal_plot_collection = selected_year + "_" + selected_season + "_crops"

    if seasonal_plot_collection not in db.list_collection_names():
        db.create_collection(seasonal_plot_collection)
        print(f"Collection '{seasonal_plot_collection}' created.")

    seasonal_plot_collections = db[seasonal_plot_collection]

    now = datetime.now()
    now_str = now.strftime("%Y_%m_%d_%H_%M_%S")

    updated_folder = os.path.join(
        PLOT_UPLOAD_FOLDER, selected_year, selected_season, now_str
    )
    os.makedirs(updated_folder, exist_ok=True)

    file_path = os.path.join(updated_folder, file.filename)
    file.save(file_path)

    try:
        try:
            df = pd.read_csv(file_path, header=0, encoding="utf-8")
        except UnicodeDecodeError:
            df = pd.read_csv(file_path, header=0, encoding="latin1")

        if df.empty:
            return jsonify({"success": False, "message": "CSV has no data"}), 400

        # Normalize headers
        df.columns = [col.strip().replace(" ", "_").upper() for col in df.columns]

        column_headers = [
            "FIELD","PLOT","PLANT_SAMPLE","CODE","LAT",
            "LON","LENGTH","WIDTH",
            "PLANT_SPACING","ROW_SPACING","SOIL_TYPE",
            "SOIL_MOISTURE","SOIL_TEMPERATURE","PLANT_HEIGHT"
        ]

        for col in column_headers:
            if col not in df.columns:
                df[col] = None

        df = df[column_headers]

        df = df.apply(lambda col: col.str.strip() if col.dtype == "object" else col)

        df.replace(to_replace=["", "*no data"], value=None, inplace=True)

        dtype_map = {
            "FIELD": str,
            "PLOT": str,
            "PLANT_SAMPLE": str,
            "CODE": str,
            "LAT": float,
            "LON": float,
            "LENGTH": float,
            "WIDTH": float,
            "PLANT_SPACING": float,
            "ROW_SPACING": float,
            "SOIL_TYPE": str,
            "SOIL_MOISTURE": float,
            "SOIL_TEMPERATURE": float,
            "PLANT_HEIGHT": float
        }

        def safe_convert(x, col_type):
            if x is None:
                return None
            try:
                return col_type(x)
            except (ValueError, TypeError):
                return None

        def parse_coord(coord):
            if coord is None:
                return None
            try:
                coord = str(coord).replace("Â°", ":").replace("°", ":")
                parts = coord.split(":")
                deg = float(parts[0])
                minutes = float(parts[1])
                return deg + minutes / 60
            except:
                return None

        if "LAT" in df.columns:
            df["LAT"] = df["LAT"].apply(parse_coord)

        if "LON" in df.columns:
            df["LON"] = df["LON"].apply(parse_coord)

        for col, col_type in dtype_map.items():
            if col in df.columns:
                df[col] = df[col].apply(lambda x: safe_convert(x, col_type))

        # -----------------------------
        # UPDATE plot_info USING CODE
        # -----------------------------

        updated_count = 0
        not_found = 0

        for _, row in df.iterrows():

            code = row.get("CODE")

            if not code:
                continue

            plot_info = {
                "LAT": row.get("LAT"),
                "LON": row.get("LON"),
                "LENGTH": row.get("LENGTH"),
                "WIDTH": row.get("WIDTH"),
                "PLANT_SPACING": row.get("PLANT_SPACING"),
                "ROW_SPACING": row.get("ROW_SPACING"),
                "SOIL_TYPE": row.get("SOIL_TYPE"),
                "SOIL_MOISTURE": row.get("SOIL_MOISTURE"),
                "SOIL_TEMPERATURE": row.get("SOIL_TEMPERATURE"),
                "PLANT_HEIGHT": row.get("PLANT_HEIGHT")
            }

            result = seasonal_plot_collections.update_one(
                {"CODE": code},
                {"$set": {"plot_info": plot_info}}
            )

            if result.matched_count > 0:
                updated_count += 1
            else:
                not_found += 1

        return jsonify({
            "success": True,
            "filename": file.filename,
            "inserted_count": updated_count,
            "codes_not_found": not_found
        }), 200

    except pd.errors.EmptyDataError:
        return jsonify({"success": False, "message": "CSV is empty"}), 400

    except Exception as e:
        import traceback
        traceback.print_exc()
        return jsonify({"success": False, "message": str(e)}), 500


@app.route("/signin", methods=["POST"])
def signin_user():

    try:
        data = request.get_json()

        email = data.get("email")
        password = data.get("password")

        if not email or not password:
            return jsonify({
                "success": False,
                "message": "Email and password required"
            }), 400

        import hashlib

        hashed_password = hashlib.sha256(
            password.encode()
        ).hexdigest()

        # -----------------------------
        # FIND USER
        # -----------------------------

        user = userCollection.find_one({
            "email": email,
            "password": hashed_password
        })

        if not user:
            return jsonify({
                "success": False,
                "message": "Invalid email or password"
            }), 401

        # -----------------------------
        # CHECK EMAIL VERIFICATION
        # -----------------------------

        if not user.get("isVerified", False):

            return jsonify({
                "success": False,
                "message": "Email not verified",
                "isVerified": False
            }), 403

        # -----------------------------
        # LOGIN SUCCESS
        # -----------------------------

        # Remove password before sending
        user.pop("password", None)

        # Convert ObjectId to string
        user["_id"] = str(user["_id"])

        return jsonify({
            "success": True,
            "user": user
        }), 200

    except Exception as e:

        import traceback
        traceback.print_exc()

        return jsonify({
            "success": False,
            "message": str(e)
        }), 500

@app.route("/signup", methods=["POST"])
def signup_user():

    try:
        data = request.get_json()

        if not data:
            return jsonify({
                "success": False,
                "message": "No JSON data received"
            }), 400

        full_name = data.get("fullName")
        agency = data.get("agency")
        email = data.get("email")
        password = data.get("password")
        role = data.get("role", "user")  # default role
        isVerified = data.get("isVerified", False)

        # -----------------------------
        # VALIDATION
        # -----------------------------

        if not full_name:
            return jsonify({
                "success": False,
                "message": "Full name is required"
            }), 400

        if not agency:
            return jsonify({
                "success": False,
                "message": "Agency is required"
            }), 400

        if not email:
            return jsonify({
                "success": False,
                "message": "Email is required"
            }), 400

        if not password:
            return jsonify({
                "success": False,
                "message": "Password is required"
            }), 400
        
        # -----------------------------
        # CHECK DUPLICATE EMAIL
        # -----------------------------

        existing_user = userCollection.find_one({
            "email": email
        })

        if existing_user:
            return jsonify({
                "success": False,
                "message": "Email already exists"
            }), 409

        # -----------------------------
        # HASH PASSWORD
        # -----------------------------

        import hashlib

        hashed_password = hashlib.sha256(
            password.encode()
        ).hexdigest()

        email_sent, token = send_verification_email(email)

        if not email_sent:
            return jsonify({
                "success": False,
                "message": "Failed to send verification email"
            }), 500


        # -----------------------------
        # CREATE USER DOCUMENT
        # -----------------------------

        user_document = {
            "fullName": full_name,
            "agency": agency,
            "email": email,
            "password": hashed_password,
            "role": role,
            "isVerified": isVerified
        }

        result = userCollection.insert_one(
            user_document
        )

        return jsonify({
            "success": True,
            "message": "User created successfully",
            "user_id": str(result.inserted_id)
        }), 201


    except Exception as e:
        import traceback
        traceback.print_exc()

        return jsonify({
            "success": False,
            "message": str(e)
        }), 500





@app.route("/verify-email/<token>", methods=["GET"])
def verify_email(token):

    try:

        email = serializer.loads(
            token,
            salt="email-verification",
            max_age=3600  # 1 hour
        )

        result = userCollection.update_one(
            {"email": email},
            {
                "$set": {
                    "isVerified": True
                },
                "$unset": {
                    "verificationToken": ""
                }
            }
        )

        if result.modified_count > 0:

           return f"""
<!DOCTYPE html>
<html>
<head>
    <title>Email Verified - CropBio</title>

    <style>

        body {{
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
            background-color: #0F172A;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }}

        .container {{
            width: 100%;
            max-width: 520px;
            padding: 40px;
            background: white;
            border-radius: 16px;
            text-align: center;
            box-shadow: 0 8px 24px rgba(0,0,0,0.15);
        }}

        .logo-box {{
            height: 120px;
            border-radius: 16px;
            background: rgba(63,107,42,0.08);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 25px;
        }}

        .title {{
            font-size: 28px;
            font-weight: bold;
            color: #111827;
            margin-bottom: 12px;
        }}

        .message {{
            font-size: 16px;
            color: #374151;
            margin-bottom: 30px;
            line-height: 1.6;
        }}

        .success-icon {{
            font-size: 60px;
            color: #3F6B2A;
            margin-bottom: 20px;
        }}

        .login-btn {{
            display: inline-block;
            padding: 14px 28px;
            background-color: #3F6B2A;
            color: white;
            text-decoration: none;
            border-radius: 10px;
            font-weight: bold;
        }}

        .login-btn:hover {{
            background-color: #355a23;
        }}

    </style>

</head>

<body>

    <div class="container">

        <div class="logo-box">

            <img src="http://localhost:5000/static/Cropbio_Logo_Dark.svg"
                 alt="CropBio Logo"
                 height="60">

        </div>

        <div class="success-icon">
            ✔
        </div>

        <div class="title">
            Email Verified Successfully
        </div>

        <div class="message">
            Your email has been verified.  
            You can now log in and start using the CropBio system.
        </div>

        <a href="http://localhost:3000/signin"
           class="login-btn">
           Go to Login
        </a>

    </div>

</body>

</html>
"""

        else:

            return """
<!DOCTYPE html>
<html>
<body style="
    background:#0F172A;
    display:flex;
    align-items:center;
    justify-content:center;
    height:100vh;
    font-family:Arial;
">

<div style="
    background:white;
    padding:40px;
    border-radius:16px;
    text-align:center;
">

<h2 style="color:#DC2626;">
Verification Failed
</h2>

<p>
Invalid or expired verification link.
</p>

</div>

</body>
</html>
"""

    except Exception as e:

        print(e)

        return """
        <h2>Invalid or Expired Token</h2>
        """


def clean_for_json(doc):
    """
    Recursively convert NaN/Infinity in dict to None
    """
    if isinstance(doc, dict):
        return {k: clean_for_json(v) for k, v in doc.items()}
    elif isinstance(doc, list):
        return [clean_for_json(item) for item in doc]
    elif isinstance(doc, float) and (math.isnan(doc) or math.isinf(doc)):
        return None
    else:
        return doc




@app.route("/fetch_all", methods=["GET"])
def fetch_all():
    try:
        # Get all documents and convert ObjectId to string
        summary_crop_samples_collections = db['2025_Dry_crops']
        records = []
        for doc in summary_crop_samples_collections.find():
            doc["_id"] = str(doc["_id"])
            doc = clean_for_json(doc)  # <-- clean NaN / Inf
            records.append(doc)

        return jsonify({"success": True, "data": records}), 200

    except Exception as e:
        import traceback
        traceback.print_exc()
        return jsonify({"success": False, "message": str(e)}), 500








