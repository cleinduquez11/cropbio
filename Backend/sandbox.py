import os
from flask import Flask, jsonify, request, send_from_directory, abort
from pymongo import MongoClient
from bson.objectid import ObjectId
import json
from flask_cors import CORS
from bson import ObjectId
from urllib.parse import quote_plus
from config import MONGO_URI, DB_NAME, COLLECTIONS

try:
    client = MongoClient(MONGO_URI)
    client.admin.command("ping")  # Force connection check
    print("Connected to MongoDB")
except Exception as e:
    print("Error connecting to MongoDB:", e)
    exit()

db = client[DB_NAME]


if DB_NAME in client.list_database_names():
    print(f"Database '{DB_NAME}' already exists")
else:
    print(f"Database '{DB_NAME}' created")

collectionss = {}
# Check and create collections
for collection in COLLECTIONS:
    if collection not in db.list_collection_names():
        db.create_collection(collection)
        print(f"Collection '{collection}' created.")
    else:
        print(f"Collection '{collection}' already exists.")
    collectionss[collection] = db[collection]


                                                       
                                                       