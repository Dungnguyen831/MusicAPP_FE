import 'package:flutter/material.dart';
import 'package:project_test/core/theme/stitch_colors.dart';
import 'package:project_test/features/player/domain/song_model.dart';

/// Header mục danh sách bài hát phổ biến
class PopularSongHeader extends StatelessWidget {
  final VoidCallback? onShowAll;

  const PopularSongHeader({
    super.key,
    this.onShowAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Popular',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: StitchColors.textPrimary,
                ),
          ),
          TextButton(
            onPressed: onShowAll,
            child: Text(
              'Show all >',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: StitchColors.neutral,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Item bài hát độc lập được bọc RepaintBoundary và tối ưu kích thước giải nén ảnh
class SongTileItem extends StatelessWidget {
  final SongModel song;
  final VoidCallback? onPlay;

  const SongTileItem({
    super.key,
    required this.song,
    this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14.0),
              child: Image.network(
                song.coverUrl,
                width: 64,
                height: 64,
                cacheWidth: 128,
                cacheHeight: 128,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 64,
                    height: 64,
                    color: StitchColors.darkSurfaceVariant,
                    child: const Icon(
                      Icons.music_note_rounded,
                      color: StitchColors.primary,
                      size: 28,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: StitchColors.textPrimary,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.artist,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: StitchColors.textSecondary,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: onPlay,
              icon: const Icon(Icons.play_arrow, color: StitchColors.textPrimary),
              style: IconButton.styleFrom(
                backgroundColor: StitchColors.darkSurface.withValues(alpha: 0.6),
                shape: const CircleBorder(),
                minimumSize: const Size(40, 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget danh sách bài hát truyền thống (được tối ưu recycling & repaint boundaries)
class PopularSongList extends StatelessWidget {
  final List<SongModel> songs;
  final VoidCallback? onShowAll;
  final void Function(SongModel song)? onSongPlay;

  const PopularSongList({
    super.key,
    required this.songs,
    this.onShowAll,
    this.onSongPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PopularSongHeader(onShowAll: onShowAll),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          addRepaintBoundaries: true,
          addAutomaticKeepAlives: false,
          itemCount: songs.length,
          itemBuilder: (context, index) {
            final song = songs[index];
            return SongTileItem(
              song: song,
              onPlay: () => onSongPlay?.call(song),
            );
          },
        ),
      ],
    );
  }
}
