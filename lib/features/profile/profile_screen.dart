import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/routes/page_transitions.dart';
import '../../shared/widgets/her_app_bar.dart';
import '../favorites/favorites_list_screen.dart';
import 'hidden_quotes_screen.dart';
import 'reminder_screen.dart';
import 'theme_mode_screen.dart';
import '../magics/create_affirmation_screen.dart';

/// Profile / settings hub.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _launchURL(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showAboutBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'About',
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _BottomSheetItem(
                  icon: Icons.info_outline_rounded,
                  title: 'About Us',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    _launchURL('https://example.com/about'); // TODO: Replace with your URL
                  },
                ),
                _BottomSheetItem(
                  icon: Icons.gavel_rounded,
                  title: 'Terms & EULA',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.pop(context);
                    _launchURL('https://example.com/terms'); // TODO: Replace with your URL
                  },
                ),
                _BottomSheetItem(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  color: Colors.teal,
                  onTap: () {
                    Navigator.pop(context);
                    _launchURL('https://example.com/privacy'); // TODO: Replace with your URL
                  },
                ),
                Divider(color: isDark ? Colors.white10 : Colors.black12, height: 24),
                _BottomSheetItem(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implement Logout Logic
                  },
                ),
                _BottomSheetItem(
                  icon: Icons.person_remove_rounded,
                  title: 'Delete Account',
                  color: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implement Delete Account Logic
                  },
                ),
              ],
            ),
          ),
        ),);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HerAppBar(title: 'Personal'),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.paddingAllMd,
          children: [
            // ─── Hero Banner ──────────────────────
            FadeInDown(
              duration: const Duration(milliseconds: 500),
              child: Container(
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: AppColors.heroGradient,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
                child: Center(
                  child: Text(
                    "Welcome to\nHer Daily Affirmations",
                    style: GoogleFonts.montserratAlternates(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ─── Menu Items ───────────────────────
            _MenuItem(
              icon: Icons.edit_note_rounded,
              title: 'Own Affirmations',
              color: AppColors.success,
              onTap: () => Navigator.push(context,
                SlidePageRoute(page: const CreateAffirmationScreen()),
              ),
            ),
            _MenuItem(
              icon: Icons.visibility_off_rounded,
              title: 'Hidden Quotes',
              color: AppColors.accent,
              onTap: () => Navigator.push(context,
                SlidePageRoute(page: const HiddenQuotesScreen()),
              ),
            ),
            _MenuItem(
              icon: Icons.favorite_rounded,
              title: 'My Favorites',
              color: AppColors.error,
              onTap: () => Navigator.push(context,
                SlidePageRoute(page: const FavoritesListScreen()),
              ),
            ),
            _MenuItem(
              icon: Icons.dark_mode_rounded,
              title: 'Theme Mode',
              color: Colors.blueAccent,
              onTap: () => Navigator.push(context,
                SlidePageRoute(page: const ThemeModeScreen()),
              ),
            ),
            _MenuItem(
              icon: Icons.notifications_active_rounded,
              title: 'Reminders',
              color: AppColors.warning,
              onTap: () => Navigator.push(context,
                SlidePageRoute(page: const ReminderScreen()),
              ),
            ),
            _MenuItem(
              icon: Icons.info_outline_rounded,
              title: 'About',
              color: Colors.brown,
              onTap: () => _showAboutBottomSheet(context),
            ),

            const SizedBox(height: 48),
            Center(
              child: Text(
                "Her.",
                style: GoogleFonts.montserratAlternates(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FadeInUp(
        duration: const Duration(milliseconds: 350),
        child: Material(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          elevation: 0,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: isDark ? Colors.white10 : AppColors.divider,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 22),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomSheetItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _BottomSheetItem({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400, size: 20),
    );
  }
}
