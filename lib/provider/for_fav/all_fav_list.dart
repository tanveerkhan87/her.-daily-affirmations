import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../all_quotes/only_fav.dart';
import 'fav_items_provider.dart';

class AllFavList extends StatelessWidget {
  const AllFavList({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // Change app bar and text color based on light/dark mode
    final Color appBarBackgroundColor = theme.brightness == Brightness.dark
        ? Colors.white10
        : Colors.white;
    final Color textColor = theme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorite Quotes",
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

      // Listen to changes in FavItemProvider using Consumer
      body: Consumer<FavItemProvider>(
        builder: (context, favItemProvider, child) {
          return ListView.builder(
            itemCount: favItemProvider.selecteditem.length,
            itemBuilder: (context, index) {
              final selecteditem = favItemProvider.selecteditem[index];

              // Alternate background gradients for each quote card
              final gradientColors = index % 2 == 0
                  ? [Colors.teal, Colors.greenAccent]
                  : [Colors.indigo, Colors.blueAccent];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),

                // Card becomes tappable
                child: GestureDetector(
                  onTap: () {
                    // Navigate to detailed FavoriteQuotes screen
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) {
                        return FavoriteQuotes(
                          favoriteQuotes: favItemProvider.selecteditem,
                        );
                      },
                    ));
                  },

                  // Animate each card using ZoomIn effect
                  child: ZoomIn(
                    duration: Duration(seconds: 2),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradientColors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display the quote text
                              Text(
                                selecteditem,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Heart icon button to remove from favorites
                              Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                  onPressed: () {
                                    // Remove quote from favorite list
                                    favItemProvider.removeItem(selecteditem);

                                    // Show a toast message
                                    Fluttertoast.showToast(
                                      msg: "Quote removed",
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: theme.brightness == Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                      textColor: theme.brightness == Brightness.light
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16.0,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.redAccent,
                                    size: 30,
                                  ),
                                  tooltip: 'Remove from Favorites',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
