import 'dart:convert';
import 'package:cropbio/Models/Crop_Summary.dart';
import 'package:http/http.dart' as http;

/// Fetch crop samples from Flask API
Future<List<Map<String, dynamic>>> fetchCropSamples(
    {required String apiUrl}) async {
  try {
    final url = Uri.parse(apiUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        // Convert JSON array to List<Map>
        // print(data["data"]);
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        print('API error: ${data['message']}');
        return [];
      }
    } else {
      print('HTTP error: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    
    print('Exception: $e');
    return [];
  }
}


Future<List<Map<String, dynamic>>> fetchAll(
    {required String apiUrl}) async {
  try {
    final url = Uri.parse(apiUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        // Convert JSON array to List<Map>
        // print(data["data"]);
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        print('API error: ${data['message']}');
        return [];
      }
    } else {
      print('HTTP error: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    
    print('Exception: $e');
    return [];
  }
}

const String baseUrl = "http://localhost:5000";
// http://192.168.1.5:5000/getCropSummary?season=dry
Future<CropSummary?> fetchCropSummary() async {
  try {
    final response = await http.get(
      Uri.parse("$baseUrl/getCropSummary?season=Dry"),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData["success"] == true) {
        return CropSummary.fromJson(jsonData);
      } else {
        throw Exception(jsonData["message"]);
      }
    } else {
      throw Exception("Failed to load data");
    }
  } catch (e) {
    print("API Error: $e");
    return null;
  }
}
