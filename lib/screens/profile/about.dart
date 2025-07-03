import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // This is the updated, safer function to launch the email app
  void _launchEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'engr.tanveerkhan7@gmail.com',
      queryParameters: {'subject': 'Feedback for Her. App'},
    );

    try {
      // Try to launch the email app
      await launchUrl(emailLaunchUri);
    } catch (e) {
      // If it fails, show a user-friendly message on the screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open email app.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    final Color appBarBackgroundColor = isDarkMode ? Colors.white10 : Colors.white;
    final Color textColor = isDarkMode ? Colors.white70 : Colors.black87;
    final Color headerColor = isDarkMode ? Colors.pink.shade200 : Colors.pink;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About us",
          style: GoogleFonts.montserratAlternates(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 22,
          ),
        ),
        backgroundColor: appBarBackgroundColor,
        elevation: 4,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FadeInDown(
                duration: const Duration(milliseconds: 500),
                child: Icon(Icons.favorite_border, size: 80, color: headerColor),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  'Her.',
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: headerColor,
                  ),
                ),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 500),
                delay: const Duration(milliseconds: 200),
                child: Text(
                  'Your pocket of peace & inspiration.',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              _buildSection(
                context,
                icon: Icons.lightbulb_outline,
                title: 'Our Mission',
                content: 'Her. is designed to be a sanctuary in your pocket. A place where you can find a moment of calm, a spark of inspiration, and a beautiful space that you can make your own. We believe in the power of a positive mindset and a peaceful environment.',
              ),
              _buildSection(
                context,
                icon: Icons.star_border,
                title: 'Features',
                contentWidget: Column(
                  children: [
                    _buildFeatureItem(Icons.color_lens_outlined, 'Personalize your app with dozens of beautiful themes and fonts.'),
                    _buildFeatureItem(Icons.music_note_outlined, 'Listen to soothing background music to help you relax and focus.'),
                    _buildFeatureItem(Icons.format_quote_outlined, 'Enjoy delightful animations with inspiring quotes to brighten your day.'),
                  ],
                ),
              ),
              _buildSection(
                context,
                icon: Icons.email_outlined,
                title: 'Contact & Feedback',
                contentWidget: Column(
                  children: [
                    Text(
                      'Have a question or a suggestion? We’d love to hear from you!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(fontSize: 15, color: textColor),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: headerColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      icon: const Icon(Icons.send_rounded),
                      label: const Text('Send us an Email'),
                      // IMPORTANT: We pass the 'context' to our function now
                      onPressed: () => _launchEmail(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              FadeInUp(
                delay: const Duration(milliseconds: 1000),
                child: Text(
                  'Version 1.0.0',
                  style: GoogleFonts.lato(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required IconData icon, required String title, String? content, Widget? contentWidget}) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDarkMode ? Colors.white70 : Colors.black87;
    final Color headerColor = isDarkMode ? Colors.pink.shade200 : Colors.pink;

    return FadeInUp(
      delay: const Duration(milliseconds: 400),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: headerColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.montserratAlternates(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (content != null)
              Text(
                content,
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(fontSize: 15, color: textColor, height: 1.5),
              ),
            if (contentWidget != null) Center(child: contentWidget),
            const SizedBox(height: 16),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.lato(fontSize: 15, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }
}