import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../features/shell/shell_controller.dart';
import '../providers/style_provider.dart';

/// Reusable bottom navigation bar used inside quote carousel screens.
/// Switches tabs on [MainShell] via [ShellController] — the nav bar
/// stays visible because the shell is never pushed off the stack.
///
/// Tab indices match [MainShell._tabs]:
///   0 = Home, 1 = Categories, 2 = Magics, 3 = Profile
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  /// Derive a very dark, desaturated shade from the card color for the nav bar.
  static Color _navBgFromCard(Color card, bool isDark) {
    if (!isDark) return Colors.white;
    final hsl = HSLColor.fromColor(card);
    return hsl
        .withLightness((hsl.lightness * 0.22).clamp(0.06, 0.14))
        .withSaturation((hsl.saturation * 0.6).clamp(0.0, 0.4))
        .toColor();
  }

  void _switchTo(int index) {
    ShellController.instance.value = index;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final style = context.watch<StyleProvider>();
    final navBg = isDark ? _navBgFromCard(style.cardColor, true) : Colors.white;
    final iconColor = isDark ? Colors.white70 : AppColors.textPrimaryLight;

    return Container(
      decoration: BoxDecoration(
        color: navBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavItem(
                icon: Icons.dashboard_rounded,
                label: 'Categories',
                color: iconColor,
                onTap: () => _switchTo(1),
              ),
              _NavItem(
                icon: Icons.auto_awesome_rounded,
                label: 'Magics',
                color: iconColor,
                onTap: () => _switchTo(2),
              ),
              _NavItem(
                icon: Icons.palette_rounded,
                label: 'Themes',
                color: iconColor,
                // Themes screen is pushed on top — it's a sub-screen, not a tab.
                onTap: () {
                  // Navigate within the home tab's navigator stack.
                  // For now, switch to home first so the shell stays visible.
                  _switchTo(0);
                },
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                color: iconColor,
                onTap: () => _switchTo(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 26, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
