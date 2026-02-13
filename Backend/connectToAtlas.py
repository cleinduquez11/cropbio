from pymongo import MongoClient
from urllib.parse import quote_plus
from config import MONGO_URI, DB_NAME, COLLECTIONS
from datetime import datetime
import random

try:
    client = MongoClient(MONGO_URI)
    client.admin.command("ping")  # Force connection check
    print("Connected to MongoDB")
except Exception as e:
    print("Error connecting to MongoDB:", e)
    exit()

db = client[DB_NAME]

# Example collection (change if needed)
collection = db[COLLECTIONS[0]]

# Generate dummy documents
dummy_data = []

for i in range(1, 11):
    document = {
        "field": f"Field-{random.randint(1,3)}",
        "plot": f"Plot-{random.randint(1,5)}",
        "plant_sample": f"Sample-{i}",
        "code": f"PS-{1000+i}",
        "crop_type": random.choice(["Rice", "Corn", "Wheat"]),
        "biomass": {
            "fresh_weight": round(random.uniform(100, 500), 2),
            "dry_weight": round(random.uniform(50, 250), 2)
        },
        "leaf_metrics": {
            "average_leaf_area": round(random.uniform(10, 50), 2),
            "corrected_leaf_area": round(random.uniform(8, 45), 2)
        },
        "location": {
            "latitude": round(random.uniform(10.0, 15.0), 6),
            "longitude": round(random.uniform(120.0, 125.0), 6)
        },
        "date_recorded": datetime.utcnow()
    }

    dummy_data.append(document)

# Insert into MongoDB
result = collection.insert_many(dummy_data)

print(f"{len(result.inserted_ids)} dummy records inserted successfully!")