import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized typography for a consistent, polished look.
abstract final class AppTypography {
  /// The brand title style ("Her.")
  static TextStyle brand({double fontSize = 34, Color? color}) {
    return GoogleFonts.montserratAlternates(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  /// Large heading
  static TextStyle heading1({Color? color}) {
    return GoogleFonts.montserratAlternates(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  /// Section heading
  static TextStyle heading2({Color? color}) {
    return GoogleFonts.montserratAlternates(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  /// Card / subsection heading
  static TextStyle heading3({Color? color}) {
    return GoogleFonts.lato(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  /// Body text
  static TextStyle body({Color? color, double fontSize = 16}) {
    return GoogleFonts.lato(
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
      color: color,
      height: 1.5,
    );
  }

  /// Caption / subtitle text
  static TextStyle caption({Color? color}) {
    return GoogleFonts.lato(
      fontSize: 13,
      fontWeight: FontWeight.normal,
      color: color,
    );
  }

  /// Button text
  static TextStyle button({Color? color}) {
    return GoogleFonts.lato(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  /// App bar title
  static TextStyle appBarTitle({Color? color}) {
    return GoogleFonts.montserratAlternates(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }
}
