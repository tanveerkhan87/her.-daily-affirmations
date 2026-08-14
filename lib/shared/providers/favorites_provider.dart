import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages favorite quotes with local persistence.
class FavoritesProvider with ChangeNotifier {
  static const String _storageKey = 'selectedItems';

  List<String> _items = [];
  late SharedPreferences _prefs;

  FavoritesProvider() {
    _init();
  }

  List<String> get items => _items;

  bool isFavorite(String quote) => _items.contains(quote);

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _items = _prefs.getStringList(_storageKey) ?? [];
    notifyListeners();
  }

  Future<void> toggle(String value) async {
    if (_items.contains(value)) {
      _items.remove(value);
    } else {
      _items.add(value);
    }
    await _prefs.setStringList(_storageKey, _items);
    notifyListeners();
  }

  Future<void> addItem(String value) async {
    if (!_items.contains(value)) {
      _items.add(value);
      await _prefs.setStringList(_storageKey, _items);
      notifyListeners();
    }
  }

  Future<void> removeItem(String value) async {
    _items.remove(value);
    await _prefs.setStringList(_storageKey, _items);
    notifyListeners();
  }
}
