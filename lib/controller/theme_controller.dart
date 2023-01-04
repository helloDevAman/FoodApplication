import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;
  ThemeController({@required this.sharedPreferences}) {
    _loadCurrentTheme();
  }

  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;

  void toggleTheme() {
    _darkTheme = !_darkTheme;
    sharedPreferences.setBool(AppConstants.THEME, _darkTheme);
    update();
  }

  void _loadCurrentTheme() async {
    _darkTheme = sharedPreferences.getBool(AppConstants.THEME) ?? false;
    update();
  }
}
