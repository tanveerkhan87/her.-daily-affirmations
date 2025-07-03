import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

// Import local project files for navigation, providers, and UI elements.
import '../magics/magics_home.dart';
import '../provider/for_fav/fav_items_provider.dart';
import '../provider/hide_quotes/hide_item_provider.dart'; // <-- FIX: Import HideProvider
import '../provider/themes/styles_provider.dart';
import '../screens/categories_screen/categories1_screen.dart';
import '../screens/profile/profile4_screen.dart';
import '../styles/styles_screen.dart';
import 'package:her_daily_affirmations/ui/custom_buttons.dart';
import '../top_container/music.dart';

// This is a StatefulWidget because it manages its own internal state
// for features like auto-scrolling.
class FavoriteQuotes extends StatefulWidget {
  // NOTE: The `required List<String> favoriteQuotes` parameter is unnecessary
  // because we get the list directly from the provider. It's safe to remove.
  const FavoriteQuotes({super.key, required List<String> favoriteQuotes});

  @override
  State<FavoriteQuotes> createState() => _FavoriteQuotesState();
}

class _FavoriteQuotesState extends State<FavoriteQuotes> {
  // --- STATE VARIABLES ---
  // Controller to programmatically control the CarouselSlider.
  final CarouselSliderController _carouselSliderController = CarouselSliderController();
  // Flag to track if auto-scrolling is enabled.
  bool _autoScrollEnabled = false;
  // Timer for the auto-scroll functionality.
  Timer? _autoScrollTimer;

  @override
  void dispose() {
    _autoScrollTimer?.cancel(); // Clean up the timer to prevent memory leaks.
    super.dispose();
  }

  // --- AUTO-SCROLL LOGIC ---
  // This logic is identical to your HomeScreen for consistency.

  void startAutoScroll() {
    // Creates a timer that fires every 8 seconds.
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      // Check if the widget is still on screen before trying to control the carousel.
      if (mounted) {
        _carouselSliderController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void stopAutoScroll() {
    _autoScrollTimer?.cancel();
  }

  void toggleAutoScroll() {
    setState(() {
      _autoScrollEnabled = !_autoScrollEnabled; // Flip the boolean flag.
      if (_autoScrollEnabled) {
        startAutoScroll();
        Fluttertoast.showToast(msg: "Auto-scrolling activated! ✨");
      } else {
        stopAutoScroll();
        Fluttertoast.showToast(msg: "Auto-scrolling paused");
      }
    });
  }

  // NOTE: The hiding logic from your original attempt has been removed from this file.
  // The HideProvider handles all the logic of hiding items and saving them.
  // We just need to call the provider's method. This simplifies the screen's code.

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive UI.
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // FIX: Get an instance of the HideProvider. 'listen: false' is used
    // because we only need to call its methods, not rebuild when its data changes.
    final hideProvider = Provider.of<HideProvider>(context, listen: false);

    return Scaffold(
      body: Consumer<FavItemProvider>(
        builder: (context, favouriteProvider, child) {
          // If there are no favorite quotes, show a message.
          if (favouriteProvider.selecteditem.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('No Favorites Yet', style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Tap the heart on a quote to save it here.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            );
          }

          // If there are favorites, build the main UI.
          return Column(
            children: [
              // --- TOP HEADER ---
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.05),
                child: Center(
                  child: Text(
                    "Her.",
                    style: GoogleFonts.montserratAlternates(fontSize: screenWidth * 0.07, fontWeight: FontWeight.bold, color: Colors.pink),
                  ),
                ),
              ),
              // --- MAIN QUOTE CAROUSEL ---
              Expanded( // Use Expanded to ensure the carousel takes available space and avoids overflow.
                child: CarouselSlider(
                  carouselController: _carouselSliderController,
                  items: favouriteProvider.selecteditem.map((item) {
                    return Consumer<StyleProvider>(
                      builder: (context, styleProvider, child) {
                        return Container(
                          width: screenWidth * 0.9,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: styleProvider.containerColor,
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                            image: styleProvider.backgroundImage.isNotEmpty
                                ? DecorationImage(image: AssetImage(styleProvider.backgroundImage), fit: BoxFit.cover)
                                : null,
                          ),
                          child: Stack(
                            children: [
                              // --- TOP ACTION BAR ---
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: styleProvider.topcontainercolor,
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () => showModalBottomSheet(context: context, builder: (context) => MusicPlayerBottomSheet()),
                                        icon: const Icon(Icons.music_note, color: Colors.black, size: 21),
                                      ),
                                      IconButton(
                                        // FIX: Call the hideProvider to hide the item.
                                        // It will also be removed from favorites automatically.
                                        onPressed: () {
                                          hideProvider.hideItemAndSave(item, () {
                                            // The item will be removed from favorites and hidden permanently.
                                          });
                                          Fluttertoast.showToast(msg: "Quote hidden");
                                        },
                                        icon: const Icon(Icons.visibility_off_outlined, color: Colors.black, size: 21),
                                      ),
                                      IconButton(
                                        // On this screen, tapping the heart REMOVES the item from favorites.
                                        onPressed: () => favouriteProvider.removeItem(item),
                                        icon: const Icon(Icons.favorite, color: Colors.red, size: 30),
                                      ),
                                      IconButton(
                                        onPressed: toggleAutoScroll,
                                        icon: Icon(_autoScrollEnabled ? Icons.pause_circle : Icons.play_circle_outline, color: Colors.black, size: 21),
                                      ),
                                      IconButton(
                                        onPressed: () => Share.share("Check out this affirmation: \"$item\""),
                                        icon: const Icon(Icons.share, color: Colors.black, size: 21),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // --- QUOTE TEXT ---
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80),
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: styleProvider.customFont,
                                      color: styleProvider.fontColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              // --- TAG TEXT ---
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Text(
                                    "- Favorites",
                                    style: TextStyle(
                                      color: styleProvider.fontColor.withOpacity(0.8),
                                      fontFamily: styleProvider.customFont,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: screenHeight * 0.78,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    enableInfiniteScroll: favouriteProvider.selecteditem.length > 1,
                  ),
                ),
              ),
              const SizedBox(height:9),
              // --- BOTTOM NAVIGATION BAR ---
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Button to go to the Categories screen.
                    CustomIconButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const CategoriesScreen(),));}, icon: const Icon(Icons.dashboard, size: 45),),
                    CustomIconButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => MagicsHome(),));}, icon: const Icon(Icons.auto_awesome, size: 45),),
                    CustomIconButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const StylesScreen(),));}, icon: const Icon(Icons.format_color_text, size: 45),),
                    CustomIconButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ProfileScreen(),));}, icon: const Icon(Icons.person, size: 45),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}