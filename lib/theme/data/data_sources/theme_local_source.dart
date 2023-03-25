import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedtimer_flutter/core/utils/consts.dart';
import 'package:speedtimer_flutter/theme/data/models/theme_model.dart';

abstract class ThemeLocalSource {
  Future<ThemeModel> getTheme();
  Future<void> saveTheme(ThemeModel themeModel);
}

class ThemeLocalSourceImpl extends ThemeLocalSource {

  final String themeKey = "theme_key";

  final SharedPreferences sharedPreferences;

  ThemeLocalSourceImpl({required this.sharedPreferences});

  @override
  Future<ThemeModel> getTheme() async {
    final json = sharedPreferences.getString(themeKey);
    if (json == null) {
      return Future.value(defaultTheme);
    }
    return Future.value(ThemeModel.fromJson(jsonDecode(json)));
  }

  @override
  Future<void> saveTheme(ThemeModel themeModel) async {
    await sharedPreferences.setString(themeKey, jsonEncode(themeModel.toJson()));
  }
}