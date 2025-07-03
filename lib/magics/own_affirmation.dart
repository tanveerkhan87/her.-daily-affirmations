import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OwnAffirmations extends StatefulWidget {
  final List<AffirmationData> affirmations;

  const OwnAffirmations({super.key, required this.affirmations});

  @override
  _OwnAffirmationsState createState() => _OwnAffirmationsState();
}

class _OwnAffirmationsState extends State<OwnAffirmations> {
  List<AffirmationData> _affirmations = [];

  @override
  void initState() {
    super.initState();
    _loadAffirmations();
  }

  Future<void> _loadAffirmations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? affirmationsJson = prefs.getStringList('affirmations');
    if (affirmationsJson != null) {
      setState(() {
        _affirmations = affirmationsJson.map((json) => AffirmationData.fromJson(jsonDecode(json))).toList();
      });
    } else {
      setState(() {
        _affirmations = widget.affirmations;
      });
    }
  }

  void _deleteAffirmation(int index) async {
    setState(() {
      _affirmations.removeAt(index);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('affirmations', _affirmations.map((aff) => jsonEncode(aff.toJson())).toList());
  }


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color appBarBackgroundColor = theme.brightness == Brightness.dark
        ? Colors.white10 // Set the background color for dark theme
        : Colors.white; // Set the background color for light theme
    final Color textColor = theme.brightness == Brightness.dark
        ? Colors.white // Set the text color for dark theme
        : Colors.black; // Set the text color for light theme
    final Color buttonColor = theme.brightness == Brightness.dark
        ? Colors.white // Set the button color for dark theme
        : Colors.black; // Set the button color for light theme


    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Own Affirmations",
          style: GoogleFonts.montserratAlternates(
            color: textColor,
            fontSize: 22,
          ),
        ),
        backgroundColor: appBarBackgroundColor,
        elevation: 4,

        iconTheme: IconThemeData(
          color: theme.brightness == Brightness.dark ? Colors.white : Colors.black,
        ),
      ),
      body: CarouselSlider.builder(
        itemCount: _affirmations.length,
        itemBuilder: (BuildContext context, int index, int realIndex) {
          final AffirmationData affirmation = _affirmations[index];
          return Padding(
            padding: const EdgeInsets.only(top: 31.0, bottom: 31),
            child: AffirmationCard(
              affirmation: affirmation,
              onDelete: () => _deleteAffirmation(index),
            ),
          );
        },
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
        ),
      ),
    );
  }
}

class AffirmationData {
  final String affirmation;
  final String fontFamily;
  final Color textColor;
  final Color backgroundColor;

  AffirmationData({
    required this.affirmation,
    required this.fontFamily,
    required this.textColor,
    required this.backgroundColor,
  });

  Map<String, dynamic> toJson() {
    return {
      'affirmation': affirmation,
      'fontFamily': fontFamily,
      'textColor': textColor.value,
      'backgroundColor': backgroundColor.value,
    };
  }

  factory AffirmationData.fromJson(Map<String, dynamic> json) {
    return AffirmationData(
      affirmation: json['affirmation'],
      fontFamily: json['fontFamily'],
      textColor: Color(json['textColor']),
      backgroundColor: Color(json['backgroundColor']),
    );
  }
}

class AffirmationCard extends StatelessWidget {
  final AffirmationData affirmation;
  final VoidCallback onDelete;

  const AffirmationCard({super.key, required this.affirmation, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12, right: 12),
      decoration: BoxDecoration(
        color: affirmation.backgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(12), bottomLeft: Radius.circular(12)),
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete_rounded, color: Colors.white, size: 32),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Text(
                affirmation.affirmation,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  color: affirmation.textColor,
                  fontFamily: affirmation.fontFamily,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}