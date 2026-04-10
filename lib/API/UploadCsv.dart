import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cropbio/Configs/config.dart';
import 'package:cropbio/Widgets/CustomSnackbar.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:http/http.dart';

Future<dynamic> uploadCropData(Uint8List fileBytes, String fileName,
    String selectedYear, String selectedSeason) async {
  final uri = Uri.parse("${Config.baseUrl}/uploadCropData");

  // Create multipart request
  var request = http.MultipartRequest('POST', uri);

  // Attach the CSV file
  request.files.add(http.MultipartFile.fromBytes(
    'file',
    fileBytes,
    filename: fileName,
    contentType: MediaType('text', 'csv'),
  ));

  // Add the selected year and season as fields
  request.fields['year'] = selectedYear;
  request.fields['season'] = selectedSeason;

  try {
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
      final jsonResponse = response.body;
      var rs = jsonDecode(jsonResponse);
    if (response.statusCode == 200) {

      print("Upload successful: $jsonResponse");
      return rs;
    } else {
      print("Upload failed: ${response.statusCode} ${response.body}");
      return rs;
    }
  } catch (e) {
    print("Upload error: $e");
  }
}

Future<dynamic> uploadPlotData(Uint8List fileBytes, String fileName,
    String selectedYear, String selectedSeason) async {
  final uri = Uri.parse("http://localhost:5000/uploadPlotData");

  // Create multipart request
  var request = http.MultipartRequest('POST', uri);
  request.files.add(http.MultipartFile.fromBytes(
    'file',
    fileBytes,
    filename: fileName,
    contentType: MediaType('text', 'csv'),
  ));

  request.fields['year'] = selectedYear;
  request.fields['season'] = selectedSeason;

  // Await response properly for web
  try {
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final jsonResponse = response.body;
    var rs = jsonDecode(jsonResponse);
    // Parse JSON from Flask response
    if (response.statusCode == 200) {
      return rs;
    } else if(response.statusCode == 400) {
      print("Upload failed: ${response.statusCode} ${response.body}");
      return rs;
    }
    else {
            print("Upload failed: ${response.statusCode} ${response.body}");
      return rs;
    }
  } catch (e) {
    // Only network/CORS issues reach here
    print("Upload error: $e");
  }
}
