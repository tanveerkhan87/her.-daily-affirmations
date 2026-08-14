import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages app-wide light/dark/system theme mode.
class ThemeModeProvider with ChangeNotifier {
  static const String _storageKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.light;

  ThemeModeProvider() {
    _load();
  }

  ThemeMode get themeMode => _themeMode;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_storageKey) ?? ThemeMode.light.index;
    _themeMode = ThemeMode.values[index];
    notifyListeners();
  }

  Future<void> setTheme(ThemeMode? mode) async {
    if (mode == null || mode == _themeMode) return;
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_storageKey, _themeMode.index);
    notifyListeners();
  }
}
