// ──────────────────────────────────────────────────────────────
// lib/core/theme/app_fonts.dart
// PURPOSE : Centralized registry of supported Google Fonts.
//           Allows changing the app's typeface from one place.
// ──────────────────────────────────────────────────────────────

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/widgets.dart';

/// Registry of available fonts.
/// Key = internal identifier, value = human label.
final Map<String, String> appFonts = {
  'inter': 'Inter',
  'outfit': 'Outfit',
  'roboto': 'Roboto',
  'playfair': 'Playfair Display',
  'lexend': 'Lexend',
};

class AppTypography {
  const AppTypography._();

  /// Returns the selected font's family name or a fallback.
  static String? getFontFamily(String key) {
    switch (key) {
      case 'inter':
        return GoogleFonts.inter().fontFamily;
      case 'outfit':
        return GoogleFonts.outfit().fontFamily;
      case 'roboto':
        return GoogleFonts.roboto().fontFamily;
      case 'playfair':
        return GoogleFonts.playfairDisplay().fontFamily;
      case 'lexend':
        return GoogleFonts.lexend().fontFamily;
      default:
        return GoogleFonts.inter().fontFamily;
    }
  }

  /// Optional: Get a fully styled TextStyle for a specific font.
  static TextStyle getStyle(String key, {TextStyle? baseStyle}) {
    switch (key) {
      case 'inter':
        return GoogleFonts.inter(textStyle: baseStyle);
      case 'outfit':
        return GoogleFonts.outfit(textStyle: baseStyle);
      case 'roboto':
        return GoogleFonts.roboto(textStyle: baseStyle);
      case 'playfair':
        return GoogleFonts.playfairDisplay(textStyle: baseStyle);
      case 'lexend':
        return GoogleFonts.lexend(textStyle: baseStyle);
      default:
        return GoogleFonts.inter(textStyle: baseStyle);
    }
  }
}
