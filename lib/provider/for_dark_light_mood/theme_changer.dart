import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ThemeChanger class is used to manage light/dark theme across the app
/// It uses `ChangeNotifier` to notify UI about theme changes
class ThemeChanger with ChangeNotifier {
  // This variable holds the current theme mode (light or dark)
  var _themeMode = ThemeMode.light;

  // Getter to access the current theme mode from outside
  ThemeMode get themeMode => _themeMode;

  // Key used to save and load theme mode from SharedPreferences
  final String _themeKey = 'theme_mode';

  // Constructor: When ThemeChanger is created, it tries to load saved theme
  ThemeChanger() {
    _loadThemeMode();
  }

  // Load the saved theme mode from SharedPreferences (local storage)
  void _loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get saved integer value and convert it back to ThemeMode enum
    _themeMode = ThemeMode.values[
    prefs.getInt(_themeKey) ?? ThemeMode.light.index
    ];

    // Notify the UI to rebuild with the loaded theme
    notifyListeners();
  }

  // Save the current theme mode to SharedPreferences
  void _saveThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_themeKey, _themeMode.index);
  }

  // Method to change the theme mode (light or dark)
  void setTheme(themeMode) {
    _themeMode = themeMode;     // Set the new theme
    _saveThemeMode();           // Save it so it stays after app restart
    notifyListeners();          // Update the UI
  }
}
