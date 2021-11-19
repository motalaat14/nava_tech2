import 'package:flutter/material.dart';

class FcmTokenProvider with ChangeNotifier{
  String _fcmToken="";

  String get fcmToken => _fcmToken;

  set fcmToken(String value) {
    _fcmToken = value;
    notifyListeners();
  }




//
  // int get status => _fcmToken;
  //
  // set status(int value) {
  //   _fcmToken = value;
  //   notifyListeners();
  // }
}