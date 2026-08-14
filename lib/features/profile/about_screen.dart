import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/widgets/her_app_bar.dart';

/// About screen with app info, features, and contact.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _sendEmail() async {
    final uri = Uri.parse('mailto:tanveerkhan872006@gmail.com');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const HerAppBar(title: 'About'),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingAllMd,
        child: FadeInUp(
          duration: const Duration(milliseconds: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Header Card ──────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.heroGradient,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
                child: Column(
                  children: [
                    Text(
                      "Her.",
                      style: GoogleFonts.montserratAlternates(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Daily Affirmations",
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.white70,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ─── Mission ──────────────────────
              _SectionCard(
                isDark: isDark,
                title: 'Our Mission',
                content:
                    'Her Daily Affirmations is designed to uplift and empower women '
                    'through the power of positive affirmations. We believe in nurturing '
                    'self-love, confidence, and inner strength.',
              ),
              const SizedBox(height: 16),

              // ─── Features ─────────────────────
              _SectionCard(
                isDark: isDark,
                title: 'Features',
                content:
                    '• Daily curated affirmations across 14+ categories\n'
                    '• Create your own personalized affirmations\n'
                    '• Customizable themes and styles\n'
                    '• Ambient background music\n'
                    '• Save and share your favorites\n'
                    '• Smart daily reminders\n'
                    '• Mind\'s Eye visualization tool\n'
                    '• Voice recording for affirmations',
              ),
              const SizedBox(height: 16),

              // ─── Contact ──────────────────────
              _SectionCard(
                isDark: isDark,
                title: 'Contact Us',
                content: 'We\'d love to hear from you! Reach out with feedback, questions, or just to say hello.',
                trailing: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: OutlinedButton.icon(
                    onPressed: _sendEmail,
                    icon: const Icon(Icons.email_outlined, size: 18),
                    label: const Text('Send Email'),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // ─── Footer ───────────────────────
              Center(
                child: Text(
                  'Made with love for Her',
                  style: GoogleFonts.lato(fontSize: 13, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final bool isDark;
  final String title;
  final String content;
  final Widget? trailing;

  const _SectionCard({
    required this.isDark,
    required this.title,
    required this.content,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingAllMd,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: isDark ? Colors.white10 : AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserratAlternates(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(content, style: GoogleFonts.lato(fontSize: 14, height: 1.6)),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
