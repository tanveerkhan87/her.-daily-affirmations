import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:her_daily_affirmations/magics/game.dart';
import 'package:her_daily_affirmations/magics/hearyour_%20voice.dart';
import 'package:her_daily_affirmations/magics/minds_eye.dart';

import 'create_affirmation.dart';

class MagicsHome extends StatefulWidget {
  const MagicsHome({super.key});

  @override
  State<MagicsHome> createState() => _MagicsHomeState();
}

class _MagicsHomeState extends State<MagicsHome> {
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
          "Magics Home",
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

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildCategoryCard(
                'Create Your Own Affirmation',
                Icons.edit,
                theme,
                Colors.pink[200]!,
                    () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => create_affirmation()));
                },
              ),
              _buildCategoryCard(
                "Mind's eye",
                Icons.camera_alt_sharp,
                theme,
                Colors.purple[200]!,
                    () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MindsEye()));
                    },
              ),
              _buildCategoryCard(
                'Hear Your Voice ',
                Icons.scatter_plot_outlined,
                theme,
                Colors.blue[200]!,
                    () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HearYourVoiceScreen()));

                    },
              ),
              _buildCategoryCard(
                'Let`s Play Game',
                Icons.face_2_sharp,
                theme,
                Colors.green[200]!,
                    () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Game()));

                    },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, ThemeData theme, Color cardColor, VoidCallback onTap) {
    final Color iconColor = theme.brightness == Brightness.dark
        ? Colors.white
        : Colors.white;
    final Color textColor = theme.brightness == Brightness.dark
        ? Colors.white
        : Colors.white;

    return ZoomIn(
      duration: Duration(seconds: 2),
      child: Card(
        color: cardColor.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 8,
        margin: const EdgeInsets.symmetric(vertical: 25.0),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 48.0,
                  color: iconColor,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.montserratAlternates(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: iconColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
