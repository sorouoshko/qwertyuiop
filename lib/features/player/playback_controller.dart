import 'dart:async';
import 'dart:math';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/models/music_models.dart';
import '../../data/repositories/music_repository.dart';

class PlaybackController extends ChangeNotifier {
  final AudioPlayer player = AudioPlayer();
  final MusicRepository repository;
  final List<Song> queue = [];
  StreamSubscription? _currentSub;
  StreamSubscription? _stateSub;
  Song? current;
  bool shuffle = false;
  LoopMode repeat = LoopMode.off;
  bool queueOpen = false;
  Duration position = Duration.zero;
  PlaybackController(this.repository) {
    _currentSub = player.currentIndexStream.listen((i) {
      if (i != null && i >= 0 && i < queue.length) current = queue[i];
      notifyListeners();
    });
    _stateSub = player.playerStateStream.listen((_) => notifyListeners());
    player.positionStream.listen((p) { position = p; notifyListeners(); });
  }

  bool get playing => player.playing;
  Duration get duration => player.duration ?? current?.duration ?? Duration.zero;

  Future<void> setQueue(List<Song> songs, {int start = 0}) async {
    queue..clear()..addAll(songs);
    final sources = songs.map((s) => AudioSource.uri(Uri.file(s.audioPath), tag: MediaItem(id: s.id, title: s.title, artist: s.artistName, album: s.albumName, duration: s.duration))).toList();
    await player.setAudioSources(sources, initialIndex: min(start, max(0, sources.length - 1)));
    current = songs.isEmpty ? null : songs[start.clamp(0, songs.length - 1)];
    notifyListeners();
  }

  Future<void> playSong(Song song, List<Song> songs) async {
    final i = songs.indexWhere((x) => x.id == song.id);
    await setQueue(songs, start: i < 0 ? 0 : i);
    await player.play();
  }
  Future<void> toggle() async => playing ? player.pause() : player.play();
  Future<void> next() => player.seekToNext();
  Future<void> previous() => player.seekToPrevious();
  Future<void> seek(Duration p) => player.seek(p);
  void toggleShuffle() { shuffle = !shuffle; player.setShuffleModeEnabled(shuffle); notifyListeners(); }
  void cycleRepeat() { repeat = repeat == LoopMode.off ? LoopMode.all : repeat == LoopMode.all ? LoopMode.one : LoopMode.off; player.setLoopMode(repeat); notifyListeners(); }
  void toggleQueue() { queueOpen = !queueOpen; notifyListeners(); }
  @override void dispose() { _currentSub?.cancel(); _stateSub?.cancel(); player.dispose(); super.dispose(); }
}
