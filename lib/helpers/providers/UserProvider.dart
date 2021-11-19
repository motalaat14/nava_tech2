import 'package:flutter/cupertino.dart';

class User {
  User({this.id, this.name, this.title, this.status, this.email, this.phone, this.wallet, this.lang, this.avatar, this.token});

  int id;
  String name;
  String title;
  String status;
  String email;
  String phone;
  String wallet;
  String lang;
  String avatar;
  String token;
}

class UserProvider with ChangeNotifier{
  User _user = User();

  User get user => _user;

  set user(User value) {
    _user = value;
    notifyListeners();
  }
}
