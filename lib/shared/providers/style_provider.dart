import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages custom quote card styling (colors, fonts, backgrounds).
class StyleProvider extends ChangeNotifier {
  late SharedPreferences _prefs;

  Color _actionBarColor = Colors.blueGrey.shade400;
  String _fontFamily = 'Quicksand';
  Color _cardColor = const Color.fromARGB(205, 101, 90, 229);
  Color _fontColor = Colors.white;
  String _backgroundImage = '';
  List<int>? _gradientColors;
  int _gradientDirection = 0; // 0=topLeft→bottomRight, 1=topCenter→bottomCenter

  StyleProvider() {
    _init();
  }

  // ─── Getters ─────────────────────────────────────────────
  Color get actionBarColor => _actionBarColor;
  Color get cardColor => _cardColor;
  Color get fontColor => _fontColor;
  String get fontFamily => _fontFamily;
  String get backgroundImage => _backgroundImage;

  /// A very dark, theme-tinted background derived from the card color.
  Color get scaffoldBg {
    final hsl = HSLColor.fromColor(_cardColor);
    return hsl
        .withLightness((hsl.lightness * 0.18).clamp(0.04, 0.12))
        .withSaturation((hsl.saturation * 0.55).clamp(0.0, 0.35))
        .toColor();
  }

  LinearGradient? get cardGradient {
    if (_gradientColors == null || _gradientColors!.length < 2) return null;
    final colors = _gradientColors!.map((c) => Color(c)).toList();
    final begin = _gradientDirection == 1 ? Alignment.topCenter : Alignment.topLeft;
    final end = _gradientDirection == 1 ? Alignment.bottomCenter : Alignment.bottomRight;
    return LinearGradient(colors: colors, begin: begin, end: end);
  }

  // ─── Setters ─────────────────────────────────────────────
  void updateActionBarColor(Color color) {
    _actionBarColor = color;
    _save();
    notifyListeners();
  }

  void updateCardColor(Color color) {
    _cardColor = color;
    _save();
    notifyListeners();
  }

  void updateFontColor(Color color) {
    _fontColor = color;
    _save();
    notifyListeners();
  }

  void updateFontFamily(String font) {
    _fontFamily = font;
    _save();
    notifyListeners();
  }

  void updateBackgroundImage({String? url}) {
    _backgroundImage = url ?? '';
    _save();
    notifyListeners();
  }

  /// Apply a full theme style at once (used by the themes screen).
  void applyTheme({
    required String fontFamily,
    required Color cardColor,
    required Color fontColor,
    required Color actionBarColor,
    String? backgroundImage,
    LinearGradient? gradient,
  }) {
    _fontFamily = fontFamily;
    _cardColor = cardColor;
    _fontColor = fontColor;
    _actionBarColor = actionBarColor;
    _backgroundImage = backgroundImage ?? '';
    if (gradient != null) {
      _gradientColors = gradient.colors.map((c) => c.value).toList();
      _gradientDirection =
          (gradient.begin == Alignment.topCenter) ? 1 : 0;
    } else {
      _gradientColors = null;
      _gradientDirection = 0;
    }
    _save();
    notifyListeners();
  }

  // ─── Persistence ─────────────────────────────────────────
  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _actionBarColor = Color(_prefs.getInt('topContainerColor') ?? Colors.white38.value);
    final savedFont = _prefs.getString('customFont') ?? 'Quicksand';
    _fontFamily = _isValidGoogleFont(savedFont) ? savedFont : 'Quicksand';
    _cardColor = Color(_prefs.getInt('containerColor') ?? const Color.fromARGB(205, 101, 90, 229).value);
    _fontColor = Color(_prefs.getInt('fontColor') ?? Colors.white.value);
    _backgroundImage = _prefs.getString('backgroundImage') ?? '';
    final gradStr = _prefs.getString('gradientColors');
    if (gradStr != null && gradStr.isNotEmpty) {
      _gradientColors = gradStr.split(',').map((s) => int.parse(s)).toList();
      _gradientDirection = _prefs.getInt('gradientDirection') ?? 0;
    }
    notifyListeners();
  }

  static bool _isValidGoogleFont(String name) {
    try {
      GoogleFonts.getFont(name);
      return true;
    } catch (_) {
      return false;
    }
  }

  void _save() {
    _prefs.setInt('topContainerColor', _actionBarColor.value);
    _prefs.setString('customFont', _fontFamily);
    _prefs.setInt('containerColor', _cardColor.value);
    _prefs.setInt('fontColor', _fontColor.value);
    _prefs.setString('backgroundImage', _backgroundImage);
    if (_gradientColors != null && _gradientColors!.isNotEmpty) {
      _prefs.setString('gradientColors', _gradientColors!.join(','));
      _prefs.setInt('gradientDirection', _gradientDirection);
    } else {
      _prefs.remove('gradientColors');
      _prefs.remove('gradientDirection');
    }
  }
}
