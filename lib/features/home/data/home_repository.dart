import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../player/domain/song_model.dart';
import '../../playlist/domain/playlist_model.dart';

/// Interface định nghĩa tương tác dữ liệu cho màn hình Trang chủ
abstract interface class HomeRepository {
  /// Lấy danh sách Playlist cá nhân hóa theo UserId
  Future<List<PlaylistModel>> getPersonalizedPlaylists(String userId);

  /// Lấy danh sách các bài hát đã nghe gần đây
  Future<List<SongModel>> getRecentlyPlayed(String userId);
}

/// Mock Repository cung cấp dữ liệu thử nghiệm cá nhân hóa
class MockHomeRepository implements HomeRepository {
  static final List<SongModel> _mockRecentlyPlayedSongs = [
    SongModel(
      id: 'recent_1',
      title: 'Star Walkin\'',
      artist: 'Lil Nas X',
      audioUrl: 'https://example.com/audio_starwalkin.mp3',
      coverUrl: 'https://picsum.photos/id/20/200/200',
      durationInSeconds: 210,
    ),
    SongModel(
      id: 'recent_2',
      title: 'Enemy',
      artist: 'Imagine Dragons, JID',
      audioUrl: 'https://example.com/audio_enemy.mp3',
      coverUrl: 'https://picsum.photos/id/21/200/200',
      durationInSeconds: 173,
    ),
    SongModel(
      id: 'recent_3',
      title: 'Heavy Is The Crown',
      artist: 'Linkin Park',
      audioUrl: 'https://example.com/audio_heavy.mp3',
      coverUrl: 'https://picsum.photos/id/22/200/200',
      durationInSeconds: 167,
    ),
    SongModel(
      id: 'recent_4',
      title: 'Legends Never Die',
      artist: 'Against The Current',
      audioUrl: 'https://example.com/audio_legends.mp3',
      coverUrl: 'https://picsum.photos/id/23/200/200',
      durationInSeconds: 235,
    ),
  ];

  static final List<PlaylistModel> _mockPersonalizedPlaylists = [
    PlaylistModel(
      id: 'pl_pers_1',
      name: 'Daily Mix 1',
      description: 'Dành riêng cho tâm trạng hôm nay của bạn',
      coverUrl: 'https://picsum.photos/id/30/300/300',
      creatorId: 'system',
      songs: _mockRecentlyPlayedSongs,
    ),
    PlaylistModel(
      id: 'pl_pers_2',
      name: 'Stitch Chill Beats',
      description: 'Giai điệu thư giãn để làm việc và học tập',
      coverUrl: 'https://picsum.photos/id/31/300/300',
      creatorId: 'system',
      songs: _mockRecentlyPlayedSongs,
    ),
    PlaylistModel(
      id: 'pl_pers_3',
      name: 'Gaming Energy 2026',
      description: 'Nhịp điệu sôi động bùng nổ năng lượng',
      coverUrl: 'https://picsum.photos/id/32/300/300',
      creatorId: 'system',
      songs: _mockRecentlyPlayedSongs,
    ),
  ];

  @override
  Future<List<PlaylistModel>> getPersonalizedPlaylists(String userId) async {
    log('Lấy Playlist cá nhân hóa cho user: $userId', name: 'HomeRepository');
    await Future.delayed(const Duration(milliseconds: 150));
    return _mockPersonalizedPlaylists;
  }

  @override
  Future<List<SongModel>> getRecentlyPlayed(String userId) async {
    log('Lấy lịch sử nghe gần đây cho user: $userId', name: 'HomeRepository');
    await Future.delayed(const Duration(milliseconds: 150));
    return _mockRecentlyPlayedSongs;
  }
}

/// Provider cung cấp HomeRepository
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return MockHomeRepository();
});

/// Provider lấy danh sách Playlist cá nhân hóa cho userId
final personalizedPlaylistsProvider =
    FutureProvider.family<List<PlaylistModel>, String>((ref, userId) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getPersonalizedPlaylists(userId);
});

/// Provider lấy danh sách bài hát nghe gần đây cho userId
final recentlyPlayedProvider =
    FutureProvider.family<List<SongModel>, String>((ref, userId) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getRecentlyPlayed(userId);
});
