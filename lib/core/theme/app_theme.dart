import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'stitch_colors.dart';

/// Quản lý cấu hình ThemeData toàn cục của ứng dụng
class AppTheme {
  // Ngăn khởi tạo instance
  AppTheme._();

  /// ThemeData Dark Mode chuẩn Material 3, áp dụng bảng màu độc bản Stitch Color Palette
  static ThemeData get darkTheme {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
    );

    return baseTheme.copyWith(
      scaffoldBackgroundColor: StitchColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: StitchColors.primary,
        secondary: StitchColors.secondary,
        tertiary: StitchColors.tertiary,
        surface: StitchColors.darkSurface,
        surfaceContainerLow: StitchColors.darkSurface, // Thay thế cho surfaceVariant của M3 cũ
        surfaceContainerHigh: StitchColors.darkSurfaceVariant,
        error: StitchColors.secondary,
        onPrimary: StitchColors.darkBackground,
        onSecondary: StitchColors.textPrimary,
        onSurface: StitchColors.textPrimary,
        onSurfaceVariant: StitchColors.textSecondary,
      ),
      // Cấu hình phông chữ theo chuẩn thiết kế Stitch
      textTheme: GoogleFonts.plusJakartaSansTextTheme(baseTheme.textTheme).copyWith(
        // Headline áp dụng Plus Jakarta Sans (được kế thừa từ plusJakartaSansTextTheme)
        displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: StitchColors.textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.plusJakartaSans(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: StitchColors.textPrimary,
          letterSpacing: -0.5,
        ),
        displaySmall: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: StitchColors.textPrimary,
        ),
        headlineLarge: GoogleFonts.plusJakartaSans(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: StitchColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: StitchColors.textPrimary,
        ),
        headlineSmall: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: StitchColors.textPrimary,
        ),
        // Body áp dụng Plus Jakarta Sans
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: StitchColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: StitchColors.textSecondary,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: StitchColors.textSecondary,
        ),
        // Label áp dụng phông chuyên biệt JetBrains Mono
        labelLarge: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: StitchColors.textPrimary,
          letterSpacing: 0.5,
        ),
        labelMedium: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: StitchColors.textSecondary,
          letterSpacing: 0.5,
        ),
        labelSmall: GoogleFonts.jetBrainsMono(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: StitchColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
      // Cấu hình các nút bấm (Buttons)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: StitchColors.primary,
          foregroundColor: StitchColors.darkBackground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // Cấu hình thanh Navigation Bar phía dưới
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: StitchColors.darkBackground,
        indicatorColor: StitchColors.primary.withOpacity(0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: StitchColors.primary,
            );
          }
          return GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: StitchColors.textSecondary,
          );
        }),
      ),
    );
  }
}
