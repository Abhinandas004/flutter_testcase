import 'package:flutter/cupertino.dart';
import '../Model/user_model.dart';

class UserViewModel extends ChangeNotifier {
  final List<UserModel> _allUsers = [];
  final List<UserModel> _visibleUsers = [];

  static const int _pageSize = 10;
  int _currentPage = 0;
  bool _isLoading = false;

  String _selectedSort = 'All';
  String _searchQuery = '';

  List<UserModel> get users => _visibleUsers;
  bool get isLoading => _isLoading;

  String get selectedSort => _selectedSort;

  void addUser(UserModel user) {
    _allUsers.insert(0, user);
    _applyFilters(reset: true);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters(reset: true);
  }

  void setSort(String sort) {
    _selectedSort = sort;
    _applyFilters(reset: true);
  }
  // lazy loading
  Future<void> loadMore() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(milliseconds: 800)); // simulate API

    _currentPage++;
    _applyFilters();

    _isLoading = false;
    notifyListeners();
  }

  void _applyFilters({bool reset = false}) {
    if (reset) {
      _currentPage = 0;
      _visibleUsers.clear();
    }

    List<UserModel> temp = List.from(_allUsers);

    // search
    if (_searchQuery.isNotEmpty) {
      temp = temp
          .where((u) =>
          u.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // sort
    if (_selectedSort == 'Age: Elder') {
      temp.sort((a, b) => b.age.compareTo(a.age));
    } else if (_selectedSort == 'Age: Younger') {
      temp.sort((a, b) => a.age.compareTo(b.age));
    }

    final start = _currentPage * _pageSize;
    final end = (start + _pageSize).clamp(0, temp.length);

    if (start < end) {
      _visibleUsers.addAll(temp.sublist(start, end));
    }

    notifyListeners();
  }
}