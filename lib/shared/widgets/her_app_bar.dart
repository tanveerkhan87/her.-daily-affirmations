import 'package:flutter/material.dart';
import '../../core/constants/app_typography.dart';

/// Consistent app bar used across all screens.
class HerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const HerAppBar({super.key, required this.title, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: AppTypography.appBarTitle()),
      actions: actions,
    );
  }
}
