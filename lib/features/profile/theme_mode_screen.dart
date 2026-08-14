import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/providers/theme_mode_provider.dart';
import '../../shared/widgets/her_app_bar.dart';

/// Screen to select Light / Dark / System theme mode.
class ThemeModeScreen extends StatelessWidget {
  const ThemeModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThemeModeProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const HerAppBar(title: 'Theme Mode'),
      body: FadeInUp(
        duration: const Duration(milliseconds: 600),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          children: [
            Center(
              child: Text(
                "Choose Your Theme",
                style: GoogleFonts.outfit(
                  fontSize: 24, 
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                "Personalize how the app looks for you.",
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  color: isDark ? Colors.white54 : Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 36),
            _ThemeTile(
              title: 'Light Mode',
              icon: Icons.wb_sunny_rounded,
              value: ThemeMode.light,
              groupValue: provider.themeMode,
              onChanged: provider.setTheme,
              isDark: isDark,
              gradient: LinearGradient(
                colors: [Colors.orange.shade300, Colors.deepOrange.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            const SizedBox(height: 16),
            _ThemeTile(
              title: 'Dark Mode',
              icon: Icons.nightlight_round,
              value: ThemeMode.dark,
              groupValue: provider.themeMode,
              onChanged: provider.setTheme,
              isDark: isDark,
              gradient: LinearGradient(
                colors: [Colors.indigo.shade400, Colors.deepPurple.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            const SizedBox(height: 16),
            _ThemeTile(
              title: 'System Mode',
              icon: Icons.settings_brightness_rounded,
              value: ThemeMode.system,
              groupValue: provider.themeMode,
              onChanged: provider.setTheme,
              isDark: isDark,
              gradient: LinearGradient(
                colors: [Colors.teal.shade300, Colors.green.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final ThemeMode value;
  final ThemeMode groupValue;
  final ValueChanged<ThemeMode?> onChanged;
  final bool isDark;
  final Gradient gradient;

  const _ThemeTile({
    required this.title,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.isDark,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = groupValue == value;
    final accentColor = AppColors.primary;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E24) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? accentColor.withOpacity(isDark ? 0.2 : 0.15) 
                  : Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: isSelected ? 20 : 10,
              offset: Offset(0, isSelected ? 8 : 4),
            ),
          ],
          border: Border.all(
            color: isSelected 
                ? accentColor.withOpacity(0.6) 
                : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04)),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // ─── Animated Icon Container ─────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isSelected ? gradient : null,
                color: isSelected ? null : (isDark ? Colors.white10 : Colors.grey.shade100),
              ),
              child: Icon(
                icon, 
                color: isSelected ? Colors.white : (isDark ? Colors.white54 : Colors.black54), 
                size: 24
              ),
            ),
            const SizedBox(width: 20),
            
            // ─── Title ─────────
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected 
                      ? (isDark ? Colors.white : Colors.black87)
                      : (isDark ? Colors.white70 : Colors.black54),
                ),
              ),
            ),

            // ─── Custom Selection Indicator ─────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              height: 28,
              width: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? accentColor : Colors.transparent,
                border: Border.all(
                  color: isSelected ? accentColor : (isDark ? Colors.white24 : Colors.grey.shade300),
                  width: 2,
                ),
                boxShadow: [
                   BoxShadow(
                     color: isSelected ? accentColor.withOpacity(0.4) : Colors.transparent,
                     blurRadius: 8,
                     offset: const Offset(0, 2),
                   ),
                ],
              ),
              child: isSelected 
                  ? const Icon(Icons.check_rounded, size: 18, color: Colors.white) 
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
