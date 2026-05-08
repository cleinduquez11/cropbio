import 'package:flutter/material.dart';
import 'package:cropbio/API/fetchAll.dart';
import 'package:cropbio/Models/Crop_Summary.dart';

class LandingProvider extends ChangeNotifier {

  CropSummary? summaryData;
  bool isLoading = true;

  Future<void> initialize() async {

    if(summaryData != null) return;

    final result = await fetchCropSummary();

    summaryData = result;
    isLoading = false;

    notifyListeners();
  }
}