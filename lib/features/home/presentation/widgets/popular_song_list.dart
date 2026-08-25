import 'package:flutter/material.dart';
import 'package:project_test/core/theme/stitch_colors.dart';
import 'package:project_test/features/player/domain/song_model.dart';

class PopularSongList extends StatelessWidget {
  final List<SongModel> songs;
  final VoidCallback? onShowAll;

  const PopularSongList({
    super.key,
    required this.songs,
    this.onShowAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          const SizedBox(height: 16),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: songs.length, // Display all songs in the list
            itemBuilder: (context, index) {
              final song = songs[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildSongItem(context, song),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSongItem(BuildContext context, SongModel song) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14.0),
          child: Image.network(
            song.coverUrl,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
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
              Text(
                song.artist, // Assuming artist as tag/genre for now
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
          onPressed: () {
            // TODO: Implement play song functionality
          },
          icon: const Icon(Icons.play_arrow, color: StitchColors.textPrimary),
          style: IconButton.styleFrom(
            backgroundColor: StitchColors.darkSurface.withOpacity(0.6),
            shape: const CircleBorder(),
            minimumSize: const Size(40, 40),
          ),
        ),
      ],
    );
  }
}
