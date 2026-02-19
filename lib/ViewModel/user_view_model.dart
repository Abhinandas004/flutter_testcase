import 'package:flutter/material.dart';

import '../Model/user_model.dart';


class UserViewModel extends ChangeNotifier {
  final List<UserModel> _users = [];

  List<UserModel> get users => _users;

  // Add user
  void addUser(UserModel user) {
    _users.add(user);
    notifyListeners();
  }

  // Sort by elder
  void sortByElder() {
    _users.sort((a, b) => b.age.compareTo(a.age));
    notifyListeners();
  }

  // Sort by younger
  void sortByYounger() {
    _users.sort((a, b) => a.age.compareTo(b.age));
    notifyListeners();
  }
}
