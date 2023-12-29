import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:github_activity/user_object.dart';

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
      bool replaced = false;
      for (var current_user in _fetched) {
        if (current_user?.login == user?.login) {
          _fetched.add(user);
          _fetched.remove(current_user);
          replaced = true;
        }
      }

      if(!replaced)
        _fetched.add(user);

    saveFetched();
    notifyListeners();
  }

  void loadStoredActivity(User? user) async {
    _current_user = user;
    saveCurrent();
    notifyListeners();
  }

  void clearFetched() {
    _fetched.clear();
    current_user = null;
    saveFetched();
    notifyListeners();
  }

  void set isDarkMode(bool pref) {
    _isDarkMode = pref;
  }

  Future<void> saveFetched() async {
    var box = await Hive.openBox('fetched');
    await box.clear();
    await box.addAll(_fetched);
    notifyListeners();
  }

  Future<void> saveCurrent() async {
    var box = await Hive.openBox('current');
    await box.put('current', current_user?.login ?? 'null');
    notifyListeners();
  }

  Future<void> loadFetched() async {
    var box = await Hive.openBox('fetched');
    _fetched.clear();
    _fetched.addAll(box.values.cast<User?>().toList());
    notifyListeners();
  }

  Future<void> loadCurrent() async {
    var box = await Hive.openBox('current');
    var current = box.get('current');

    for(var user in _fetched)
      if(user?.login == current)
      _current_user = user;
    notifyListeners();
  }
}
