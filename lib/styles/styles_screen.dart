import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/themes/styles_provider.dart';

// --- Data Model for a Theme Style ---
// This class holds all the properties for a single theme option.
// This makes the code cleaner by separating data from the UI rendering logic.
class ThemeStyle {
  final String fontFamily;
  final Color containerColor;
  final Color fontColor;
  final Color topContainerColor;
  final String? backgroundImageUrl;

  const ThemeStyle({
    required this.fontFamily,
    required this.containerColor,
    required this.fontColor,
    required this.topContainerColor,
    this.backgroundImageUrl,
  });
}

// --- Data Source for all Theme Styles ---
// All theme options are now stored in this single list.
// To add, remove, or modify a theme, you only need to change it here.
final List<ThemeStyle> _themeStyles = [
  // Each item in this list corresponds to a theme tile in the grid.
  const ThemeStyle(fontFamily: 'font2', containerColor: Color.fromARGB(205, 101, 90, 229), fontColor: Colors.white, topContainerColor: Colors.white38),
  const ThemeStyle(fontFamily: 'font3', containerColor: Colors.orange, fontColor: Colors.black, topContainerColor: Colors.white38),
  const ThemeStyle(fontFamily: 'font1', containerColor: Colors.pink, fontColor: Colors.white, topContainerColor: Colors.white38),
  const ThemeStyle(fontFamily: 'font21', containerColor: Colors.teal, fontColor: Colors.yellow, topContainerColor: Colors.white24),
  const ThemeStyle(fontFamily: 'font10', containerColor: Colors.grey, fontColor: Colors.white70, topContainerColor: Colors.grey),
  const ThemeStyle(fontFamily: 'font2', containerColor: Colors.blue, fontColor: Colors.yellowAccent, topContainerColor: Colors.white38),
  const ThemeStyle(fontFamily: 'font4', containerColor: Colors.transparent, fontColor: Colors.white, topContainerColor: Colors.blueGrey, backgroundImageUrl: 'assets/images/dark.jpg'),
  const ThemeStyle(fontFamily: 'font5', containerColor: Colors.green, fontColor: Colors.white, topContainerColor: Colors.white38),
  const ThemeStyle(fontFamily: 'font6', containerColor: Colors.purple, fontColor: Colors.redAccent, topContainerColor: Colors.white38),
  const ThemeStyle(fontFamily: 'font7', containerColor: Colors.transparent, fontColor: Colors.white, topContainerColor: Colors.white38, backgroundImageUrl: 'assets/images/bg18.jpg'),
  const ThemeStyle(fontFamily: 'font9', containerColor: Colors.transparent, fontColor: Colors.white, topContainerColor: Colors.white54, backgroundImageUrl: 'assets/images/bg2.jpg'),
  const ThemeStyle(fontFamily: 'font11', containerColor: Colors.brown, fontColor: Colors.white, topContainerColor: Colors.white24),
  const ThemeStyle(fontFamily: 'font12', containerColor: Colors.transparent, fontColor: Colors.white, topContainerColor: Colors.grey, backgroundImageUrl: 'assets/images/bg4.jpg'),
  const ThemeStyle(fontFamily: 'font13', containerColor: Colors.black54, fontColor: Colors.white, topContainerColor: Colors.white12),
  const ThemeStyle(fontFamily: 'font14', containerColor: Colors.purpleAccent, fontColor: Colors.white, topContainerColor: Colors.white38),
  const ThemeStyle(fontFamily: 'font15', containerColor: Colors.transparent, fontColor: Colors.white, topContainerColor: Colors.white54, backgroundImageUrl: 'assets/images/bg11.jpg'),
  const ThemeStyle(fontFamily: 'font16', containerColor: Colors.indigo, fontColor: Colors.white, topContainerColor: Colors.white24),
  const ThemeStyle(fontFamily: 'font17', containerColor: Colors.transparent, fontColor: Colors.teal, topContainerColor: Colors.green, backgroundImageUrl: 'assets/images/bg5.jpg'),
  const ThemeStyle(fontFamily: 'font18', containerColor: Colors.lightGreen, fontColor: Colors.white, topContainerColor: Colors.white38),
  const ThemeStyle(fontFamily: 'font19', containerColor: Color.fromARGB(255, 0, 0, 139), fontColor: Colors.white, topContainerColor: Colors.white38),
  const ThemeStyle(fontFamily: 'font20', containerColor: Colors.transparent, fontColor: Colors.black54, topContainerColor: Colors.brown, backgroundImageUrl: 'assets/images/bg6.jpg'),
  const ThemeStyle(fontFamily: 'font21', containerColor: Color.fromARGB(255, 139, 69, 19), fontColor: Colors.white, topContainerColor: Colors.white24),
  const ThemeStyle(fontFamily: 'font22', containerColor: Colors.teal, fontColor: Colors.white, topContainerColor: Colors.white24), // Corrected 'fon22' to 'font22'
  const ThemeStyle(fontFamily: 'font23', containerColor: Colors.deepPurple, fontColor: Colors.black, topContainerColor: Colors.white24),
  const ThemeStyle(fontFamily: 'font24', containerColor: Colors.transparent, fontColor: Colors.white, topContainerColor: Colors.indigo, backgroundImageUrl: 'assets/images/bg7.jpg'),
  const ThemeStyle(fontFamily: 'font3', containerColor: Color.fromARGB(255, 255, 39, 59), fontColor: Colors.white, topContainerColor: Colors.white38), // Corrected invalid color value 569 to 255
  const ThemeStyle(fontFamily: 'font4', containerColor: Colors.redAccent, fontColor: Colors.white, topContainerColor: Colors.white38),
  const ThemeStyle(fontFamily: 'font20', containerColor: Colors.transparent, fontColor: Colors.white, topContainerColor: Colors.white38, backgroundImageUrl: 'assets/images/bg8.jpg'),
  const ThemeStyle(fontFamily: 'font15', containerColor: Color.fromARGB(255, 0, 23, 49), fontColor: Colors.redAccent, topContainerColor: Colors.white24),
  const ThemeStyle(fontFamily: 'font10', containerColor: Colors.transparent, fontColor: Colors.white, topContainerColor: Colors.white38, backgroundImageUrl: 'assets/images/bg17.jpg'),
  const ThemeStyle(fontFamily: 'font18', containerColor: Colors.yellowAccent, fontColor: Colors.black, topContainerColor: Colors.white38),
  const ThemeStyle(fontFamily: 'font15', containerColor: Colors.transparent, fontColor: Colors.white, topContainerColor: Colors.white38, backgroundImageUrl: 'assets/images/bg15.jpg'),
  const ThemeStyle(fontFamily: 'font1', containerColor: Colors.transparent, fontColor: Colors.white, topContainerColor: Colors.white38, backgroundImageUrl: 'assets/images/bg16.jpg'),
  const ThemeStyle(fontFamily: 'font3', containerColor: Color.fromARGB(255, 85, 107, 47), fontColor: Colors.black, topContainerColor: Colors.white24),
  const ThemeStyle(fontFamily: 'font9', containerColor: Colors.transparent, fontColor: Colors.white, topContainerColor: Colors.white38, backgroundImageUrl: 'assets/images/bg9.jpg'),
];


