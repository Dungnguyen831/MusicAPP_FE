import 'package:hive/hive.dart';
import '../../player/domain/song_model.dart';

part 'playlist_model.g.dart';

@HiveType(typeId: 2)
class PlaylistModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String? coverUrl;

  @HiveField(4)
  final List<SongModel> songs;

  @HiveField(5)
  final String? creatorId;

  @HiveField(6)
  final bool isPublic;

  PlaylistModel({
    required this.id,
    required this.name,
    this.description,
    this.coverUrl,
    required this.songs,
    this.creatorId,
    this.isPublic = true,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      coverUrl: json['coverUrl'] as String?,
      songs: (json['songs'] as List<dynamic>?)
              ?.map((e) => SongModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      creatorId: json['creatorId'] as String?,
      isPublic: json['isPublic'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'coverUrl': coverUrl,
      'songs': songs.map((e) => e.toJson()).toList(),
      'creatorId': creatorId,
      'isPublic': isPublic,
    };
  }
}
