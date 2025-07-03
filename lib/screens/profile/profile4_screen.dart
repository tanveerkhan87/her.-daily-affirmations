import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:her_daily_affirmations/screens/profile/about.dart';
import 'package:her_daily_affirmations/screens/profile/reminder_screen.dart';

import '../../magics/own_affirmation.dart';
import '../../provider/for_fav/all_fav_list.dart';
import '../../provider/hide_quotes/all_hide_quotes.dart';
import '../../provider/for_dark_light_mood/dark_theme_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, Key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<AffirmationData> _affirmations = [];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color appBarBackgroundColor = theme.brightness == Brightness.dark
        ? Colors.white10
        : Colors.white;
    final Color textColor = theme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Scaffold(

      appBar: AppBar(
        title: Text(
          "Personal",
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: FadeInDown(
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pink, Colors.orange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(33),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: ZoomIn(
                        duration: Duration(seconds: 2),
                        child: Text(
                          "Welcome to Her Daily Affirmations",
                          style: GoogleFonts.montserratAlternates(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              _buildMenuItem(
                context,
                icon: Icons.type_specimen,
                title: "Own affirmations",
                iconColor: Colors.lightGreen,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OwnAffirmations(affirmations: []),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              _buildMenuItem(
                context,
                icon: Icons.hide_image_outlined,
                title: "Hide affirmations",
                iconColor: Colors.purple,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AllHiddenList(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              _buildMenuItem(
                context,
                icon: Icons.favorite,
                title: "My favorites",
                iconColor:  Color.fromARGB(255, 139, 0, 0),
                  onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AllFavList(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              _buildMenuItem(
                context,
                icon: Icons.dark_mode,
                title: "Themes mode",
                iconColor: Colors.blue,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const DarkThemeScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              _buildMenuItem(
                context,
                icon: Icons.notifications_active_rounded,
                title: "Reminders",
                iconColor: Colors.orange,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ReminderScreen(key: UniqueKey()),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              _buildMenuItem(
                context,
                icon: Icons.info,
                title: "About us",
                iconColor: Colors.brown,
                onTap: () {

                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AboutScreen(),));

                  // Navigate to About Us screen
                },
              ),
              const SizedBox(height: 100),
              Text(
                "Her.",
                style: GoogleFonts.montserratAlternates(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Color iconColor,
        required VoidCallback onTap,
      }) {
    return FadeInUp(
     // duration: Duration(seconds: 2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white10
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        icon,
                        size: 40,
                        color: iconColor,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.blueGrey.shade900,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios, color: Colors.red),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
