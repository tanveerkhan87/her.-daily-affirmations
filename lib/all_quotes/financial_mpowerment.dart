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
class FinancialEmpowerment extends StatefulWidget {
  const FinancialEmpowerment({super.key});
  @override
  State<FinancialEmpowerment> createState() => _FinancialEmpowermentState();
}

class _FinancialEmpowermentState extends State<FinancialEmpowerment> {
  // --- STATE VARIABLES ---

  // The master list of quotes for this category.
  List<String> financialandempowerment = [
    "The goal isn't more money. The goal is living life on your terms.",
    "Financial freedom is available to those who learn about it and work for it.",
    "The best investment you can make is in yourself.",
    "Opportunities come infrequently. When it rains gold, put out the bucket, not the thimble.",
    "Money is only a tool. It will take you wherever you wish, but it will not replace you as the driver.",
    "The stock market is a device for transferring money from the impatient to the patient.",
    "Do not save what is left after spending, but spend what is left after saving.",
    "The habit of saving is itself an education; it fosters every virtue, teaches self-denial, cultivates the sense of order, trains to forethought, and so broadens the mind.",
    "Wealth consists not in having great possessions, but in having few wants.",
    "The more you learn, the more you earn.",
    "The greatest investment you can make is in yourself.",
    "If you buy things you do not need, soon you will have to sell things you need.",
    "Risk comes from not knowing what you're doing.",
    "Formal education will make you a living; self-education will make you a fortune.",
    "The stock market is designed to transfer money from the active to the patient.",
    "The more you know about your money, the more your money will know you.",
    "A wise person should have money in their head, but not in their heart.",
    "Do not be embarrassed by your failures, learn from them and start again.",
    "The best investment you can make is in your own abilities.",
    "The rich invest in time, the poor invest in money.",
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
        financialandempowerment.removeWhere((quote) => hiddenItems.contains(quote));
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
          if (financialandempowerment.isEmpty) {
            return const Center(child: Text("All quotes in this category are hidden.", style: TextStyle(fontSize: 16, color: Colors.grey)));
          }

          return Column(
            children: [
              // --- TOP HEADER ---
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.05),
                child: Center(
                  child: Text(
                    "Her.", // Title as in your original code
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
                  itemCount: financialandempowerment.length,
                  carouselController: _carouselSliderController,
                  itemBuilder: (context, index, realIndex) {
                    final item = financialandempowerment[index];
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
                                          financialandempowerment.remove(item);
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
                                  IconButton(onPressed: () => Share.share("Financial wisdom: \"$item\""), icon: const Icon(Icons.share, color: Colors.black, size: 21)),
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
                                "- Financial Empowerment",
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
                    enableInfiniteScroll: financialandempowerment.length > 1,
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