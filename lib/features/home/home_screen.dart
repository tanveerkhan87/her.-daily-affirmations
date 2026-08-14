import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/quotes_repository.dart';
import '../../shared/providers/category_provider.dart';
import '../favorites/favorites_carousel_screen.dart';
import '../quotes/quote_carousel_screen.dart';

/// Home screen — launches the generic carousel with the selected category.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        final categoryId = categoryProvider.selectedCategoryId;
        
        if (categoryId == 'my_favorites') {
          return const FavoritesCarouselScreen();
        }

        if (categoryId == 'all_kinds') {
          return const QuoteCarouselScreen(
            quotes: QuotesRepository.homeQuotes,
            tagLabel: 'All Kinds',
          );
        }

        final category = QuotesRepository.findById(categoryId);
        if (category != null) {
          return QuoteCarouselScreen(
            quotes: category.quotes,
            tagLabel: category.title.replaceAll('\n', ' '),
          );
        }

        // Fallback
        return const QuoteCarouselScreen(
          quotes: QuotesRepository.homeQuotes,
          tagLabel: 'All Kinds',
        );
      },
    );
  }
}
