import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:github_activity/user_object.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  List<User?> _fetched = [];
  List<User?> get fetched => _fetched;

  User? _current_user;
  User? get current_user => _current_user;
  void set current_user(User? user) => _current_user = user;

  void toggleTheme(prefs) {
    _isDarkMode = !_isDarkMode;
    prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  void appendUser(User? user) {
    for (var current_user in _fetched)
      if (current_user?.login == user?.login)
        _fetched.remove(current_user);
        _fetched.add(user);
    
    notifyListeners();
  }

  void loadStoredActivity(User? user) async {
    _current_user = user;
    notifyListeners();
  }

  void set isDarkMode(bool pref) {
    _isDarkMode = pref;
  }
}
