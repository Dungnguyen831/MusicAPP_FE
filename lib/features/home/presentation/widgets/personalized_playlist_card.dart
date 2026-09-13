import 'package:flutter/material.dart';
import '../../../../core/theme/stitch_colors.dart';
import '../../../../core/widgets/liquid_glass_card.dart';
import '../../../playlist/domain/playlist_model.dart';

/// Mục hiển thị danh sách Playlist cá nhân hóa theo phong cách Liquid Glass
class PersonalizedPlaylistSection extends StatelessWidget {
  final List<PlaylistModel> playlists;
  final void Function(PlaylistModel playlist)? onPlaylistTap;
  final VoidCallback? onSeeAll;

  const PersonalizedPlaylistSection({
    super.key,
    required this.playlists,
    this.onPlaylistTap,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    if (playlists.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dành riêng cho bạn',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: StitchColors.textPrimary,
                    ),
              ),
              if (onSeeAll != null)
                TextButton(
                  onPressed: onSeeAll,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Xem tất cả',
                    style: TextStyle(
                      color: StitchColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Horizontal List
        SizedBox(
          height: 236,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: playlists.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final playlist = playlists[index];
              return _PersonalizedCardItem(
                playlist: playlist,
                onTap: () => onPlaylistTap?.call(playlist),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PersonalizedCardItem extends StatelessWidget {
  final PlaylistModel playlist;
  final VoidCallback? onTap;

  const _PersonalizedCardItem({
    required this.playlist,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LiquidGlassCard(
        width: 154,
        borderRadius: 20,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Artwork
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: playlist.coverUrl != null
                        ? Image.network(
                            playlist.coverUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              color: StitchColors.darkSurfaceVariant,
                              child: const Icon(
                                Icons.music_note_rounded,
                                color: StitchColors.neutral,
                                size: 36,
                              ),
                            ),
                          )
                        : Container(
                            color: StitchColors.darkSurfaceVariant,
                            child: const Icon(
                              Icons.music_note_rounded,
                              color: StitchColors.neutral,
                              size: 36,
                            ),
                          ),
                  ),
                  // Subtle gradient shadow overlay at bottom of cover
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Small play icon overlay
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: StitchColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: StitchColors.darkBackground,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Playlist Name
            Text(
              playlist.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: StitchColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 3),

            // Song count or description
            Text(
              playlist.description ?? '${playlist.songs.length} bài hát',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: StitchColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
