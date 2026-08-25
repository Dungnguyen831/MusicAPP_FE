import 'package:flutter/material.dart';

/// Bảng màu độc bản Stitch Color Palette của dự án
class StitchColors {
  // Ngăn khởi tạo instance
  StitchColors._();

  // Các màu sắc cốt lõi trích xuất từ Design System Stitch
  static const Color primary = Color(0xFFC084C4);     // Màu tím hồng Stitch ngọt ngào
  static const Color secondary = Color(0xFFE05A5A);   // Màu đỏ cam cá tính, rực rỡ
  static const Color tertiary = Color(0xFF8DA14B);    // Màu xanh lá phong cách retro
  static const Color neutral = Color(0xFF7C757A);     // Màu xám trầm ấm trung tính

  // Bảng màu tối (Dark Mode Colors) theo đúng phong cách Stitch Design
  static const Color darkBackground = Color(0xFF0E0B0E); // Màu nền tối đen pha ánh tím siêu sâu
  static const Color darkSurface = Color(0xFF1E1A1F);    // Màu thẻ nổi Liquid Glass tối hơn
  static const Color darkSurfaceVariant = Color(0xFF2E2930); // Màu biến thể của bề mặt

  // Các màu văn bản & trạng thái
  static const Color textPrimary = Color(0xFFF5F3F5);  // Màu chữ chính (gần như trắng)
  static const Color textSecondary = Color(0xFFA59EA4); // Màu chữ phụ (xám nhạt ánh tím)
  static const Color borderLight = Color(0x33C084C4);   // Viền phát sáng mỏng Liquid Glass (gradient mờ)
}
