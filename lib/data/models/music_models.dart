class Song {
  final String id;
  final String title;
  final String artistId;
  final String artistName;
  final String albumId;
  final String albumName;
  final String? artworkPath;
  final String audioPath;
  final Duration duration;
  final int? year;
  final String? quality;
  final bool isLiked;

  const Song({required this.id, required this.title, required this.artistId, required this.artistName, required this.albumId, required this.albumName, this.artworkPath, required this.audioPath, required this.duration, this.year, this.quality, this.isLiked = false});

  Song copyWith({bool? isLiked}) => Song(id: id, title: title, artistId: artistId, artistName: artistName, albumId: albumId, albumName: albumName, artworkPath: artworkPath, audioPath: audioPath, duration: duration, year: year, quality: quality, isLiked: isLiked ?? this.isLiked);
}

class Artist {
  final String id;
  final String name;
  final String? artworkPath;
  final int monthlyListeners;
  const Artist({required this.id, required this.name, this.artworkPath, this.monthlyListeners = 0});
}

class Album {
  final String id;
  final String title;
  final String artistName;
  final String? artworkPath;
  final int year;
  final int songCount;
  final Duration duration;
  final String quality;
  const Album({required this.id, required this.title, required this.artistName, this.artworkPath, required this.year, required this.songCount, required this.duration, required this.quality});
}

class QueueItem {
  final Song song;
  const QueueItem(this.song);
}
