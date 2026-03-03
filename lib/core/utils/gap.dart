import 'package:flutter/widgets.dart';

import 'app_sizes.dart';

/// Responsive spacing helpers for quick layout composition.
///
/// Example:
/// `Column(children: [Text('A'), Gap.h12, Text('B')])`
class Gap {
  const Gap._();

  static SizedBox h(double size) => SizedBox(height: size * AppSizes.scale);
  static SizedBox w(double size) => SizedBox(width: size * AppSizes.scale);

  // Vertical
  static SizedBox get h4 => h(4);
  static SizedBox get h8 => h(8);
  static SizedBox get h12 => h(12);
  static SizedBox get h16 => h(16);
  static SizedBox get h20 => h(20);
  static SizedBox get h24 => h(24);
  static SizedBox get h32 => h(32);
  static SizedBox get h40 => h(40);
  static SizedBox get h48 => h(48);

  // Horizontal
  static SizedBox get w4 => w(4);
  static SizedBox get w8 => w(8);
  static SizedBox get w12 => w(12);
  static SizedBox get w16 => w(16);
  static SizedBox get w20 => w(20);
  static SizedBox get w24 => w(24);
  static SizedBox get w32 => w(32);
  static SizedBox get w40 => w(40);
  static SizedBox get w48 => w(48);
}
