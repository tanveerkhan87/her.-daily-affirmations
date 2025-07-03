// Import necessary packages for animations, sliders, confetti, etc.
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

// Import local files from your project structure.
import 'package:her_daily_affirmations/styles/styles_screen.dart';
import '../../magics/magics_home.dart';
import '../../provider/for_fav/fav_items_provider.dart';
import '../../provider/hide_quotes/hide_item_provider.dart';
import '../../provider/themes/styles_provider.dart';
import '../../top_container/music.dart';
import '../../ui/custom_buttons.dart';
import '../categories_screen/categories1_screen.dart';
import '../profile/profile4_screen.dart';

// HomeScreen is a StatefulWidget because its content needs to change based on user actions.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- STATE VARIABLES ---
  // These variables hold the data and control the state of the screen.

  // Controller for the confetti animation when a user favorites a quote.
  final ConfettiController _confettiController = ConfettiController();

  // Controller to programmatically control the CarouselSlider (e.g., go to the next page).
  final CarouselSliderController _carouselSliderController = CarouselSliderController();

  // A boolean flag to track whether the auto-scrolling feature is active.
  bool _autoScrollEnabled = false;

  // A Timer object that will trigger the auto-scroll at regular intervals.
  Timer? _autoScrollTimer;

  // This method is called when the widget is removed from the screen.
  // It's crucial for cleaning up resources to prevent memory leaks.
  @override
  void dispose() {
    _confettiController.dispose(); // Dispose of the confetti controller.
    _autoScrollTimer?.cancel(); // Cancel the auto-scroll timer if it's running.
    super.dispose();
  }

  // --- AUTO-SCROLL LOGIC ---

  // This function starts the periodic timer for auto-scrolling.
  void startAutoScroll() {
    // Creates a timer that fires every 8 seconds.
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      // Uses the controller to move the carousel to the next quote.
      _carouselSliderController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  // This function stops the auto-scrolling by canceling the timer.
  void stopAutoScroll() {
    _autoScrollTimer?.cancel();
  }

  // This function is called when the user taps the play/pause button.
  // It toggles the auto-scroll feature on or off.
  void toggleAutoScroll() {
    setState(() {
      _autoScrollEnabled = !_autoScrollEnabled; // Flip the boolean flag.
      if (_autoScrollEnabled) {
        startAutoScroll(); // If enabled, start the timer.
        Fluttertoast.showToast(
          msg: "Auto-scrolling activated! Next quote in 8 sec ✨",
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        stopAutoScroll(); // If disabled, stop the timer.
        Fluttertoast.showToast(
          msg: "Auto-scrolling paused",
          gravity: ToastGravity.BOTTOM,
        );
      }
    });
  }

  // --- DATA MANAGEMENT FOR QUOTES ---

  // The main list of quotes displayed on the screen.
  List<String> homescreen = [
    "Time is the artist; our experiences, the canvas. Each day, a stroke of possibility",
    "Promises are like precious gemstones; they shine brightest when kept intact",
    "The world is a canvas, and she's painting her own story",
    "Don't die without embracing the daring adventure your life was meant to be",
    "The journey of a thousand miles begins with one step",
    "Life is 10% what happens to us and 90% how we react to it",
    "Life is a journey that must be traveled no matter how bad the roads and accommodations",
    "Believe you can and you're halfway there",
    "In the dictionary of love, there's no definition, because love is an ever-changing emotion",
    "God's grace and good health – the best gifts of all",
    "Don't watch the clock; do what it does. Keep going",
    "Success is not final, failure is not fatal: It is the courage to continue that counts",
    "Happiness is not something ready-made. It comes from your own actions",
    "The pain of parting is nothing to the joy of meeting again",
    "Look deep into nature, and then you will understand everything better",
    "Sometimes, solitude is the best company",
    "Embrace your quirks, for they are the strokes that paint your unique masterpiece",
    "Here's to the nights that turned into mornings with the friends that turned into family",
    "Chasing dreams and catching sunbeams",
    "Live in the sunshine, swim the sea, drink the wild air",
    "The only thing you can't recycle is wasted time",
    "You are never too old to set another goal or to dream a new dream",
    "Success usually comes to those who are too busy to be looking for it",
    "Love the life you live; live the life you love",
    "Success is not final, failure is not fatal: it is the courage to continue that counts",
    "The only thing necessary for the triumph of evil is for good men to do nothing",
    "If you are not willing to risk the usual, you will have to settle for the ordinary",
    "It does not matter how slowly you go as long as you do not stop",
    "The greatest wealth is to live content with little",
    "The future belongs to those who believe in the beauty of their dreams",
    "Life is what happens when you're busy making other plans. ",
    "The best way to predict the future is to invent it. ",
    "Success is not in what you have, but who you are. ",
    "Success usually comes to those who are too busy to be looking for it. ",
    "To live is the rarest thing in the world. Most people exist, that is all. ",
    "Do not wait to strike till the iron is hot, but make it hot by striking. ",
    "The only thing we have to fear is fear itself.",
    "Life is really simple, but we insist on making it complicated. ",
    "What lies behind us and what lies before us are tiny matters compared to what lies within us. ",
    "Life is either a daring adventure or nothing at all. ",
    "In three words I can sum up everything I've learned about life: it goes on. "
  ];

  // A list to store quotes that the user has chosen to hide.
  List<String> hiddenItems = [];

  // This method is called once when the screen is first created.
  // It's used for initial setup.
  @override
  void initState() {
    super.initState();
    loadHiddenItems(); // Load any previously hidden items from storage.
    removeHiddenItemsFromHomescreen(); // Ensure hidden items are not in the main list.
  }

  // Asynchronously loads the list of hidden quotes from the device's local storage.
  Future<void> loadHiddenItems() async {
    final prefs = await SharedPreferences.getInstance();
    final hiddenItemsList = prefs.getStringList('hiddenItems') ?? [];
    setState(() {
      hiddenItems = hiddenItemsList;
      // After loading, filter the main 'homescreen' list to remove hidden items.
      homescreen.removeWhere((item) => hiddenItems.contains(item));
    });
  }

  // Asynchronously saves the current list of hidden quotes to the device's storage.
  Future<void> saveHiddenItems(List<String> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('hiddenItems', items);
  }

  // A helper function to filter the main quotes list.
  void removeHiddenItemsFromHomescreen() {
    setState(() {
      homescreen.removeWhere((item) => hiddenItems.contains(item));
    });
  }

  // Hides a specific quote from the list and saves this change.
  // NOTE: This function is defined but the UI uses the HideProvider instead.
  void hideItem(String item, context) {
    ThemeData theme = Theme.of(context);
    setState(() {
      hiddenItems.add(item); // Adds the item to the hidden list.
      homescreen.remove(item); // Removes the item from the visible list.
    });
    saveHiddenItems(hiddenItems); // Saves the updated hidden list to storage.
    Fluttertoast.showToast(
      msg: "Item hidden",
      gravity: ToastGravity.BOTTOM,
      backgroundColor: theme.brightness == Brightness.light ? Colors.black : Colors.white,
      textColor: theme.brightness == Brightness.light ? Colors.white : Colors.black,
    );
  }

  // The build method describes the part of the user interface represented by this widget.
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive UI.
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Access the providers to get and modify app-wide state.
    final favouriteprovider = Provider.of<FavItemProvider>(context);
    final styleProvider = Provider.of<StyleProvider>(context);
    final hideProvider = Provider.of<HideProvider>(context, listen: false);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      // The Consumer widget listens to changes in the StyleProvider.
      // Whenever the style changes (e.g., theme, font), this part of the UI rebuilds.
      body: Consumer<StyleProvider>(
        builder: (context, styleProvider, child) {
          return Column(
            children: [
              // --- TOP HEADER "Her." ---
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.05),
                child: Center(
                  child: BounceInDown( // Animate the title dropping down.
                    duration: Duration(seconds: 2),
                    child: Text(
                      "Her.",
                      style: GoogleFonts.montserratAlternates(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                  ),
                ),
              ),
              // --- MAIN QUOTE CAROUSEL ---
              Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.005,
                    left: screenWidth * 0.001,
                    right: screenWidth * 0.001),
                child: Column(
                  children: [
                    CarouselSlider(
                      carouselController: _carouselSliderController,
                      // The 'items' are generated by mapping over the 'homescreen' list.
                      items: homescreen.asMap().entries.map((entry) {
                        String item = entry.value;

                        // This is the container for a single quote card.
                        return Container(
                          decoration: BoxDecoration(
                            color: styleProvider.containerColor,
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            image: styleProvider.backgroundImage.isNotEmpty
                                ? DecorationImage(
                              image: AssetImage(styleProvider.backgroundImage),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                          height: screenHeight * 0.8,
                          width: screenWidth * 0.9,
                          // Stack allows widgets to be layered on top of each other.
                          child: Stack(
                            children: [
                              // --- TOP ACTION BAR (MUSIC, HIDE, FAVORITE, ETC.) ---
                              Padding(
                                padding: const EdgeInsets.only(left: 38.0, right: 38),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(100),
                                      bottomRight: Radius.circular(100),
                                    ),
                                    color: styleProvider.topcontainercolor,
                                  ),
                                  height: screenHeight * 0.068,
                                  width: screenWidth * 0.76,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // Button to open the music player bottom sheet.
                                      IconButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return MusicPlayerBottomSheet();
                                            },
                                          );
                                        },
                                        icon: Icon(Icons.music_note, color: Colors.black, size: 21),
                                      ),

                                      // Button to hide the current quote using the HideProvider.
                                      IconButton(
                                        onPressed: () {
                                          hideProvider.hideItemAndSave(item, () {
                                            _carouselSliderController.nextPage(); // Move to next quote after hiding.
                                          });
                                        },
                                        icon: Icon(Icons.hide_image_outlined, color: Colors.black, size: 21),
                                      ),

                                      // --- FAVORITE BUTTON with ANIMATION ---
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            // Logic to add or remove item from favorites.
                                            if (favouriteprovider.selecteditem.contains(item)) {
                                              favouriteprovider.removeItem(item);
                                            } else {
                                              favouriteprovider.addItem(item);
                                              _confettiController.play(); // Play confetti animation.
                                              Timer(const Duration(seconds: 2), () {
                                                _confettiController.stop(); // Stop confetti.
                                              });
                                            }
                                          },
                                          child: Stack(
                                            alignment: Alignment.topCenter,
                                            children: [
                                              // AnimatedSwitcher smoothly transitions between the two heart icons.
                                              AnimatedSwitcher(
                                                duration: Duration(milliseconds: 300),
                                                child: favouriteprovider.selecteditem.contains(item)
                                                    ? BounceInDown( // Animation for the filled heart.
                                                  key: UniqueKey(),
                                                  child: Icon(Icons.favorite, color: Colors.red, size: screenHeight * 0.06),
                                                )
                                                    : BounceInDown( // Animation for the bordered heart.
                                                  key: UniqueKey(),
                                                  child: Icon(Icons.favorite_border, color: Colors.white, size: screenHeight * 0.06),
                                                ),
                                              ),
                                              // The confetti widget that plays when a quote is favorited.
                                              ConfettiWidget(
                                                confettiController: _confettiController,
                                                blastDirectionality: BlastDirectionality.explosive,
                                                emissionFrequency: 0.01,
                                                numberOfParticles: 5,
                                                gravity: 0.08,
                                                shouldLoop: false,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Button to toggle auto-scrolling on and off.
                                      IconButton(
                                        onPressed: toggleAutoScroll,
                                        icon: Icon(
                                          _autoScrollEnabled ? Icons.pause : Icons.play_circle_outlined,
                                          size: 21,
                                          color: Colors.black,
                                        ),
                                      ),

                                      // Button to share the app link using the 'share_plus' package.
                                      IconButton(
                                        onPressed: () {
                                          Share.share("Check out this amazing affirmations app: com.example.her_daily_affirmations");
                                        },
                                        icon: Icon(Icons.share, size: 21, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // --- DISPLAY THE QUOTE TEXT ---
                              Positioned(
                                top: screenHeight * 0.12,
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      item, // The actual quote string.
                                      style: TextStyle(
                                          fontSize: 28,
                                          fontFamily: styleProvider.customFont, // Font from StyleProvider.
                                          color: styleProvider.fontColor), // Font color from StyleProvider.
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),

                              // --- "AUTHOR" TEXT ---
                              Positioned(
                                bottom: screenHeight * 0.01,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Text(
                                    "- All Kinds",
                                    style: TextStyle(
                                      color: styleProvider.fontColor,
                                      fontFamily: styleProvider.customFont,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                      // --- CAROUSEL OPTIONS ---
                      options: CarouselOptions(
                        height: screenHeight * 0.79,
                        enlargeCenterPage: true, // Makes the center item larger.
                        viewportFraction: 0.9, // How much of the screen each item takes.
                        scrollPhysics: const BouncingScrollPhysics(), // The scroll animation style.
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 11),
              // --- BOTTOM NAVIGATION BAR ---
              // A row of custom buttons for navigating to different screens.
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