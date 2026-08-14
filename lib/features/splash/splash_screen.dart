import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../shell/main_shell.dart';

/// Animated splash screen with scale + fade branding and auto-navigation.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final AnimationController _pulseController;
  late final Animation<double> _fadeIn;
  late final Animation<double> _scale;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeIn = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutBack),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    Future.delayed(const Duration(seconds: 3), _navigate);
  }

  void _navigate() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MainShell(),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
                : [const Color(0xFFFDF2F8), Colors.white],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeIn,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ─── Pulsing heart icon ───────────
                  ScaleTransition(
                    scale: _pulse,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, Color(0xFFE91E8C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.35),
                            blurRadius: 30,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 42,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ─── Brand name ───────────────────
                  Text(
                    "Her.",
                    style: GoogleFonts.montserratAlternates(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ─── Tagline ──────────────────────
                  Text(
                    "Daily Affirmations",
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      letterSpacing: 2.5,
                    ),
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
