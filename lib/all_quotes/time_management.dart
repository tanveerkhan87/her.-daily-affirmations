import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import local project files for providers, navigation, and UI elements
import '../magics/magics_home.dart';
import '../provider/for_fav/fav_items_provider.dart';
import '../provider/hide_quotes/hide_item_provider.dart';
import '../provider/themes/styles_provider.dart';
import '../screens/categories_screen/categories1_screen.dart';
import '../screens/profile/profile4_screen.dart';
import '../styles/styles_screen.dart';
import '../top_container/music.dart';
import '../ui/custom_buttons.dart';

// This is a StatefulWidget to manage its own state for auto-scrolling
// and the list of quotes after filtering out hidden ones.
class TimeManagement extends StatefulWidget {
  const TimeManagement({super.key});
  @override
  State<TimeManagement> createState() => _TimeManagementState();
}

class _TimeManagementState extends State<TimeManagement> {
  // --- STATE VARIABLES ---

  // The master list of quotes for this category.
  List<String> timemanagement = [
    "Time is what we want most, but what we use worst.",
    "Don't be fooled by the calendar. There are only as many days in the year as you make use of.",
    "The bad news is time flies. The good news is you're the pilot.",
    "Time is a created thing. To say 'I don't have time,' is like saying, 'I don't want to.'",
    "Time isn't the main thing. It's the only thing.",
    "You will never find time for anything. If you want time, you must make it.",
    "The key is not in spending time, but in investing it.",
    "Time is more valuable than money. You can get more money, but you cannot get more time.",
    "The only limit to our realization of tomorrow will be our doubts of today.",
    "Time management is an oxymoron. Time is beyond our control, and the clock keeps ticking regardless of how we lead our lives. Priority management is the answer to maximizing the time we have.",
    "Your time is limited, don't waste it living someone else's life.",
    "Ordinary people think merely of spending time. Great people think of using it.",
    "Time is what we want most, but what we use worst.",
    "Time is a great teacher, but unfortunately, it kills all its pupils.",
    "The way we spend our time defines who we are.",
    "The shorter way to do many things is to do only one thing at a time.",
  ];

  // Controllers and state flags for advanced features.
  final ConfettiController _confettiController = ConfettiController();
  final CarouselSliderController _carouselSliderController = CarouselSliderController();
  bool _autoScrollEnabled = false;
  Timer? _autoScrollTimer;
  bool _isLoading = true; // To show a loading indicator while filtering quotes.

  // Called once when the widget is first created.
  @override
  void initState() {
    super.initState();
    // Load hidden quotes and filter them out from the main list.
    _loadAndFilterQuotes();
  }

  // Called when the widget is removed from the screen to prevent memory leaks.
  @override
  void dispose() {
    _confettiController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  // --- FEATURE LOGIC ---

  // Asynchronously loads hidden items and removes them from this category's list.
  Future<void> _loadAndFilterQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    final hiddenItems = prefs.getStringList('hiddenItems') ?? [];
    if (mounted) {
      setState(() {
        // Use removeWhere to filter the list in place.
        timemanagement.removeWhere((quote) => hiddenItems.contains(quote));
        _isLoading = false; // Mark loading as complete.
      });
    }
  }

