import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/providers/favorites_provider.dart';
import '../../shared/widgets/her_app_bar.dart';
import 'favorites_carousel_screen.dart';

/// List view of all favorited quotes with remove capability.
class FavoritesListScreen extends StatelessWidget {
  const FavoritesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HerAppBar(title: 'Favorite Quotes'),
      body: Consumer<FavoritesProvider>(
        builder: (context, favorites, _) {
          if (favorites.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border_rounded, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text('No favorites yet', style: GoogleFonts.lato(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: AppSpacing.paddingAllMd,
            itemCount: favorites.items.length,
            itemBuilder: (context, index) {
              final quote = favorites.items[index];
              final gradients = [AppColors.cardGradientA, AppColors.cardGradientB];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const FavoritesCarouselScreen()),
                  ),
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 400),
                    delay: Duration(milliseconds: 60 * index),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: gradients[index % gradients.length],
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      padding: AppSpacing.paddingAllMd,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              quote,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => favorites.removeItem(quote),
                            icon: const Icon(Icons.favorite, color: Colors.redAccent, size: 28),
                            tooltip: 'Remove from Favorites',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
