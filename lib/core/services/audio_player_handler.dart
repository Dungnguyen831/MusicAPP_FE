import 'dart:developer';

import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ryanheise.audio_service_example.channel',
      androidNotificationChannelName: 'Audio Service Demo',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

class AudioPlayerHandler extends BaseAudioHandler {
  final _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  AudioPlayerHandler() {
    _loadEmptyPlaylist();
    _listenForDurationChanges();
    _listenForPlayerStateChanges();
  }

  Future<void> _loadEmptyPlaylist() async {
    try {
      await _player.setAudioSource(_playlist);
    } catch (e) {
      log("Error: $e");
    }
  }

  void _listenForDurationChanges() {
    _durationSubscription = _player.durationStream.listen((duration) {
      if (duration != null) {
        mediaItem.add(mediaItem.value?.copyWith(duration: duration));
      }
    });
  }

  void _listenForPlayerStateChanges() {
    _playerStateSubscription = _player.playerStateStream.listen((playerState) {
      final playing = playerState.playing;
      final processingState = playerState.processingState;
      playbackState.add(playbackState.value.copyWith(
        playing: playing,
        processingState: _mapProcessingState(processingState),
      ));
    });
  }

  AudioProcessingState _mapProcessingState(ProcessingState processingState) {
    switch (processingState) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  @override
  Future<void> stop() async {
    await _player.stop();
    await _durationSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    _durationSubscription = null;
    _playerStateSubscription = null;
    return super.stop();
  }

  Future<void> _dispose() async {
    await _durationSubscription?.cancel();
    _durationSubscription = null;
    await _playerStateSubscription?.cancel();
    _playerStateSubscription = null;
    await _player.dispose();
  }

  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'dispose') {
      await _dispose();
      await super.customAction(name, extras);
    } else {
      await super.customAction(name, extras);
    }
  }

  @override

  Future<void> onTaskRemoved() async {
    await _player.stop();
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    await _player.seek(Duration.zero, index: index);
  }
}
