import 'package:flutter/material.dart';

// This widget represents each individual category box/item shown in the grid on the Categories screen.
class CategoriesScreenItems extends StatelessWidget {
  // Path of the background image for the category
  final String backgroundImage;

  // Title text that appears under the image
  final String title;

  // Function to run when the category is tapped
  final void Function()? myfunction;

  // Optional top padding value for the title
  final double? paddingTop;

  // Constructor to initialize the values
  const CategoriesScreenItems({
    super.key,
    required this.backgroundImage,
    required this.title,
    this.myfunction,
    this.paddingTop,
  });

  @override
  Widget build(BuildContext context) {
    // Get the current app theme to change colors based on dark/light mode
    final ThemeData theme = Theme.of(context);

    // Set the container background color depending on the theme
    final Color containerColor = theme.brightness == Brightness.dark
        ? Colors.white10 // If dark mode → light background
        : Colors.grey.shade200; // If light mode → slightly gray background

    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(14.0), // Outer space around the card
        child: Container(
          decoration: BoxDecoration(
            color: containerColor, // Use theme-aware background color
            borderRadius: BorderRadius.circular(17.0), // Rounded corners
          ),
          child: InkWell(
            // Tappable area
            onTap: myfunction, // Call the passed function on tap
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Center the text
              children: [
                SizedBox(height: 15), // Space above the image

                // Rounded image container
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                  child: Container(
                    height: 80, // Height of the image
                    width: 111, // Width of the image
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(backgroundImage), // Load asset image
                        fit: BoxFit.cover, // Fill the container with the image
                      ),
                    ),
                  ),
                ),

                // Optional padding above the title (if passed from outside)
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: paddingTop ?? 0.0),
                    ),
                  ],
                ),

                SizedBox(height: 10), // Space below the image

                // Title container
                Expanded(
                  child: Container(
                    child: Text(
                      title, // Display the passed title
                      textAlign: TextAlign.center, // Center the title text
                      style: TextStyle(
                        fontSize: 15, // Font size
                        color: theme.brightness == Brightness.dark
                            ? Colors.white // White text in dark mode
                            : Colors.grey.shade800, // Darker text in light mode
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
