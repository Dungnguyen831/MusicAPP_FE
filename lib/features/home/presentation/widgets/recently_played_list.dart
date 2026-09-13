import 'package:flutter/material.dart';
import '../../../../core/theme/stitch_colors.dart';
import '../../../../core/widgets/liquid_glass_card.dart';
import '../../../player/domain/song_model.dart';

/// Mục hiển thị danh sách bài hát nghe gần đây (Recently Played)
class RecentlyPlayedSection extends StatelessWidget {
  final List<SongModel> songs;
  final void Function(SongModel song)? onSongTap;
  final VoidCallback? onSeeAll;

  const RecentlyPlayedSection({
    super.key,
    required this.songs,
    this.onSongTap,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nghe gần đây',
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
          height: 188,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: songs.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final song = songs[index];
              return _RecentlyPlayedItem(
                song: song,
                onTap: () => onSongTap?.call(song),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RecentlyPlayedItem extends StatelessWidget {
  final SongModel song;
  final VoidCallback? onTap;

  const _RecentlyPlayedItem({
    required this.song,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LiquidGlassCard(
        width: 120,
        borderRadius: 18,
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: song.coverUrl.isNotEmpty
                    ? Image.network(
                        song.coverUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: StitchColors.darkSurfaceVariant,
                          child: const Icon(
                            Icons.music_note_rounded,
                            color: StitchColors.neutral,
                            size: 28,
                          ),
                        ),
                      )
                    : Container(
                        color: StitchColors.darkSurfaceVariant,
                        child: const Icon(
                          Icons.music_note_rounded,
                          color: StitchColors.neutral,
                          size: 28,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),

            // Song Title
            Text(
              song.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: StitchColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 2),

            // Artist
            Text(
              song.artist,
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
