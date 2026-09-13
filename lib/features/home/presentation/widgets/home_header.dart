import 'package:flutter/material.dart';
import '../../../../core/theme/stitch_colors.dart';
import '../../../../core/widgets/liquid_glass_card.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String? avatarUrl;
  final VoidCallback? onAvatarTap;

  const HomeHeader({
    super.key,
    required this.userName,
    this.avatarUrl,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onAvatarTap,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: avatarUrl != null
                        ? ResizeImage(NetworkImage(avatarUrl!), width: 96, height: 96)
                        : null,
                    onBackgroundImageError: avatarUrl != null ? (_, _) {} : null,
                    child: const Icon(Icons.person, color: StitchColors.textPrimary),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Xin chào, $userName',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: StitchColors.textPrimary,
                        ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                _buildGlassButton(Icons.search, () {
                  // Search functionality
                }),
                const SizedBox(width: 12),
                _buildGlassButton(Icons.notifications_none, () {
                  // Notification functionality
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassButton(IconData icon, VoidCallback onPressed) {
    return LiquidGlassCard(
      borderRadius: 24.0,
      blur: 15.0,
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24.0),
          onTap: onPressed,
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(icon, color: StitchColors.textPrimary, size: 24),
          ),
        ),
      ),
    );
  }
}
