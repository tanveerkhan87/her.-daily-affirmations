import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'own_affirmation.dart';

// Main screen where users can create their own affirmations
class create_affirmation extends StatefulWidget {
  const create_affirmation({super.key});

  @override
  State<create_affirmation> createState() => _create_affirmationState();
}

class _create_affirmationState extends State<create_affirmation> {
  // Color and font settings for user-designed affirmation
  late Color _backgroundColor = Colors.white;
  late Color _textColor = Colors.black;
  late String _selectedFontFamily;

  // Controller for affirmation text input
  final TextEditingController _affirmationController = TextEditingController();

  // Current selected font index for persistence
  int _currentSliderIndex = 0;

  // Available custom font families
  final List<String> _fontFamilies = [
    'font1', 'font2', 'font3', 'font4', 'font5', 'font6', 'font7',
    'font9', 'font10', 'font12', 'font13', 'font14', 'font15', 'font16',
    'font17', 'font18', 'font19', 'font20', 'font21', 'font22', 'font23', 'font24',
  ];

  // List of saved affirmations
  List<AffirmationData> _affirmationsList = [];

  @override
  void initState() {
    super.initState();
    _selectedFontFamily = _fontFamilies.isNotEmpty ? _fontFamilies[0] : 'font1';
    _textColor = Colors.grey;
    _loadAffirmationsLocally(); // Load previously saved affirmations
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Overall background
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Create Affirmation',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _saveAffirmation(context); // Save affirmation on check button click
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main affirmation writing container
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 355,
                decoration: BoxDecoration(
                  color: _backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: TextFormField(
                    controller: _affirmationController,
                    maxLines: null,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: _selectedFontFamily,
                      color: _textColor,
                      fontSize: 30,
                    ),
                    maxLength: 150,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write Affirmation',
                      hintStyle: TextStyle(color: _textColor),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ),
            ),

            // Font family selector
            SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _fontFamilies.map(
                      (fontFamily) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFontFamily = fontFamily;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Sample Text',
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 20,
                          color: _textColor,
                        ),
                      ),
                    ),
                  ),
                ).toList(),
              ),
            ),

            // Text color selection
            SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (Color color in Colors.primaries)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _textColor = color;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Background color selection
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (Color color in Colors.primaries)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _backgroundColor = color;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // View Saved Affirmations Button
            SizedBox(height: 13),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 33.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(color: Colors.grey, width: 2.0),
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      if (_affirmationsList.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OwnAffirmations(affirmations: _affirmationsList),
                          ),
                        );
                      } else {
                        _showEmptyDialog();
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          'View Affirmations',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Save the user's written affirmation with font, text color, and background color
  void _saveAffirmation(BuildContext context) async {
    String affirmationText = _affirmationController.text;

    if (affirmationText.trim().isEmpty) {
      _showEmptyDialog(); // Show dialog if no text entered
    } else {
      // Create new affirmation data
      AffirmationData newAffirmation = AffirmationData(
        affirmation: affirmationText,
        fontFamily: _selectedFontFamily,
        textColor: _textColor,
        backgroundColor: _backgroundColor,
      );

      // Add to list
      _affirmationsList.add(newAffirmation);

      // Clear the text input
      _affirmationController.clear();

      // Show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Affirmation Saved')),
      );

      // Save to shared preferences
      await _saveAffirmationsLocally();
    }
  }

  // Save affirmations list to local storage
  Future<void> _saveAffirmationsLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> affirmationsJsonList =
    _affirmationsList.map((affirmation) => json.encode(affirmation.toJson())).toList();

    await prefs.setStringList('affirmations', affirmationsJsonList);
    await prefs.setInt('sliderIndex', _currentSliderIndex);
  }

  // Load saved affirmations from local storage
  Future<void> _loadAffirmationsLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? affirmationsJsonList = prefs.getStringList('affirmations');

    if (affirmationsJsonList != null) {
      _affirmationsList = affirmationsJsonList.map((jsonString) {
        Map<String, dynamic> jsonMap = json.decode(jsonString);
        return AffirmationData.fromJson(jsonMap);
      }).toList();

      setState(() {}); // Refresh UI
    }

    _currentSliderIndex = prefs.getInt('sliderIndex') ?? 0;
  }

  // Show alert dialog for empty affirmation
  void _showEmptyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Empty Affirmation'),
          content: Text('Please write an affirmation before saving.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
