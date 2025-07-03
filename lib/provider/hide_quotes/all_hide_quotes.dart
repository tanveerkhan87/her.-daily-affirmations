import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import 'hide_item_provider.dart';

class AllHiddenList extends StatelessWidget {
  const AllHiddenList({super.key,});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color appBarBackgroundColor = theme.brightness == Brightness.dark
        ? Colors.white10
        : Colors.white;
    final Color textColor = theme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final Color buttonColor = theme.brightness == Brightness.dark
        ? Colors.pinkAccent // Set the button color for dark theme
        : Colors.blueAccent; // Set the button color for light theme

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hidden Quotes",
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.brightness == Brightness.dark ? Colors.black : Colors.white,
              theme.brightness == Brightness.dark ? Colors.grey[900]! : Colors.grey[100]!,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Consumer<HideProvider>(
          builder: (context, hideProvider, child) {
            return ListView.builder(
              itemCount: hideProvider.hiddenItems.length,
              itemBuilder: (context, index) {
                final hiddenItem = hideProvider.hiddenItems[index];
                final backgroundColor = index % 2 == 0
                    ? Colors.purple.shade50 // Even index
                    : Colors.pink.shade50; // Odd index

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ZoomIn(

duration: Duration(seconds: 2),
                    child: Material(
                      elevation: 8,
                      shadowColor: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: backgroundColor,
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          leading: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: buttonColor.withOpacity(0.2),
                            ),
                            child: Icon(
                              Icons.format_quote,
                              color: buttonColor,
                              size: 30,
                            ),
                          ),
                          title: Text(
                            hiddenItem,
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.brightness == Brightness.dark
                                  ? Colors.black
                                  : Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            "Long press to delete",
                            style: GoogleFonts.lato(
                              fontStyle: FontStyle.italic,
                              color: theme.brightness == Brightness.dark
                                  ? Colors.black
                                  : Colors.black54,
                            ),
                          ),
                          onTap: () {
                            // Add functionality for tapping the card if needed
                          },
                          onLongPress: () {
                            hideProvider.removeItem(hiddenItem);
                             Fluttertoast.showToast(
                              msg: "Quote removed",
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: theme.brightness== Brightness.light? Colors.black:Colors.white,
                              textColor: theme.brightness==Brightness.light? Colors.white: Colors.black,
                              fontSize: 16.0,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