  // Toggles the auto-scrolling feature on and off.
  void toggleAutoScroll() {
    setState(() {
      _autoScrollEnabled = !_autoScrollEnabled;
      if (_autoScrollEnabled) {
        _autoScrollTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
          if (mounted) _carouselSliderController.nextPage();
        });
        Fluttertoast.showToast(msg: "Auto-scrolling activated! ✨");
      } else {
        _autoScrollTimer?.cancel();
        Fluttertoast.showToast(msg: "Auto-scrolling paused");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive UI.
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Access providers to get and modify app-wide state.
    final favouriteProvider = Provider.of<FavItemProvider>(context);
    final hideProvider = Provider.of<HideProvider>(context, listen: false);

    return Scaffold(
      // The Consumer widget listens to style changes and rebuilds the UI accordingly.
      body: Consumer<StyleProvider>(
        builder: (context, styleProvider, child) {
          // If quotes are still being filtered, show a loading circle.
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // If all quotes in this category have been hidden, show a message.
          if (timemanagement.isEmpty) {
            return const Center(child: Text("All quotes in this category are hidden.", style: TextStyle(fontSize: 16, color: Colors.grey)));
          }

          return Column(
            children: [
              // --- TOP HEADER ---
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.05),
                child: Center(
                  child: Text(
                    "Her.", // Title as requested
                    style: GoogleFonts.montserratAlternates(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                ),
              ),

              // --- MAIN QUOTE CAROUSEL ---
              Expanded(
                child: CarouselSlider.builder(
                  itemCount: timemanagement.length,
                  carouselController: _carouselSliderController,
                  itemBuilder: (context, index, realIndex) {
                    final item = timemanagement[index];
                    return Container(
                      width: screenWidth * 0.9,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      // --- DYNAMIC STYLING APPLIED HERE ---
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
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: styleProvider.topcontainercolor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              height: 50,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(onPressed: () => showModalBottomSheet(context: context, builder: (context) => MusicPlayerBottomSheet()), icon: const Icon(Icons.music_note, color: Colors.black, size: 21)),
                                  IconButton(
                                    onPressed: () {
                                      // Use the provider to hide the item permanently.
                                      hideProvider.hideItemAndSave(item, () {
                                        // Also remove it from the local list to update the UI instantly.
                                        setState(() {
                                          timemanagement.remove(item);
                                        });
                                      });
                                      Fluttertoast.showToast(msg: "Quote hidden");
                                    },
                                    icon: const Icon(Icons.visibility_off_outlined, color: Colors.black, size: 21),
                                  ),
                                  // --- FAVORITE BUTTON WITH ANIMATION ---
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ConfettiWidget(
                                        confettiController: _confettiController,
                                        blastDirectionality: BlastDirectionality.explosive,
                                        emissionFrequency: 0.01,
                                        numberOfParticles: 5,
                                        gravity: 0.1,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (favouriteProvider.selecteditem.contains(item)) {
                                            favouriteProvider.removeItem(item);
                                          } else {
                                            favouriteProvider.addItem(item);
                                            _confettiController.play();
                                          }
                                        },
                                        child: AnimatedSwitcher(
                                          duration: const Duration(milliseconds: 300),
                                          child: favouriteProvider.selecteditem.contains(item)
                                              ? BounceInDown(key: UniqueKey(), child: const Icon(Icons.favorite, color: Colors.red, size: 30))
                                              : BounceInDown(key: UniqueKey(), child: const Icon(Icons.favorite_border, color: Colors.white, size: 30)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(onPressed: toggleAutoScroll, icon: Icon(_autoScrollEnabled ? Icons.pause_circle : Icons.play_circle_outline, color: Colors.black, size: 21)),
                                  IconButton(onPressed: () => Share.share("Food for thought: \"$item\""), icon: const Icon(Icons.share, color: Colors.black, size: 21)),
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
                                // --- DYNAMIC FONT STYLING APPLIED HERE ---
                                style: TextStyle(fontSize: 28, fontFamily: styleProvider.customFont, color: styleProvider.fontColor, fontWeight: FontWeight.bold),
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
                                "- Time Management",
                                style: TextStyle(color: styleProvider.fontColor.withOpacity(0.8), fontFamily: styleProvider.customFont, fontSize: 17),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: screenHeight, // Takes up the available height from Expanded
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    enableInfiniteScroll: timemanagement.length > 1,
                  ),
                ),
              ),
              const SizedBox(height: 11),
              // --- BOTTOM NAVIGATION BAR ---
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomIconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoriesScreen())), icon: const Icon(Icons.dashboard, size: 45)),
                    CustomIconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MagicsHome())), icon: const Icon(Icons.auto_awesome, size: 45)),
                    CustomIconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StylesScreen())), icon: const Icon(Icons.format_color_text, size: 45)),
                    CustomIconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen())), icon: const Icon(Icons.person, size: 45)),
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