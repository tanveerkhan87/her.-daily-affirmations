import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/routes/page_transitions.dart';
import '../../shared/widgets/her_app_bar.dart';
import 'create_affirmation_screen.dart';
import 'minds_eye_screen.dart';
import 'hear_your_voice_screen.dart';
import 'game_screen.dart';

/// Hub screen for "Magics" features.
class MagicsHomeScreen extends StatelessWidget {
  const MagicsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HerAppBar(title: 'Magics'),
      body: ListView(
        padding: AppSpacing.paddingAllMd,
        children: [
          _FeatureCard(
            index: 0,
            icon: Icons.edit_note_rounded,
            title: 'Create Affirmation',
            subtitle: 'Design your own personal affirmations',
            gradient: AppColors.primaryGradient,
            onTap: () => Navigator.push(context, SlidePageRoute(page: const CreateAffirmationScreen())),
          ),
          _FeatureCard(
            index: 1,
            icon: Icons.remove_red_eye_rounded,
            title: "Mind's Eye",
            subtitle: 'Visualize quotes with your front camera',
            gradient: AppColors.cardGradientA,
            onTap: () => Navigator.push(context, SlidePageRoute(page: const MindsEyeScreen())),
          ),
          _FeatureCard(
            index: 2,
            icon: Icons.mic_rounded,
            title: 'Hear Your Voice',
            subtitle: 'Record and listen to your affirmations',
            gradient: AppColors.cardGradientB,
            onTap: () => Navigator.push(context, SlidePageRoute(page: const HearYourVoiceScreen())),
          ),
          _FeatureCard(
            index: 3,
            icon: Icons.games_rounded,
            title: 'Tic Tac Toe',
            subtitle: 'Take a break with a quick game',
            gradient: const LinearGradient(colors: [Color(0xFFE8729A), Color(0xFFF4A7C1)]),
            onTap: () => Navigator.push(context, SlidePageRoute(page: const GameScreen())),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final int index;
  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.index,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: FadeInUp(
        duration: const Duration(milliseconds: 400),
        delay: Duration(milliseconds: 80 * index),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 110,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: gradient.colors.first.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.montserratAlternates(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.lato(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.white70, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
