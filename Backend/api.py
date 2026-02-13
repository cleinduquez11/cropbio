import os
from flask import Flask, jsonify, request, send_from_directory, abort
from pymongo import MongoClient
from bson.objectid import ObjectId
import json
from flask_cors import CORS
from bson import ObjectId
from urllib.parse import quote_plus
from config import MONGO_URI, DB_NAME, COLLECTIONS

username = "coastermmsu7_db_user"
password = "@Admin12345"   # ← may contain special chars
encoded_password = quote_plus(password)

URI = f"mongodb+srv://{username}:{encoded_password}@cropbio.ug6av4c.mongodb.net"


# Create a MongoDB client
client = MongoClient(MONGO_URI)

# Create a database
db = client[DB_NAME]

# Check if the database exists
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


#     <------------- Initialize the API --------->
app = Flask(__name__)
CORS(app, resources={r"/api/*": {"origins": "*"}})



collection = collectionss["Tasklist"]
userCollection = collectionss['Users']
classroomCollection = collectionss['Classroom']
notesCollection = collectionss['Notes']


UPLOAD_FOLDER = './uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER









#     <------------- End of API Initialization --------->

@app.route('/api/download/<path:filename>', methods=['GET'])
def download_file(filename):

    try:
        return send_from_directory(app.config['UPLOAD_FOLDER'], filename , as_attachment=True)
    except FileNotFoundError:
        abort(404, description="File not found")




# 1    <------------- Scheduled task API --------->

@app.route('/api/task', methods=['GET'])
def get_tasks():
    data = list(collection.find({})) 

    # Extracting specified fields from the data
    result = [{"id": d["id"], "title": d["title"], 
               "note": d["note"], 
               "date": d["date"], 
               "startTime": d["startTime"], "endTime": d["endTime"],
                 "remindTime": d["remindTime"], "repeat": d["repeat"],
                 "color": d["color"],  "userId": d["userId"]
                 } 
              for d in data]
    
    print(result)
    if result:
        return jsonify(result)
    else:
        return jsonify({"status": "failed"}), 400





@app.route('/api/taskByUserId', methods=['GET'])
def get_tasks_by_id():
    userId = request.args.get('userId')

    if not userId:
        return jsonify({"error": "instructorId query parameter is required"}), 400


    # Query the database for all classes with the given instructorId
    class_data_cursor = collection.find({"userId": userId})

    # Convert the cursor to a list and serialize the data
    # class_data_list = [serialize_class(class_data) for class_data in class_data_cursor]

    # if not class_data_list:
    #     return jsonify({"error": "No classes found for the given instructorId"}), 404
    # print(class_data_list)


    result = [{"id": d["id"], "title": d["title"], 
            "note": d["note"], 
            "date": d["date"], 
            "startTime": d["startTime"], "endTime": d["endTime"],
                "remindTime": d["remindTime"], "repeat": d["repeat"],
                "color": d["color"],  "userId": d["userId"]
                } 
            for d in class_data_cursor]

    print(result)
    if result:
        return jsonify(result)
    else:
        return jsonify({"status": "failed"}), 400
        # Return the classes as a response


    # Extracting specified fields from the data




@app.route('/api/task', methods=['POST'])
def add_task():
    new_entry = request.get_json()
    if not new_entry:
        return jsonify({"error": "No input data provided"}), 400
    

    Id = ObjectId()
    print(new_entry) 
    new_entry["_id"] = Id
    new_entry["id"] =  str(Id)
    print(new_entry)
    collection.insert_one(new_entry)
    return jsonify({"status": "success"}), 200




@app.route('/api/task', methods=['PATCH'])
def edit_task():
    new_entry = request.get_json()
    if not new_entry:
        return jsonify({"error": "No input data provided"}), 400
    
    document_id = ObjectId(str(new_entry["id"])) 
    print(document_id)
    print(new_entry)
    
    filter_criteria = {"_id": document_id} 
    update_data = {"$set": new_entry}
    res = collection.update_one(filter_criteria,update_data )
    return jsonify({"status": "success"}), 200




@app.route('/api/task', methods=['DELETE'])
def delete_task():
    new_entry = request.get_json()
    if not new_entry:
        return jsonify({"error": "No input data provided"}), 400
    
    document_id = ObjectId(str(new_entry["id"])) 
    print(new_entry)
    filter_criteria = {"_id": document_id} 
    result = collection.delete_one(filter_criteria)
    print(new_entry)

    if result.deleted_count == 1:
        print("Document deleted successfully.")
        return jsonify({"status": "success"}), 200

    else:
        print("Document not found or not deleted.")
        return jsonify({"status": "failed"}), 200


#     <-------------  End of Scheduled task  --------->







#2    <------------- Online Classroom API  --------->

@app.route('/api/class', methods=['POST'])
def add_class():
    new_entry = request.get_json()
    if not new_entry:
        return jsonify({"error": "No input data provided"}), 400
    

    print(new_entry) 
    new_entry["_id"] =  ObjectId()
    print(new_entry)
    classroomCollection.insert_one(new_entry)
    return jsonify({"status": "success", "classId": str(new_entry["_id"]) }), 200



