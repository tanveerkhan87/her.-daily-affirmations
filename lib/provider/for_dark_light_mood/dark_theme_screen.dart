import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:her_daily_affirmations/provider/for_dark_light_mood/theme_changer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DarkThemeScreen extends StatefulWidget {
  const DarkThemeScreen({super.key});

  @override
  State<DarkThemeScreen> createState() => _DarkThemeScreenState();
}

class _DarkThemeScreenState extends State<DarkThemeScreen> {
  @override
  Widget build(BuildContext context) {
    // Access the current theme settings using Provider
    final themeChanger = Provider.of<ThemeChanger>(context);

    // Get current theme context (light/dark) to dynamically adjust UI
    final ThemeData theme = Theme.of(context);

    // Set colors based on current brightness (light/dark mode)
    final Color appBarBackgroundColor = theme.brightness == Brightness.dark
        ? Colors.black54
        : Colors.white;
    final Color textColor = theme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final Color buttonColor = theme.brightness == Brightness.dark
        ? Colors.pinkAccent
        : Colors.blueAccent;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Themes",
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

      // Animated screen content using BounceInDown
      body: BounceInDown(
        from: 25,
        child: Container(
          // Gradient background changes based on theme
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: theme.brightness == Brightness.dark
                  ? [Colors.black, Colors.black54]
                  : [Colors.white, Colors.grey[200]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Center(
                child: Text(
                  "Choose Your Theme",
                  style: GoogleFonts.montserrat(
                    color: textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Theme options list (Light, Dark, System)
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  children: [
                    _buildRadioTile(
                      themeChanger,
                      "Light Mode",
                      ThemeMode.light,
                      buttonColor,
                      textColor,
                    ),
                    const SizedBox(height: 20),
                    _buildRadioTile(
                      themeChanger,
                      "Dark Mode",
                      ThemeMode.dark,
                      buttonColor,
                      textColor,
                    ),
                    const SizedBox(height: 20),
                    _buildRadioTile(
                      themeChanger,
                      "System Mode",
                      ThemeMode.system,
                      buttonColor,
                      textColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable Radio button card for selecting theme mode
  Widget _buildRadioTile(
      ThemeChanger themeChanger,
      String title,
      ThemeMode value,
      Color buttonColor,
      Color textColor,
      ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: RadioListTile<ThemeMode>(
        title: Text(
          title,
          style: GoogleFonts.montserrat(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        value: value,
        groupValue: themeChanger.themeMode, // Current selected mode
        onChanged: themeChanger.setTheme,   // Update mode when selected
        activeColor: buttonColor,           // Selected radio color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        tileColor: themeChanger.themeMode == value
            ? buttonColor.withOpacity(0.1) // Highlight if selected
            : Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      ),
    );
  }
}
