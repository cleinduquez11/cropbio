import 'package:flutter/material.dart';

class NewsProvider extends ChangeNotifier {
  String _query = "";

  String get query => _query;

  void updateQuery(String value) {
    if (_query == value) return;

    _query = value;
    notifyListeners();
  }
}
