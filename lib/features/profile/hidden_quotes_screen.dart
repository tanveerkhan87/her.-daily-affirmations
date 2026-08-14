import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/providers/hidden_quotes_provider.dart';
import '../../shared/widgets/her_app_bar.dart';

/// Displays all hidden quotes with unhide capability.
class HiddenQuotesScreen extends StatelessWidget {
  const HiddenQuotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const HerAppBar(title: 'Hidden Quotes'),
      body: Consumer<HiddenQuotesProvider>(
        builder: (context, hidden, _) {
          if (hidden.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.visibility_off_rounded, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text('No hidden quotes', style: GoogleFonts.lato(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: AppSpacing.paddingAllMd,
            itemCount: hidden.items.length,
            itemBuilder: (context, index) {
              final quote = hidden.items[index];
              final bgColor = index % 2 == 0 ? Colors.purple.shade50 : Colors.pink.shade50;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FadeInUp(
                  duration: const Duration(milliseconds: 350),
                  delay: Duration(milliseconds: 50 * index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : bgColor,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.15 : 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accent.withOpacity(0.15),
                        ),
                        child: const Icon(Icons.format_quote_rounded, color: AppColors.accent),
                      ),
                      title: Text(
                        quote,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      subtitle: const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text('Tap to unhide', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ),
                      onTap: () => hidden.unhideQuote(quote),
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
