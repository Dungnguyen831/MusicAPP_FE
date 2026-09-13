import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_test/features/auth/data/auth_repository.dart';
import 'package:project_test/features/auth/domain/user_model.dart';
import 'package:project_test/features/auth/widgets/guest_bottom_sheet.dart';
import 'package:project_test/features/home/data/home_repository.dart';
import 'package:project_test/features/home/presentation/home_screen.dart';
import 'package:project_test/features/home/presentation/widgets/personalized_playlist_card.dart';
import 'package:project_test/features/home/presentation/widgets/recently_played_list.dart';
import 'package:project_test/features/player/domain/song_model.dart';
import 'package:project_test/features/playlist/domain/playlist_model.dart';

class _SyncAuthRepository implements AuthRepository {
  final UserModel? user;
  final bool isGuestMode;

  _SyncAuthRepository({this.user, this.isGuestMode = false});

  @override
  Future<UserModel?> getCurrentUser() async => user;

  @override
  Future<bool> isGuest() async => isGuestMode;

  @override
  Future<void> setGuestMode(bool isGuest) async {}

  @override
  Future<UserModel> login({required String email, required String password}) async => user!;

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String displayName,
  }) async =>
      user!;

  @override
  Future<void> logout() async {}
}

void main() {
  group('HomeScreen Personalization Tests', () {
    final testUser = UserModel(
      id: 'user_001',
      email: 'dung@stitchmusic.com',
      displayName: 'Dũng',
    );

    final mockSongs = [
      SongModel(
        id: 'recent_1',
        title: 'Star Walkin\'',
        artist: 'Lil Nas X',
        audioUrl: 'https://example.com/audio1.mp3',
        coverUrl: 'https://picsum.photos/id/20/200/200',
        durationInSeconds: 210,
      ),
    ];

    final mockPlaylists = [
      PlaylistModel(
        id: 'pl_1',
        name: 'Daily Mix 1',
        description: 'Tuyển tập phong cách cá nhân',
        songs: mockSongs,
      ),
    ];

    testWidgets('Displays Personalized Playlists and Recently Played for Authenticated user',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(
              _SyncAuthRepository(user: testUser),
            ),
            recentlyPlayedProvider('user_001').overrideWith(
              (ref) async => mockSongs,
            ),
            personalizedPlaylistsProvider('user_001').overrideWith(
              (ref) async => mockPlaylists,
            ),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Process microtasks and async state
      await tester.pump();
      await tester.pump();

      // Check header greeting
      expect(find.text('Xin chào, Dũng'), findsOneWidget);

      // Check personalized sections
      expect(find.byType(RecentlyPlayedSection), findsOneWidget);
      expect(find.text('Nghe gần đây'), findsOneWidget);

      expect(find.byType(PersonalizedPlaylistSection), findsOneWidget);
      expect(find.text('Dành riêng cho bạn'), findsOneWidget);

      // Guest prompt card should NOT exist
      expect(find.text('Mở khóa Playlist cá nhân'), findsNothing);
    });

    testWidgets('Displays Guest greeting and Unlock CTA for Guest user', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(
              _SyncAuthRepository(isGuestMode: true),
            ),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      // Check header greeting for guest
      expect(find.text('Xin chào, Khách'), findsOneWidget);

      // Personalized sections should NOT be shown
      expect(find.byType(RecentlyPlayedSection), findsNothing);
      expect(find.byType(PersonalizedPlaylistSection), findsNothing);

      // Guest unlock prompt card should be shown
      expect(find.text('Mở khóa Playlist cá nhân'), findsOneWidget);

      // Tapping "Đăng nhập" button triggers GuestBottomSheet
      await tester.tap(find.text('Đăng nhập'));
      await tester.pump();
      await tester.pump();

      expect(find.byType(GuestBottomSheet), findsOneWidget);
    });
  });
}
