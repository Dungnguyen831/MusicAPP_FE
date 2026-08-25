import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/stitch_colors.dart';

/// Một thẻ Card cao cấp hỗ trợ hiệu ứng Glassmorphism (Liquid Glass) độc bản.
/// Kết hợp [BackdropFilter] mờ nhòe, nền mờ đục nhẹ và viền gradient mỏng phát sáng.
class LiquidGlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final List<Color>? borderGradientColors;

  const LiquidGlassCard({
    super.key,
    required this.child,
    this.blur = 20.0,
    this.borderRadius = 24.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.backgroundColor,
    this.borderGradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = backgroundColor ?? StitchColors.darkSurface.withOpacity(0.45);
    final effectiveBorderColors = borderGradientColors ?? [
      StitchColors.primary.withOpacity(0.35),
      StitchColors.secondary.withOpacity(0.15),
      Colors.transparent,
    ];

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: CustomPaint(
            painter: _GradientBorderPainter(
              borderRadius: borderRadius,
              gradientColors: effectiveBorderColors,
              strokeWidth: 1.2,
            ),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                color: effectiveBgColor,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Vẽ viền Gradient mỏng bo góc mượt mà cho hiệu ứng phát sáng Liquid Glass
class _GradientBorderPainter extends CustomPainter {
  final double borderRadius;
  final List<Color> gradientColors;
  final double strokeWidth;

  _GradientBorderPainter({
    required this.borderRadius,
    required this.gradientColors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors,
      ).createShader(rect);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _GradientBorderPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gradientColors != gradientColors;
  }
}
