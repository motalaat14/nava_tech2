import 'package:flutter/material.dart';

class StatusProvider with ChangeNotifier {
  String _status = "";

  String get status => _status;

  set status(String value) {
    _status = value;
    notifyListeners();
  }
}
