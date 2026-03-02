import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class LiquidGlassCard extends StatelessWidget {
  const LiquidGlassCard({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.margin,
    this.padding,
    this.borderRadius = 28,
    this.blur = 10,
  });

  final Widget child;
  final double? height, width;
  final EdgeInsetsGeometry? margin, padding;
  final double borderRadius;
  final double blur;

  @override
  Widget build(BuildContext context) {
    // IntrinsicWidth prevents the card from stretching to full width.
    // When an explicit width is provided it is honoured; otherwise
    // the card shrink-wraps around its child.
    Widget card = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(28),
            blurRadius: 84,
            spreadRadius: 2,
            offset: const Offset(0, 36),
          ),
          BoxShadow(
            color: Colors.black.withAlpha(14),
            blurRadius: 34,
            spreadRadius: 0,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.white.withAlpha(16),
            blurRadius: 22,
            spreadRadius: -5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          fit: StackFit.passthrough, // children follow the size of child content
          children: [
          /// 🔹 Real Background Blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: blur,
                sigmaY: blur,
              ),
              child: const SizedBox.shrink(),
            ),
          ),

          /// 🔹 Glass Layer (the sizing layer)
          Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),

              /// Gradient Tint — much lighter for deeper transparency
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withAlpha(8),
                  Colors.white.withAlpha(2),
                ],
              ),
            ),
            child: child,
          ),

          /// 🔹 Top Light Reflection Overlay — subtler highlight
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.center,
                    colors: [
                      Colors.white.withAlpha(20),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// 🔹 Asymmetric liquid border + border glow shadow
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _LiquidBorderPainter(
                  radius: borderRadius,
                  strokeWidth: 1.7,
                ),
              ),
            ),
          ),
          ],
        ),
      ),
    );

    // Apply explicit sizing / margin when provided, otherwise shrink-wrap.
    if (width != null || height != null || margin != null) {
      card = Container(
        margin: margin,
        height: height,
        width: width,
        child: card,
      );
    }

    return card;
  }
}

class _LiquidBorderPainter extends CustomPainter {
  const _LiquidBorderPainter({required this.radius, required this.strokeWidth});

  final double radius;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(strokeWidth / 2),
      Radius.circular(radius),
    );

    // Align fade dips to REAL corner angles for current aspect ratio.
    // (Default 0.875 works only when width == height)
    final topRightAngle = math.atan2(-size.height * 0.5, size.width * 0.5);
    final topRightTurn = ((topRightAngle / (2 * math.pi)) + 1) % 1;
    final rotationTurns = topRightTurn - 0.875;

    final borderShader = SweepGradient(
      center: Alignment.center,
      // Keep border visible on edges; only tiny dips at two corners:
      // - bottom-left corner (~0.375)
      // - top-right corner  (~0.875)
      transform: GradientRotation(rotationTurns * 2 * math.pi),
      colors: [
        Colors.white.withAlpha(78),
        Colors.white.withAlpha(70),
        Colors.white.withAlpha(62),
        Colors.white.withAlpha(20),
        Colors.white.withAlpha(1),
        Colors.white.withAlpha(22),
        Colors.white.withAlpha(64),
        Colors.white.withAlpha(74),
        Colors.white.withAlpha(62),
        Colors.white.withAlpha(20),
        Colors.white.withAlpha(1),
        Colors.white.withAlpha(22),
        Colors.white.withAlpha(78),
      ],
      stops: const [
        0.00,
        0.22,
        0.34,
        0.366,
        0.375,
        0.384,
        0.41,
        0.66,
        0.84,
        0.866,
        0.875,
        0.884,
        1.00,
      ],
    ).createShader(rect);

    final shadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 1.1
      ..shader = borderShader
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = borderShader;

    canvas.drawRRect(rrect, shadowPaint);
    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _LiquidBorderPainter oldDelegate) {
    return oldDelegate.radius != radius || oldDelegate.strokeWidth != strokeWidth;
  }
}