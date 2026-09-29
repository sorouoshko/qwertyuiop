import 'dart:typed_data';
import 'package:on_audio_query/on_audio_query.dart';
import '../models/music_models.dart';

class MusicRepository {
  final OnAudioQuery _query = OnAudioQuery();
  final Map<String, Uint8List> artworkCache = {};

  Future<bool> requestPermission() async {
    var granted = await _query.permissionsStatus();
    if (!granted) granted = await _query.permissionsRequest();
    return granted;
  }

  Future<List<Song>> scanLocalSongs() async {
    if (!await requestPermission()) return [];
    final rows = await _query.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    return rows.map((s) => Song(
      id: '${s.id}',
      title: s.title,
      artistId: '${s.artistId ?? s.artist ?? 'unknown'}',
      artistName: s.artist ?? 'Unknown artist',
      albumId: '${s.albumId ?? s.album ?? 'unknown'}',
      albumName: s.album ?? 'Unknown album',
      audioPath: s.data,
      duration: Duration(milliseconds: s.duration ?? 0),
      year: null,
      quality: s.fileExtension?.toUpperCase(),
    )).toList();
  }

  Future<Uint8List?> artwork(int id, {ArtworkType type = ArtworkType.AUDIO}) async {
    final key = '$type:$id';
    if (artworkCache.containsKey(key)) return artworkCache[key];
    final bytes = await _query.queryArtwork(id, type);
    if (bytes != null) artworkCache[key] = bytes;
    return bytes;
  }
}
