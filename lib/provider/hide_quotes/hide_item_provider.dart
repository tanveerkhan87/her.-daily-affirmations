import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// HideProvider is used to manage a list of hidden items (e.g. quotes).
/// It stores hidden items locally using SharedPreferences and notifies UI on changes.
class HideProvider with ChangeNotifier {
  // Internal list to store hidden items
  List<String> _hiddenItems = [];

  // SharedPreferences instance for local storage
  late SharedPreferences _prefs;

  // Constructor: initializes preferences and loads saved hidden items
  HideProvider() {
    _initPrefs();
  }

  // Load SharedPreferences and get previously hidden items
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _hiddenItems = _prefs.getStringList('hiddenItems') ?? []; // Load saved or use empty list
    notifyListeners(); // Notify UI that hidden items are loaded
  }

  // Getter to access the list of hidden items
  List<String> get hiddenItems => _hiddenItems;

  // Hide an item, save it locally, show a toast, and scroll to next
  Future<void> hideItemAndSave(String value, Function() scrollToNextItem) async {
    _hiddenItems.add(value); // Add item to hidden list
    await _prefs.setStringList('hiddenItems', _hiddenItems); // Save to SharedPreferences
    notifyListeners(); // Notify widgets to update UI

    // Show a toast notification confirming the hide action
    Fluttertoast.showToast(
      msg: "Item hidden",
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.pink,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    scrollToNextItem(); // Move UI to the next item (callback passed from UI)
  }

  // Remove an item from the hidden list and update storage
  Future<void> removeItem(String value) async {
    _hiddenItems.remove(value); // Remove item
    await _prefs.setStringList('hiddenItems', _hiddenItems); // Save updated list
    notifyListeners(); // Update UI
  }
}
