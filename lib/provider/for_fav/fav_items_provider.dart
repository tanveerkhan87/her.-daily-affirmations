import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// FavItemProvider is used to manage favorite quotes/items in the app.
/// It uses SharedPreferences to store them locally, and ChangeNotifier to update the UI.
class FavItemProvider with ChangeNotifier {
  // Internal list of favorite items
  List<String> _selecteditem = [];

  // SharedPreferences instance to save/load data locally
  late SharedPreferences _prefs;

  // Constructor - initializes the provider and loads saved data
  FavItemProvider() {
    _initPrefs(); // Load saved favorites from local storage
  }

  // Initialize SharedPreferences and load saved favorite items
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance(); // Get prefs instance
    _selecteditem = _prefs.getStringList('selectedItems') ?? []; // Load or empty list
    notifyListeners(); // Notify widgets that data has loaded
  }

  // Getter to access the favorite items from other widgets
  List<String> get selecteditem => _selecteditem;

  // Add a new item to the favorite list and save it
  Future<void> addItem(String value) async {
    _selecteditem.add(value); // Add to the list
    await _prefs.setStringList('selectedItems', _selecteditem); // Save updated list
    notifyListeners(); // Notify UI about the change
  }

  // Remove an item from the favorite list and update storage
  Future<void> removeItem(String value) async {
    _selecteditem.remove(value); // Remove from the list
    await _prefs.setStringList('selectedItems', _selecteditem); // Save updated list
    notifyListeners(); // Notify UI about the change
  }
}
