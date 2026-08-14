import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/favorites_provider.dart';
import '../providers/hidden_quotes_provider.dart';
import '../providers/style_provider.dart';
import '../../features/music/music_player_sheet.dart';

/// The floating action bar that sits on top of every quote card.
/// Contains: music, hide, favorite, auto-scroll, share buttons.
class QuoteActionBar extends StatelessWidget {
  final String currentQuote;
  final ConfettiController confettiController;
  final bool autoScrollEnabled;
  final VoidCallback onToggleAutoScroll;
  final VoidCallback? onHideComplete;

  const QuoteActionBar({
    super.key,
    required this.currentQuote,
    required this.confettiController,
    required this.autoScrollEnabled,
    required this.onToggleAutoScroll,
    this.onHideComplete,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.watch<StyleProvider>();
    final favorites = context.watch<FavoritesProvider>();
    final hidden = context.read<HiddenQuotesProvider>();
    final isFav = favorites.isFavorite(currentQuote);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        borderRadius: BorderRadius.circular(30),
      ),
      height: 48,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Music
          _BarButton(
            icon: Icons.music_note_rounded,
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => const MusicPlayerSheet(),
            ),
          ),
          // Hide
          _BarButton(
            icon: Icons.visibility_off_outlined,
            onTap: () => hidden.hideQuote(currentQuote, onHidden: onHideComplete),
          ),
          // Favorite (with confetti)
          GestureDetector(
            onTap: () {
              if (!isFav) confettiController.play();
              favorites.toggle(currentQuote);
              if (!isFav) {
                Timer(const Duration(seconds: 2), () => confettiController.stop());
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                ConfettiWidget(
                  confettiController: confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  emissionFrequency: 0.01,
                  numberOfParticles: 5,
                  gravity: 0.08,
                  shouldLoop: false,
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isFav
                      ? BounceInDown(
                          key: const ValueKey('filled'),
                          child: const Icon(Icons.favorite, color: Colors.red, size: 28),
                        )
                      : BounceInDown(
                          key: const ValueKey('outline'),
                          child: const Icon(Icons.favorite_border, color: Colors.white, size: 28),
                        ),
                ),
              ],
            ),
          ),
          // Auto-scroll
          _BarButton(
            icon: autoScrollEnabled ? Icons.pause_circle_filled : Icons.play_circle_outline,
            onTap: onToggleAutoScroll,
          ),
          // Share
          _BarButton(
            icon: Icons.share_rounded,
            onTap: () => Share.share('"$currentQuote"'),
          ),
        ],
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _BarButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: 20),
      onPressed: onTap,
      padding: const EdgeInsets.all(6),
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }
}
