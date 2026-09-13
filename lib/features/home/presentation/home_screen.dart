import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/stitch_colors.dart';
import '../../../core/widgets/liquid_glass_card.dart';
import '../../auth/domain/auth_state.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../auth/utils/guest_guard.dart';
import '../../player/domain/song_model.dart';
import '../../playlist/domain/playlist_model.dart';
import '../data/home_repository.dart';
import 'widgets/category_filter_bar.dart';
import 'widgets/floating_liquid_nav_bar.dart';
import 'widgets/for_you_banner.dart';
import 'widgets/home_header.dart';
import 'widgets/personalized_playlist_card.dart';
import 'widgets/popular_song_list.dart';
import 'widgets/recently_played_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  // Mock Data static cho danh sách bài hát phổ biến
  static final List<SongModel> _mockPopularSongs = [
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
    final authState = ref.watch(authControllerProvider);
    final isAuthenticated = authState is Authenticated;
    final currentUser = authState.currentUser;

    final userName = isAuthenticated ? currentUser!.displayName : 'Khách';
    final avatarUrl = isAuthenticated ? currentUser?.photoUrl : null;

    final recentSongs = isAuthenticated
        ? ref.watch(recentlyPlayedProvider(currentUser!.id)).valueOrNull ?? []
        : <SongModel>[];

    final personalizedPlaylists = isAuthenticated
        ? ref.watch(personalizedPlaylistsProvider(currentUser!.id)).valueOrNull ?? []
        : <PlaylistModel>[];

    return Scaffold(
      backgroundColor: StitchColors.darkBackground,
      body: Stack(
        children: [
          // Nền Ambient Glow đỉnh màn hình
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  StitchColors.primary.withValues(alpha: 0.28),
                  StitchColors.darkBackground,
                ],
              ),
            ),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(height: MediaQuery.of(context).padding.top),
                ),

                // 1. Home Header (Tên người dùng & Avatar phân quyền)
                SliverToBoxAdapter(
                  child: HomeHeader(
                    userName: userName,
                    avatarUrl: avatarUrl,
                    onAvatarTap: () {
                      if (!isAuthenticated) {
                        GuestGuard.run(
                          context,
                          ref: ref,
                          action: () {},
                          title: 'Tài khoản Stitch Music',
                          message: 'Đăng nhập để lưu trữ bài hát và playlist cá nhân của bạn.',
                        );
                      }
                    },
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 12),
                ),

                // 2. Category Filter Bar
                SliverToBoxAdapter(
                  child: CategoryFilterBar(
                    categories: const ["All", "New Artists", "Hot Tracks", "Editor's Picks"],
                    onCategorySelected: (category) {
                      log('Selected category: $category', name: 'HomeScreen');
                    },
                  ),
                ),

                // 3. For You Banner
                const SliverToBoxAdapter(
                  child: ForYouBanner(),
                ),

                // 4. Mục Cá nhân hóa (Personalization theo AuthState)
                if (isAuthenticated) ...[
                  // A. Recently Played Section
                  if (recentSongs.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: RecentlyPlayedSection(
                        songs: recentSongs,
                        onSongTap: (song) {
                          log('Phát bài nghe gần đây: ${song.title}', name: 'HomeScreen');
                        },
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 8)),
                  ],

                  // B. Personalized Playlist Section
                  if (personalizedPlaylists.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: PersonalizedPlaylistSection(
                        playlists: personalizedPlaylists,
                        onPlaylistTap: (playlist) {
                          log('Mở playlist cá nhân: ${playlist.name}', name: 'HomeScreen');
                        },
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 8)),
                  ],
                ] else ...[
                  // Thẻ gợi ý mở khóa tính năng cho người dùng Guest
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      child: LiquidGlassCard(
                        borderRadius: 20,
                        padding: const EdgeInsets.all(16.0),
                        borderGradientColors: [
                          StitchColors.primary.withValues(alpha: 0.45),
                          StitchColors.secondary.withValues(alpha: 0.2),
                          Colors.transparent,
                        ],
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: StitchColors.primary.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.lock_outline_rounded,
                                color: StitchColors.primary,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Mở khóa Playlist cá nhân',
                                    style: TextStyle(
                                      color: StitchColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'Đăng nhập để nhận gợi ý theo gu âm nhạc của riêng bạn',
                                    style: TextStyle(
                                      color: StitchColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                GuestGuard.run(
                                  context,
                                  ref: ref,
                                  action: () {},
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: StitchColors.primary,
                                foregroundColor: StitchColors.darkBackground,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                minimumSize: Size.zero,
                              ),
                              child: const Text(
                                'Đăng nhập',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],

                // 5. Popular Songs Header & List
                SliverToBoxAdapter(
                  child: PopularSongHeader(
                    onShowAll: () {
                      log('Show all popular songs', name: 'HomeScreen');
                    },
                  ),
                ),
                SliverList.builder(
                  addRepaintBoundaries: true,
                  addAutomaticKeepAlives: false,
                  itemCount: _mockPopularSongs.length,
                  itemBuilder: (context, index) {
                    final song = _mockPopularSongs[index];
                    return SongTileItem(
                      song: song,
                      onPlay: () {
                        log('Play song: ${song.title}', name: 'HomeScreen');
                      },
                    );
                  },
                ),

                // Padding an toàn dưới thanh Nav Bar
                SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: 100.0 + MediaQuery.of(context).padding.bottom,
                  ),
                ),
              ],
            ),
          ),

          // Thanh điều hướng nổi (Floating Liquid Nav Bar)
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
