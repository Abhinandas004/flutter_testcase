import 'package:flutter/material.dart';
import '../Model/user_model.dart';

class UserViewModel extends ChangeNotifier {
  final List<UserModel> _users = [];

  String _selectedSort = 'All';
  String _searchQuery = '';

  List<UserModel> get users {
    List<UserModel> temp = List.from(_users);
    if (_searchQuery.isNotEmpty) {
      temp = temp
          .where((user) =>
          user.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    if (_selectedSort == 'Age: Elder') {
      temp.sort((a, b) => b.age.compareTo(a.age));
    } else if (_selectedSort == 'Age: Younger') {
      temp.sort((a, b) => a.age.compareTo(b.age));
    }
    return temp;
  }
  String get selectedSort => _selectedSort;

  void addUser(UserModel user) {
    _users.add(user);
    notifyListeners();
  }

  void setSort(String sort) {
    _selectedSort = sort;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
