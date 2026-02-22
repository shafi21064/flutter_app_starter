// ──────────────────────────────────────────────────────────────
// lib/core/ui/app_colors.dart
// PURPOSE : Fixed semantic colors that remain consistent
//           across themes or serve as base constants.
// ──────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Branding ────────────────────────────────────────────────
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFFFF6584);

  // ── Semantic ────────────────────────────────────────────────
  static const Color success = Color(0xFF43A047);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA000);
  static const Color info = Color(0xFF1976D2);

  // ── Neutrals ───────────────────────────────────────────────
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static final Color greyLight = Colors.grey.shade200;
  static final Color greyDark = Colors.grey.shade800;

  // ── Specific UI ────────────────────────────────────────────
  static const Color loadingBarrier = Colors.black38;
}
