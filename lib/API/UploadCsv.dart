
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

  import 'package:flutter/material.dart';
import 'package:http/http.dart';



Future<void> uploadCsvWeb(Uint8List fileBytes, String fileName, BuildContext context) async {
  final uri = Uri.parse("http://192.168.10.106:5000/upload");

  // Create multipart request
  var request = http.MultipartRequest('POST', uri);
  request.files.add(http.MultipartFile.fromBytes(
    'file',
    fileBytes,
    filename: fileName,
    contentType: MediaType('text', 'csv'),
  ));

  // Await response properly for web
  try {
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    // Parse JSON from Flask response
    if (response.statusCode == 200) {
      final jsonResponse = response.body;
      print("Upload successful: $jsonResponse");
                ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("File upload successful!")),
      );
    } else {
      print("Upload failed: ${response.statusCode} ${response.body}");
                ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("File upload failed")),
      );
    }
  } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("File upload failed")),
      );
    // Only network/CORS issues reach here
    print("Upload error: $e");
  }
}
