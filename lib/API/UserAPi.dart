import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchUsers({
  required String apiUrl,
}) async {
  try {
    final response = await http.get(Uri.parse(apiUrl));
      print(response.body);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final List data = decoded["data"];

      return List<Map<String, dynamic>>.from(data);
    }

    return [];
  } catch (e) {
    print("Fetch users error: $e");
    return [];
  }
}
