import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../categories/categories_screen.dart';
import '../home/home_screen.dart';
import '../magics/magics_home_screen.dart';
import '../profile/profile_screen.dart';
import '../styles/styles_screen.dart';
import 'shell_controller.dart';

/// Persistent shell with bottom navigation bar.
/// Uses [IndexedStack] so every tab keeps its own state alive.
/// Tab switches can be triggered from anywhere via [ShellController].
class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell>
    with SingleTickerProviderStateMixin {
  late int _currentIndex;
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnim;

  static const _tabs = [
    HomeScreen(),
    CategoriesScreen(),
    MagicsHomeScreen(),
    StylesScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    ShellController.instance.value = _currentIndex;

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      lowerBound: 0.88,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );

    // Listen for external tab-switch requests (e.g. from BottomNavBar).
    ShellController.instance.addListener(_onControllerChange);
  }

  void _onControllerChange() {
    final idx = ShellController.instance.value;
    if (idx != _currentIndex) {
      _switchTab(idx);
    }
  }

  @override
  void dispose() {
    ShellController.instance.removeListener(_onControllerChange);
    _scaleController.dispose();
    super.dispose();
  }

  void _switchTab(int index) {
    if (index == _currentIndex) return;
    _scaleController.forward(from: 0.88);
    setState(() {
      _currentIndex = index;
      ShellController.instance.removeListener(_onControllerChange);
      ShellController.instance.value = index;
      ShellController.instance.addListener(_onControllerChange);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // The body switches between tabs — each stays alive in the stack.
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),

      // ─── Persistent Bottom Navigation Bar ─────────────────────────────
      bottomNavigationBar: ScaleTransition(
        scale: _scaleAnim,
        child: _HerBottomBar(
          currentIndex: _currentIndex,
          isDark: isDark,
          onTap: _switchTab,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Custom bottom bar widget
// ──────────────────────────────────────────────────────────────────────────────

class _HerBottomBar extends StatelessWidget {
  const _HerBottomBar({
    required this.currentIndex,
    required this.isDark,
    required this.onTap,
  });

  final int currentIndex;
  final bool isDark;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.dashboard_rounded, label: 'Categories'),
    _NavItem(icon: Icons.auto_awesome_rounded, label: 'Magics'),
    _NavItem(icon: Icons.palette_rounded, label: 'Themes'),
    _NavItem(icon: Icons.person_rounded, label: 'Me'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E32) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.10),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 70,
          child: Row(
            children: List.generate(_items.length, (i) {
              final selected = i == currentIndex;
              final item = _items[i];
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Pill indicator + icon
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutBack,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary.withOpacity(0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            item.icon,
                            size: selected ? 26 : 22,
                            color: selected
                                ? AppColors.primary
                                : (isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight),
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Label
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: GoogleFonts.quicksand(
                            fontSize: 11,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: selected
                                ? AppColors.primary
                                : (isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight),
                          ),
                          child: Text(item.label),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}
