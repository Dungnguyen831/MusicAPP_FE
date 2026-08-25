import 'dart:developer'; // Import for log function
import 'package:flutter/material.dart';
import 'package:project_test/core/theme/stitch_colors.dart'; // Import StitchColors
import 'package:project_test/features/home/presentation/widgets/category_filter_bar.dart';
import 'package:project_test/features/home/presentation/widgets/floating_liquid_nav_bar.dart';
import 'package:project_test/features/home/presentation/widgets/for_you_banner.dart';
import 'package:project_test/features/home/presentation/widgets/home_header.dart';
import 'package:project_test/features/home/presentation/widgets/popular_song_list.dart';
import 'package:project_test/features/player/domain/song_model.dart'; // Import SongModel

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // For FloatingLiquidNavBar
  // Mock Data for PopularSongList
  final List<SongModel> _mockSongs = [
    SongModel(
      id: '1',
      title: 'Aurora',
      artist: 'K/DA, PVRIS',
      audioUrl: 'https://example.com/audio1.mp3',
      coverUrl: 'https://picsum.photos/id/10/200/200',
      durationInSeconds: 240,
    ),
    SongModel(
      id: '2',
      title: 'The Baddest',
      artist: 'K/DA, (G)I-DLE, Bea Miller, Wolftyla',
      audioUrl: 'https://example.com/audio2.mp3',
      coverUrl: 'https://picsum.photos/id/11/200/200',
      durationInSeconds: 180,
    ),
    SongModel(
      id: '3',
      title: 'POP/STARS',
      artist: 'K/DA, Madison Beer, (G)I-DLE, Jaira Burns',
      audioUrl: 'https://example.com/audio3.mp3',
      coverUrl: 'https://picsum.photos/id/12/200/200',
      durationInSeconds: 210,
    ),
    SongModel(
      id: '4',
      title: 'DRUM GO DUM',
      artist: 'K/DA, Aluna, Wolftyla, Bekuh BOOM',
      audioUrl: 'https://example.com/audio4.mp3',
      coverUrl: 'https://picsum.photos/id/13/200/200',
      durationInSeconds: 200,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  StitchColors.primary.withOpacity(0.28),
                  StitchColors.darkBackground,
                ],
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 100.0 + MediaQuery.of(context).padding.bottom), // Padding to avoid overlap with FloatingNavBar and SafeArea
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top), // Top SafeArea
                  const HomeHeader(userName: 'Dũng', avatarUrl: 'https://picsum.photos/id/64/200/200'),
                  const SizedBox(height: 16),
                  CategoryFilterBar(
                    categories: const ["All", "New Artists", "Hot Tracks", "Editor's Picks"],
                    onCategorySelected: (category) {
                      // TODO: Implement category filter logic
                      log('Selected category: $category');
                    },
                  ),
                  const ForYouBanner(),
                  PopularSongList(
                    songs: _mockSongs,
                    onShowAll: () {
                      // TODO: Implement show all popular songs logic
                      log('Show all popular songs');
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FloatingLiquidNavBar(
              selectedIndex: _selectedIndex,
              onItemSelected: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }
}
