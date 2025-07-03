import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;

  const CustomIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color iconColor =
    theme.brightness == Brightness.dark ? Colors.white54: Colors.black;

    return InkWell(
      onTap: onPressed,
      child: Center(
        child: IconTheme(
          data: IconThemeData(
            color: iconColor,
          ),
          child: icon,
        ),
      ),
    );
  }
}