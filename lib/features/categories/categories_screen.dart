import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../data/models/quote_category.dart';
import '../../data/quotes_repository.dart';
import '../../shared/providers/category_provider.dart';
import '../../shared/widgets/her_app_bar.dart';

/// Grid of all quote categories with smooth animations.
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HerAppBar(title: 'Categories'),
      body: FadeInUp(
        duration: const Duration(milliseconds: 400),
        child: Consumer<CategoryProvider>(
          builder: (context, categoryProvider, child) {
            final selectedId = categoryProvider.selectedCategoryId;
            return GridView.builder(
              padding: const EdgeInsets.all(14),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.0,
              ),
              itemCount: QuotesRepository.categories.length + 2,
              itemBuilder: (context, index) {
                // First tile: All Kinds
                if (index == 0) {
                  return _CategoryTile(
                    image: 'assets/images/allkind.jpg',
                    title: 'All Kinds',
                    isSelected: selectedId == 'all_kinds',
                    onTap: () => categoryProvider.setCategory('all_kinds'),
                  );
                }
                // Second tile: My Favorites
                if (index == 1) {
                  return _CategoryTile(
                    image: 'assets/images/myfav.jpg',
                    title: 'My Favorites',
                    isSelected: selectedId == 'my_favorites',
                    onTap: () => categoryProvider.setCategory('my_favorites'),
                  );
                }
                // Remaining: category tiles
                final category = QuotesRepository.categories[index - 2];
                return _CategoryTile(
                  image: category.image,
                  title: category.title,
                  isSelected: selectedId == category.id,
                  onTap: () => categoryProvider.setCategory(category.id),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _CategoryTile extends StatefulWidget {
  final String image;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.image,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<_CategoryTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ─── Full-bleed image ──────────────────
                Image.asset(
                  widget.image,
                  fit: BoxFit.cover,
                ),

                // ─── Dark gradient overlay ─────────────
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.15),
                        Colors.black.withOpacity(0.65),
                      ],
                      stops: const [0.4, 0.65, 1.0],
                    ),
                  ),
                ),

                // ─── Title at bottom ───────────────────
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.3,
                        shadows: [
                          Shadow(blurRadius: 6, color: Colors.black54),
                        ],
                      ),
                    ),
                  ),
                ),

                // ─── Checkmark if selected ─────────────
                if (widget.isSelected)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
