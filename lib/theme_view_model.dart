import 'package:flutter/material.dart';
import 'package:speedtimer_fltr/themes/themes.dart';
import 'package:speedtimer_fltr/data/storage/shared_prefs_storage.dart';

class ThemeViewModel extends ChangeNotifier {
  final _sharedPreferences = SharedPreferencesStorage.instance;

  late AppTheme _appTheme;
  AppTheme get appTheme => _appTheme;

  ThemeViewModel() {
    _appTheme = AppTheme.defaultTheme;
    getPreferences();
  }

  set appTheme(AppTheme theme) {
    _appTheme = theme;
    _sharedPreferences.setTheme(theme);
    notifyListeners();
  }

  void getPreferences() async {
    _appTheme = await _sharedPreferences.getTheme();
    notifyListeners();
  }

}