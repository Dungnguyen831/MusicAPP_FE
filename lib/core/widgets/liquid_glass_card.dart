import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import '../theme/stitch_colors.dart';

/// Một thẻ Card cao cấp hỗ trợ hiệu ứng Glassmorphism (Liquid Glass) độc bản.
/// Được hiện thực dựa trên [GlassCard] của thư viện [liquid_glass_widgets].
/// Tích hợp shader khúc xạ mờ thực tế, viền phản quang specular highlight,
/// và viền phát sáng gradient mỏng chuẩn Dark Mode của Stitch Music.
class LiquidGlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final List<Color>? borderGradientColors;
  final double? width;
  final double? height;

  const LiquidGlassCard({
    super.key,
    required this.child,
    this.blur = 14.0,
    this.borderRadius = 24.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.backgroundColor,
    this.borderGradientColors,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // Màu nền tối đa dạng với độ mờ chuẩn theo docs/UI_DESIGN_SYSTEM.md (0.45 alpha)
    final effectiveBgColor = backgroundColor ??
        StitchColors.darkSurface.withValues(alpha: 0.45);

    // Viền gradient ánh sáng mỏng đặc trưng của Stitch Music
    final effectiveBorderColors = borderGradientColors ??
        [
          StitchColors.primary.withValues(alpha: 0.35),
          StitchColors.secondary.withValues(alpha: 0.15),
          Colors.transparent,
        ];

    // Cấu hình LiquidGlassSettings tối ưu cho Dark Mode & hiệu năng cuộn:
    // - blur: 14.0 giảm tải đáng kể phép tính convolution kernel so với 20.0
    // - thickness & glowIntensity: tối ưu nhẹ nhàng cho GPU raster cache
    final glassSettings = LiquidGlassSettings(
      blur: blur,
      glassColor: effectiveBgColor,
      thickness: 18,
      lightIntensity: 0.6,
      ambientStrength: 0.1,
      ambientRim: 0.08,
      glowIntensity: 0.65,
      fresnelStrength: 1.1,
      specularSharpness: GlassSpecularSharpness.medium,
      saturation: 1.25,
      chromaticAberration: 0.01,
      refractiveIndex: 1.2,
    );

    return RepaintBoundary(
      child: Container(
        margin: margin,
        width: width,
        height: height,
        child: GlassCard(
          useOwnLayer: true,
          settings: glassSettings,
          shape: LiquidRoundedSuperellipse(
            borderRadius: borderRadius,
            side: const BorderSide(
              color: StitchColors.borderLight,
              width: 1.2,
            ),
          ),
          padding: EdgeInsets.zero,
          child: CustomPaint(
            painter: _GradientBorderPainter(
              borderRadius: borderRadius,
              gradientColors: effectiveBorderColors,
              strokeWidth: 1.2,
            ),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(16.0),
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

  const _GradientBorderPainter({
    required this.borderRadius,
    required this.gradientColors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (gradientColors.isEmpty) return;
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

