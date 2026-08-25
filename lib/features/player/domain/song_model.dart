import 'package:hive/hive.dart';

part 'song_model.g.dart';

@HiveType(typeId: 1)
class SongModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String artist;

  @HiveField(3)
  final String audioUrl;

  @HiveField(4)
  final String coverUrl;

  @HiveField(5)
  final String? lyricsUrl;

  @HiveField(6)
  final int durationInSeconds;

  @HiveField(7)
  final bool isOffline;

  @HiveField(8)
  final String? localPath;

  SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.audioUrl,
    required this.coverUrl,
    this.lyricsUrl,
    required this.durationInSeconds,
    this.isOffline = false,
    this.localPath,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      audioUrl: json['audioUrl'] as String,
      coverUrl: json['coverUrl'] as String,
      lyricsUrl: json['lyricsUrl'] as String?,
      durationInSeconds: json['durationInSeconds'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'audioUrl': audioUrl,
      'coverUrl': coverUrl,
      'lyricsUrl': lyricsUrl,
      'durationInSeconds': durationInSeconds,
    };
  }

  Duration get duration => Duration(seconds: durationInSeconds);
}
