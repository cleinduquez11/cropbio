import 'dart:convert';
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