class StylesScreen extends StatefulWidget {
  const StylesScreen({super.key});

  @override
  _StylesScreenState createState() => _StylesScreenState();
}

class _StylesScreenState extends State<StylesScreen> {
  // State to keep track of the selected theme index. -1 means nothing is selected.
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    // Load the previously selected index from storage when the screen starts.
    _loadSelectedIndex();
  }

  /// Loads the saved theme index from SharedPreferences.
  Future<void> _loadSelectedIndex() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Update the state with the loaded index. Default to -1 if nothing was saved.
    setState(() {
      selectedIndex = prefs.getInt('selectedIndex') ?? -1;
    });
  }

  /// Saves the currently selected theme index to SharedPreferences.
  Future<void> _saveSelectedIndex(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedIndex', index);
  }

  /// Handles the tap event on a theme tile.
  void _onThemeTap(int index, ThemeStyle style) {
    // Access the StyleProvider to update the app's theme globally.
    final styleProvider = Provider.of<StyleProvider>(context, listen: false);
    styleProvider.updateCustomFont(style.fontFamily);
    styleProvider.updateContainerColor(style.containerColor);
    styleProvider.updateFontColor(style.fontColor);
    styleProvider.updatetopcontainercolor(style.topContainerColor);
    styleProvider.updateBackgroundImage(imgUrl: style.backgroundImageUrl ?? '');

    // Update the state to reflect the new selection.
    setState(() {
      selectedIndex = index;
    });

    // Save the new selection for persistence.
    _saveSelectedIndex(index);

    // Show a confirmation SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Center(child: Text('Theme Is Selected')),
        duration: const Duration(seconds: 1),
        backgroundColor: style.containerColor != Colors.transparent ? style.containerColor : Colors.green,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color appBarBackgroundColor = theme.brightness == Brightness.dark ? Colors.white10 : Colors.white;
    final Color textColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Themes",
          style: GoogleFonts.montserratAlternates(color: textColor, fontSize: 22),
        ),
        backgroundColor: appBarBackgroundColor,
        elevation: 4,
        iconTheme: IconThemeData(
          color: theme.brightness == Brightness.dark ? Colors.white : Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FadeInDown(
          // GridView.builder is more efficient for long lists than GridView.count.
          // It builds only the items that are visible on screen.
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,          // 2 columns
              crossAxisSpacing: 18,       // Horizontal spacing
              mainAxisSpacing: 18,        // Vertical spacing
              childAspectRatio: 1 / 1.5,  // Aspect ratio of each tile
            ),
            itemCount: _themeStyles.length + 1, // +1 to include the initial image tile
            itemBuilder: (context, index) {
              // The very first tile is a special case (the static image).
              if (index == 0) {
                return _buildStaticImageTile();
              }
              // For all other tiles, build a theme tile.
              // We subtract 1 from the index because our _themeStyles list is 0-indexed
              // and we've already used index 0 for the static image.
              final themeIndex = index - 1;
              final style = _themeStyles[themeIndex];
              return _buildThemeTile(context, themeIndex, style);
            },
          ),
        ),
      ),
    );
  }

  /// Builds the static, non-selectable image tile at the beginning of the grid.
  Widget _buildStaticImageTile() {
    return InkWell(
      onTap: () { /* No action needed for this tile */ },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.transparent,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset(
            'assets/images/aftergp.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }


  /// Builds a single, selectable theme tile for the grid.
  Widget _buildThemeTile(BuildContext context, int index, ThemeStyle style) {
    // Check if this tile is the currently selected one.
    final bool isSelected = (index == selectedIndex);

    return GestureDetector(
      onTap: () => _onThemeTap(index, style),
      child: Container(
        decoration: BoxDecoration(
          color: style.containerColor,
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          // Show a border if the tile is selected.
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 2,
          ),
          // Apply a background image if one is provided in the ThemeStyle.
          image: style.backgroundImageUrl != null
              ? DecorationImage(
            image: AssetImage(style.backgroundImageUrl!),
            fit: BoxFit.cover,
          )
              : null,
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            // The "ABC" text demonstrating the font.
            Center(
              child: Text(
                "ABC",
                style: TextStyle(
                  fontFamily: style.fontFamily,
                  color: style.fontColor,
                  fontSize: 46,
                ),
              ),
            ),
            // If selected, show an animated checkmark icon.
            if (isSelected)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BounceInDown(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 40,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}