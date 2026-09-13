import 'package:flutter/material.dart';
import '../../../core/theme/stitch_colors.dart';
import '../../../core/widgets/liquid_glass_card.dart';
import '../presentation/login_screen.dart';

/// Modal Bottom Sheet cảnh báo & yêu cầu đăng nhập khi người dùng Guest
/// truy cập vào các tính năng yêu cầu tài khoản (Tạo playlist, thích bài hát, v.v.)
class GuestBottomSheet extends StatelessWidget {
  /// Tiêu đề hiển thị trên BottomSheet
  final String? title;

  /// Nội dung thông điệp chi tiết
  final String? message;

  /// Callback tùy chọn khi người dùng bấm "Đăng nhập ngay"
  /// (Mặc định sẽ tự động điều hướng sang [LoginScreen])
  final VoidCallback? onLoginPressed;

  /// Callback khi người dùng bấm "Để sau" hoặc đóng sheet
  final VoidCallback? onDismissed;

  const GuestBottomSheet({
    super.key,
    this.title,
    this.message,
    this.onLoginPressed,
    this.onDismissed,
  });

  /// Phương thức tiện ích tĩnh hiển thị [GuestBottomSheet] dưới dạng Modal Bottom Sheet
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    String? message,
    VoidCallback? onLoginPressed,
    VoidCallback? onDismissed,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      isScrollControlled: true,
      builder: (bottomSheetContext) => GuestBottomSheet(
        title: title,
        message: message,
        onLoginPressed: onLoginPressed,
        onDismissed: onDismissed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0 + bottomInset),
        child: LiquidGlassCard(
          borderRadius: 32,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          backgroundColor: StitchColors.darkSurface.withValues(alpha: 0.85),
          borderGradientColors: [
            StitchColors.primary.withValues(alpha: 0.5),
            StitchColors.secondary.withValues(alpha: 0.25),
            Colors.transparent,
          ],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Thanh kéo (Drag Handle)
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: StitchColors.neutral.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Glowing Icon Badge
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        StitchColors.primary,
                        StitchColors.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: StitchColors.primary.withValues(alpha: 0.4),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lock_person_rounded,
                    size: 36,
                    color: StitchColors.darkBackground,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Title
              Text(
                title ?? 'Trải nghiệm trọn vẹn âm nhạc',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: StitchColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
              ),
              const SizedBox(height: 10),

              // Message
              Text(
                message ??
                    'Đăng nhập để lưu bài hát yêu thích, tạo playlist cá nhân và đồng bộ lịch sử nghe nhạc trên mọi thiết bị.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: StitchColors.textSecondary,
                      height: 1.45,
                    ),
              ),
              const SizedBox(height: 20),

              // Danh sách quyền lợi nổi bật (Feature Highlights)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: StitchColors.darkSurfaceVariant.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: StitchColors.borderLight,
                    width: 0.8,
                  ),
                ),
                child: Column(
                  children: const [
                    _BenefitRow(
                      icon: Icons.favorite_rounded,
                      iconColor: StitchColors.secondary,
                      text: 'Lưu bài hát vào danh sách Yêu thích',
                    ),
                    SizedBox(height: 8),
                    _BenefitRow(
                      icon: Icons.queue_music_rounded,
                      iconColor: StitchColors.primary,
                      text: 'Tự tạo và quản lý Playlist riêng biệt',
                    ),
                    SizedBox(height: 8),
                    _BenefitRow(
                      icon: Icons.cloud_sync_rounded,
                      iconColor: StitchColors.tertiary,
                      text: 'Đồng bộ thư viện nhạc qua đám mây',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Nút "Đăng nhập ngay" (Primary CTA)
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onLoginPressed != null) {
                      onLoginPressed!();
                    } else {
                      LoginScreen.navigateTo(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: StitchColors.primary,
                    foregroundColor: StitchColors.darkBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 4,
                    shadowColor: StitchColors.primary.withValues(alpha: 0.5),
                  ),
                  child: const Text(
                    'Đăng nhập ngay',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Nút "Để sau" (Secondary / Dismiss)
              SizedBox(
                height: 44,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onDismissed?.call();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: StitchColors.textSecondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: const Text(
                    'Để sau',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dòng hiển thị quyền lợi với biểu tượng màu sắc
class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;

  const _BenefitRow({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: iconColor,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: StitchColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
