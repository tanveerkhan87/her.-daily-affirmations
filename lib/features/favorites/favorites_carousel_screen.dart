import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_fonts.dart';
import '../../shared/providers/favorites_provider.dart';
import '../../shared/providers/style_provider.dart';
import '../../shared/providers/category_provider.dart';

import '../../shared/widgets/quote_action_bar.dart';

/// Carousel view of the user's favorited quotes.
class FavoritesCarouselScreen extends StatefulWidget {
  const FavoritesCarouselScreen({super.key});

  @override
  State<FavoritesCarouselScreen> createState() => _FavoritesCarouselScreenState();
}

class _FavoritesCarouselScreenState extends State<FavoritesCarouselScreen> {
  final ConfettiController _confettiController = ConfettiController();
  final CarouselSliderController _carouselController = CarouselSliderController();
  bool _autoScrollEnabled = false;
  Timer? _autoScrollTimer;

  @override
  void dispose() {
    _confettiController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  void _toggleAutoScroll() {
    setState(() {
      _autoScrollEnabled = !_autoScrollEnabled;
      if (_autoScrollEnabled) {
        _autoScrollTimer = Timer.periodic(const Duration(seconds: 8), (_) {
          if (mounted) {
            _carouselController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        });
        Fluttertoast.showToast(msg: "Auto-scrolling activated");
      } else {
        _autoScrollTimer?.cancel();
        Fluttertoast.showToast(msg: "Auto-scrolling paused");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Consumer2<FavoritesProvider, StyleProvider>(
      builder: (context, favorites, style, _) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return Scaffold(
      backgroundColor: isDark ? style.scaffoldBg : AppColors.surfaceLight,
      body: Builder(
        builder: (context) {
          if (favorites.items.isEmpty) {
            return Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border_rounded, size: 80, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text('No Favorites Yet', style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text(
                        'Tap the heart on a quote to save it here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.06,
                  left: 16,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : Colors.black87),
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        context.read<CategoryProvider>().setCategory('all_kinds');
                      }
                    },
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.06),
                child: Text(
                  "Her.",
                  style: GoogleFonts.montserratAlternates(
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Expanded(
                child: CarouselSlider.builder(
                  carouselController: _carouselController,
                  itemCount: favorites.items.length,
                  itemBuilder: (context, index, _) {
                    final quote = favorites.items[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      decoration: BoxDecoration(
                        color: (style.cardGradient == null && style.backgroundImage.isEmpty)
                            ? style.cardColor
                            : null,
                        gradient: style.backgroundImage.isEmpty ? style.cardGradient : null,
                        borderRadius: BorderRadius.circular(16),
                        image: style.backgroundImage.isNotEmpty
                            ? DecorationImage(image: AssetImage(style.backgroundImage), fit: BoxFit.cover)
                            : null,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: QuoteActionBar(
                                currentQuote: quote,
                                confettiController: _confettiController,
                                autoScrollEnabled: _autoScrollEnabled,
                                onToggleAutoScroll: _toggleAutoScroll,
                              ),
                            ),
                          ),
                          Builder(builder: (context) {
                            final isLight =
                                ThemeData.estimateBrightnessForColor(
                                        style.fontColor) ==
                                    Brightness.light;
                            final sc = isLight ? Colors.black : Colors.white;
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 80),
                                child: Text(
                                  quote,
                                  style: AppFonts.safeGetFont(
                                    style.fontFamily,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600,
                                    color: style.fontColor,
                                    height: 1.4,
                                    shadows: isLight
                                        ? [
                                            Shadow(offset: const Offset(1, 1), blurRadius: 3, color: Colors.black.withOpacity(0.8)),
                                            Shadow(offset: const Offset(0, 4), blurRadius: 12, color: Colors.black.withOpacity(0.6)),
                                            Shadow(blurRadius: 24, color: Colors.black.withOpacity(0.4)),
                                          ]
                                        : [
                                            Shadow(blurRadius: 4, color: Colors.white.withOpacity(0.6)),
                                          ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.35),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "- Favorites",
                                  style: AppFonts.safeGetFont(
                                    style.fontFamily,
                                    color: Colors.white.withOpacity(0.95),
                                    fontSize: 14,
                                    shadows: const [
                                      Shadow(
                                          blurRadius: 4,
                                          color: Colors.black87),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: screenHeight * 0.78,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    enableInfiniteScroll: favorites.items.length > 1,
                    scrollPhysics: const BouncingScrollPhysics(),
                  ),
                ),
              ),

            ],
          );
        },
      ),
    );
    },
    );
  }
}
