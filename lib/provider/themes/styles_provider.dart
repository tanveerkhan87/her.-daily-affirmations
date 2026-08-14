import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// StyleProvider is used to manage and store custom UI styles across the app.
/// It stores colors, fonts, and background images using SharedPreferences,
/// and notifies widgets when values change.
class StyleProvider extends ChangeNotifier {
  late SharedPreferences _prefs;

  // Default style values
  Color _topcontainercolor = Colors.blueGrey.shade400;
  String _customFont = 'font2';
  Color _containerColor = Color.fromARGB(205, 101, 90, 229);
  Color _fontColor = Colors.white;
  String _backgroundImage = '';

  // Constructor: initialize saved preferences when the provider is created
  StyleProvider() {
    _initPreferences();
  }

  /// -------- Getters --------
  Color get topcontainercolor => _topcontainercolor;
  Color get containerColor => _containerColor;
  Color get cardColor => _containerColor;
  Color get fontColor => _fontColor;
  String get customFont => _customFont;
  String get backgroundImage => _backgroundImage;

  /// A very dark, theme-tinted background derived from the card color.
  Color get scaffoldBg {
    final hsl = HSLColor.fromColor(_containerColor);
    return hsl
        .withLightness((hsl.lightness * 0.18).clamp(0.04, 0.12))
        .withSaturation((hsl.saturation * 0.55).clamp(0.0, 0.35))
        .toColor();
  }

  /// -------- Update Methods --------

  // Update the background image and save
  void updateBackgroundImage({String? imgUrl}) {
    _backgroundImage = imgUrl ?? '';
    _savePreferences();
    notifyListeners(); // Notify UI to rebuild with new background
  }

  // Update top container color and save
  void updatetopcontainercolor(Color color) {
    _topcontainercolor = color;
    _savePreferences();
    notifyListeners();
  }

  // Update main container color and save
  void updateContainerColor(Color color) {
    _containerColor = color;
    _savePreferences();
    notifyListeners();
  }

  // Update text font color and save
  void updateFontColor(Color color) {
    _fontColor = color;
    _savePreferences();
    notifyListeners();
  }

  // Update custom font name and save
  void updateCustomFont(String newFont) {
    _customFont = newFont;
    _savePreferences();
    notifyListeners();
  }

  /// -------- Preference Initialization --------

  // Initialize SharedPreferences and load saved values
  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadPreferences();
  }

  // Load saved styles from SharedPreferences
  void _loadPreferences() {
    _topcontainercolor = Color(_prefs.getInt('topContainerColor') ?? Colors.white38.value);
    _customFont = _prefs.getString('customFont') ?? 'font2';
    _containerColor = Color(
        _prefs.getInt('containerColor') ?? Color.fromARGB(205, 101, 90, 229).value);
    _fontColor = Color(_prefs.getInt('fontColor') ?? Colors.white.value);
    _backgroundImage = _prefs.getString('backgroundImage') ?? '';
    notifyListeners(); // Refresh UI after loading preferences
  }

  // Save all style values to SharedPreferences
  void _savePreferences() {
    _prefs.setInt('topContainerColor', _topcontainercolor.value);
    _prefs.setString('customFont', _customFont);
    _prefs.setInt('containerColor', _containerColor.value);
    _prefs.setInt('fontColor', _fontColor.value);
    _prefs.setString('backgroundImage', _backgroundImage);
  }
}