@app.route('/api/class', methods=['GET'])
def get_class():
    data = list(classroomCollection.find({})) 

    # Extracting specified fields from the data
    result = [{"id": str(d["_id"]), "classname": d["classname"], 
               "description": d["description"], 
               "color": d["color"], 
               "students": d["students"],
               "announcement": d["announcement"], "instructor": d["instructor"],  "instructorId": d["instructorId"]
                 } 
              for d in data]
    
    print(result)
    if result:
        return jsonify(result)
    else:
        return jsonify({"status": "failed"}), 400




def serialize_class(class_data):
    class_data['_id'] = str(class_data['_id']) 
    class_data['id'] = str(class_data['_id'])  # Convert ObjectId to string
    return class_data

@app.route('/api/getClassByInstructorId', methods=['GET'])
def get_class_by_instructor_id():
    instructor_id = request.args.get('instructorId')

    if not instructor_id:
        return jsonify({"error": "instructorId query parameter is required"}), 400

    try:
        # Query the database for all classes with the given instructorId
        class_data_cursor = classroomCollection.find({"instructorId": instructor_id})

        # Convert the cursor to a list and serialize the data
        class_data_list = [serialize_class(class_data) for class_data in class_data_cursor]

        if not class_data_list:
            return jsonify({"error": "No classes found for the given instructorId"}), 404
        print(class_data_list)
        # Return the classes as a response
        return jsonify({
            "classes": class_data_list
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500



@app.route('/api/getClassByStudentId', methods=['GET'])
def get_class_by_student_id():
    studentId = request.args.get('studentId')

    if not studentId:
        return jsonify({"error": "instructorId query parameter is required"}), 400

    try:
        # Query the database for all classes with the given instructorId
        class_data_cursor = classroomCollection.find({"students": studentId})

        # Convert the cursor to a list and serialize the data
        class_data_list = [serialize_class(class_data) for class_data in class_data_cursor]

        if not class_data_list:
            return jsonify({"error": "No classes found for the given instructorId"}), 404
        print(class_data_list)
        # Return the classes as a response
        return jsonify({
            "classes": class_data_list
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    





@app.route('/api/joinClass', methods=['POST'])
def join_class():
    userid = request.form.get('userId')
    classId = request.form.get('classId')

    if not userid or not classId:
        return jsonify({"error": "userId and classId are required"}), 400

    try:
        # Check if the user is already in the class
        class_data = classroomCollection.find_one({"_id": ObjectId(classId), "students": userid})

        if class_data:
            return jsonify({"status": "error","message": "You already joined this Class"}), 200  # 409 Conflict

        # If the user is not in the class, add them to the 'students' array
        result = classroomCollection.update_one(
            {"_id": ObjectId(classId)},  # Find class by its _id
            {"$addToSet": {"students": userid}}  # $addToSet avoids duplicates
        )

        if result.modified_count == 0:
            return jsonify({"status": "error", "message": "No Data"}), 200

        print(f"User {userid} added to class {classId}")

        return jsonify({"status": "success"}), 200

    except Exception as e:
        return jsonify({"status": "error", "message": "Server Error"}), 500


#2    <------------- End of Classroom API  --------->









#3    <------------- Announcement API  --------->



@app.route('/api/announcementFile', methods=['POST'])
def add_announcement_with_file():
    if 'file' not in request.files:
        return jsonify({"error": "No file part in the request"}), 400

    file = request.files['file']

    if file.filename == '':
        return jsonify({"error": "No file selected for uploading"}), 400
    dat = request.form.get('dat')
    data = json.loads(dat)



    
    upload_dir = os.path.join(app.config['UPLOAD_FOLDER'] , data['classname'], data['type'], data['title'])
    # nested_dir = os.path.join(data['college'], data['department'])
    os.makedirs(upload_dir, exist_ok=True)
    file_path = os.path.join(upload_dir, file.filename)
    nested_dir = str(data['classname']) + '/' + str(data['type']) + '/'+ str(data['title']) + '/'  + str(file.filename)
    file.save(file_path)


    document = {
                    'title': data['title'],
                                    'description': data['description'],
                                "type": data['type'],
                                "duedate": data['duedate'],
                                "filename": data['filename'],
                                 "postedDate": data['postedDate'],
                                "filepath": nested_dir,

                                }


    # Update the class document by pushing the new announcement to the 'announcement' array
    result = classroomCollection.update_one(
        {"_id": ObjectId(data['classId'])},  # Find class by its _id
        {"$push": {"announcement": document}}  # Add the announcement to the array
    )
    print(f"Content: {data}")
    print(f"File saved to: {file_path}")

    return jsonify({"status": "success", "filename": file.filename}), 200




@app.route('/api/announcement', methods=['POST'])
def add_announcement():

    dat = request.form.get('dat')
    data = json.loads(dat)



    
    # upload_dir = os.path.join(app.config['UPLOAD_FOLDER'] , data['classname'], data['type'], data['title'])
    # # nested_dir = os.path.join(data['college'], data['department'])
    # os.makedirs(upload_dir, exist_ok=True)
    # file_path = os.path.join(upload_dir, file.filename)
    # # nested_dir = str(data['college']) + '/' + str(data['department']) + '/' + str(file.filename)
    # file.save(file_path)


    document = {
                    'title': data['title'],
                                    'description': data['description'],
                                "type": data['type'],
                                "duedate": data['duedate'],
                                "filename": data['filename'],
                                "postedDate": data['postedDate'],
                                }


    # Update the class document by pushing the new announcement to the 'announcement' array
    result = classroomCollection.update_one(
        {"_id": ObjectId(data['classId'])},  # Find class by its _id
        {"$push": {"announcement": document}}  # Add the announcement to the array
    )
    print(f"Content: {data}")
    # print(f"File saved to: {file_path}")

    return jsonify({"status": "success"}), 200









@app.route('/api/getAnnouncementById', methods=['GET'])
def get_announcement_by_id():
    # Get the classId from query parameters
    class_id = request.args.get('classId')

    if not class_id:
        return jsonify({"error": "classId query parameter is required"}), 400

    try:
        # Query the database for the class using the provided classId (assuming it's an ObjectId)
        class_data = classroomCollection.find_one({"_id": ObjectId(class_id)})

        if not class_data:
            return jsonify({"error": "Class not found"}), 404

        # Extract the announcements
        announcements = class_data.get('announcement', [])

        # Return the announcements as a response
        return jsonify({
            "announcements": announcements
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500






#4    <------------- User API  --------->

@app.route('/api/register', methods=['POST'])
def register():
    new_entry = request.get_json()
    if not new_entry:
        return jsonify({"error": "No input data provided"}), 400
    


    print(new_entry)


    existing_email = userCollection.find_one(
        {
            "$or": [
                {"email": new_entry['email']},
            ]
        }
    )
    remarks = []
    if existing_email:
        remarks.append('Email')



    if existing_email:
        return jsonify({
            "status": "failed",
            'message': remarks
        }), 200
    new_entry["_id"] = ObjectId()
    userCollection.insert_one(new_entry)
    return jsonify({"status": "success"}), 200






@app.route('/api/login', methods=['POST'])
def login():
    new_entry = request.get_json()
    if not new_entry:
        return jsonify({"error": "No input data provided"}), 400
    

    print(new_entry)
    user = userCollection.find_one({'email':new_entry['email'], 'password':new_entry['password']})
    print(user)

    if(user == None):
        return jsonify({"status": "failed"}), 200
    else:
        return jsonify({"status": "success", "userId": str(user['_id']), "role": str(user['role']) , "name": str(user['name'][0]), "fullname": str(user['name'][0] + " " + user['name'][1] + " " + user['name'][2])}), 200

    

#4    <------------- End of User API  --------->
    
    







#5    <------------- Notes API  --------->
    
    

@app.route('/api/note', methods=['POST'])
def add_note():



    dat = request.form.get('dat')
    data = json.loads(dat)

    if data["title"] == "" and data["content"] == "":
        return jsonify({"status": "success", "message": "empty"}), 200

    Id = ObjectId()

    data["_id"] =  Id
    data["id"] =  str(Id)
    print(data)
    notesCollection.insert_one(data)
    print(f"Content: {data}")

    return jsonify({"status": "success"}), 200







@app.route('/api/getNotesByID', methods=['GET'])
def get_notes_by_user_id():
    userId = request.args.get('userId')

    if not userId:
        return jsonify({"error": "instructorId query parameter is required"}), 400

    try:
        # Query the database for all classes with the given instructorId
        class_data_cursor = notesCollection.find({"userId": userId})

        # Convert the cursor to a list and serialize the data
        class_data_list = [serialize_class(class_data) for class_data in class_data_cursor]

        if not class_data_list:
            return jsonify({"error": "No classes found for the given user Id"}), 404
        print(class_data_list)
        # Return the classes as a response
        return jsonify({
            "notes": class_data_list
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    



@app.route('/api/note', methods=['PATCH'])
def edit_note():
    new_entry = request.get_json()
    if not new_entry:
        return jsonify({"error": "No input data provided"}), 400
    
    document_id = ObjectId(new_entry["id"])
    print(document_id)
    print(new_entry)
    
    filter_criteria = {"_id": document_id} 
    update_data = {"$set": new_entry}
    res = notesCollection.update_one(filter_criteria,update_data )
    return jsonify({"status": "success"}), 200

    

@app.route('/api/note', methods=['DELETE'])
def delete_note():
    new_entry = request.get_json()
    if not new_entry:
        return jsonify({"error": "No input data provided"}), 400
    
    document_id = ObjectId(str(new_entry["id"])) 
    print(new_entry)
    filter_criteria = {"_id": document_id} 
    result = notesCollection.delete_one(filter_criteria)
    print(new_entry)

    if result.deleted_count == 1:
        print("Document deleted successfully.")
        return jsonify({"status": "success"}), 200

    else:
        print("Document not found or not deleted.")
        return jsonify({"status": "failed"}), 200



#5    <------------- End of Notes API  --------->
    


# Run the server on locally and within the Network
if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0')
