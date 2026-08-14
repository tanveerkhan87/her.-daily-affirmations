import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_fonts.dart';
import '../../shared/providers/hidden_quotes_provider.dart';
import '../../shared/providers/style_provider.dart';

import '../../shared/widgets/quote_action_bar.dart';

/// A generic, reusable quote carousel screen.
/// Pass in any list of quotes and a tag label to create a category view.
/// This single widget replaces 14+ nearly-identical category files.
class QuoteCarouselScreen extends StatefulWidget {
  final List<String> quotes;
  final String tagLabel;
  final bool showHeader;

  const QuoteCarouselScreen({
    super.key,
    required this.quotes,
    required this.tagLabel,
    this.showHeader = true,
  });

  @override
  State<QuoteCarouselScreen> createState() => _QuoteCarouselScreenState();
}

class _QuoteCarouselScreenState extends State<QuoteCarouselScreen> {
  final ConfettiController _confettiController = ConfettiController();
  final CarouselSliderController _carouselController = CarouselSliderController();

  late List<String> _visibleQuotes;
  bool _autoScrollEnabled = false;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _filterQuotes();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  void _filterQuotes() {
    final hidden = context.read<HiddenQuotesProvider>();
    _visibleQuotes = widget.quotes
        .where((q) => !hidden.isHidden(q))
        .toList();
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

  void _hideQuote(String quote) {
    setState(() {
      _visibleQuotes.remove(quote);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Consumer<StyleProvider>(
      builder: (context, style, _) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return Scaffold(
      backgroundColor: isDark ? style.scaffoldBg : AppColors.surfaceLight,
      body: Builder(
        builder: (context) {
          if (_visibleQuotes.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  "All quotes in this category are hidden.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return Column(
            children: [
              // ─── Brand Header ─────────────────────────
              if (widget.showHeader)
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                    child: Text(
                      "Her.",
                      style: GoogleFonts.montserratAlternates(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),

              // ─── Quote Carousel ───────────────────────
              Expanded(
                child: CarouselSlider.builder(
                  carouselController: _carouselController,
                  itemCount: _visibleQuotes.length,
                  itemBuilder: (context, index, _) {
                    final quote = _visibleQuotes[index];
                    return _QuoteCard(
                      quote: quote,
                      tagLabel: widget.tagLabel,
                      style: style,
                      confettiController: _confettiController,
                      autoScrollEnabled: _autoScrollEnabled,
                      onToggleAutoScroll: _toggleAutoScroll,
                      onHideComplete: () => _hideQuote(quote),
                    );
                  },
                  options: CarouselOptions(
                    height: screenHeight * 0.78,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    enableInfiniteScroll: _visibleQuotes.length > 1,
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

/// Individual quote card widget — extracted to reduce nesting.
class _QuoteCard extends StatelessWidget {
  final String quote;
  final String tagLabel;
  final StyleProvider style;
  final ConfettiController confettiController;
  final bool autoScrollEnabled;
  final VoidCallback onToggleAutoScroll;
  final VoidCallback onHideComplete;

  const _QuoteCard({
    required this.quote,
    required this.tagLabel,
    required this.style,
    required this.confettiController,
    required this.autoScrollEnabled,
    required this.onToggleAutoScroll,
    required this.onHideComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: (style.cardGradient == null && style.backgroundImage.isEmpty)
            ? style.cardColor
            : null,
        gradient: style.backgroundImage.isEmpty ? style.cardGradient : null,
        borderRadius: BorderRadius.circular(16),
        image: style.backgroundImage.isNotEmpty
            ? DecorationImage(
                image: AssetImage(style.backgroundImage),
                fit: BoxFit.cover,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // ─── Action Bar ─────────────────────────
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 14),
              child: QuoteActionBar(
                currentQuote: quote,
                confettiController: confettiController,
                autoScrollEnabled: autoScrollEnabled,
                onToggleAutoScroll: onToggleAutoScroll,
                onHideComplete: onHideComplete,
              ),
            ),
          ),

          // ─── Quote Text ─────────────────────────
          Builder(builder: (context) {
            final isLightText =
                ThemeData.estimateBrightnessForColor(style.fontColor) ==
                    Brightness.light;
            final shadowColor =
                isLightText ? Colors.black : Colors.white;
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
                child: Text(
                  quote,
                  style: AppFonts.safeGetFont(
                    style.fontFamily,
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: style.fontColor,
                    height: 1.4,
                    shadows: isLightText
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

          // ─── Tag Label ──────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "- $tagLabel",
                  style: AppFonts.safeGetFont(
                    style.fontFamily,
                    color: Colors.white.withOpacity(0.95),
                    fontSize: 14,
                    shadows: const [
                      Shadow(blurRadius: 4, color: Colors.black87),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
