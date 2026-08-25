import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_test/core/theme/stitch_colors.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String? avatarUrl;

  const HomeHeader({
    super.key,
    required this.userName,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: avatarUrl != null
                    ? NetworkImage(avatarUrl!)
                    : null,
                child: avatarUrl == null
                    ? const Icon(Icons.person, color: StitchColors.textPrimary) // Default icon
                    : null,
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
          Row(
            children: [
              _buildGlassButton(Icons.search, () {
                // TODO: Implement search functionality
              }),
              const SizedBox(width: 12),
              _buildGlassButton(Icons.notifications_none, () {
                // TODO: Implement notification functionality
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlassButton(IconData icon, VoidCallback onPressed) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.0), // Rounded pill shape
      child: Material(
        color: StitchColors.darkSurface.withOpacity(0.4),
        child: InkWell(
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
