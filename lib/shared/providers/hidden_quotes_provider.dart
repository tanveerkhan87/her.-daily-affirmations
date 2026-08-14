import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages hidden quotes with local persistence.
class HiddenQuotesProvider with ChangeNotifier {
  static const String _storageKey = 'hiddenItems';

  List<String> _items = [];
  late SharedPreferences _prefs;

  HiddenQuotesProvider() {
    _init();
  }

  List<String> get items => _items;

  bool isHidden(String quote) => _items.contains(quote);

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _items = _prefs.getStringList(_storageKey) ?? [];
    notifyListeners();
  }

  Future<void> hideQuote(String value, {VoidCallback? onHidden}) async {
    _items.add(value);
    await _prefs.setStringList(_storageKey, _items);
    notifyListeners();
    onHidden?.call();
  }

  Future<void> unhideQuote(String value) async {
    _items.remove(value);
    await _prefs.setStringList(_storageKey, _items);
    notifyListeners();
  }
}
