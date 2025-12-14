import 'package:flutter/material.dart';

class UsersProvider with ChangeNotifier {
  final List<String> _users = [];

  List<String> get users => _users;

  void addUser(String user) {
    if (user.isNotEmpty) {
      _users.add(user);
      notifyListeners();
    }
  }

  void removeUser(String user) {
    _users.remove(user);
    notifyListeners();
  }

  void clearUsers() {
    _users.clear();
    notifyListeners();
  }
}
