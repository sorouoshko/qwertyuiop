import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/artwork.dart';
import '../../data/models/music_models.dart';
import '../../data/repositories/music_repository.dart';
import '../player/playback_controller.dart';

class LikedScreen extends StatefulWidget { const LikedScreen({super.key}); @override State<LikedScreen> createState() => _LikedScreenState(); }
class _LikedScreenState extends State<LikedScreen> {
  List<Song> songs = []; bool loading = true;
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async { final s = await context.read<MusicRepository>().scanLocalSongs(); if (mounted) setState(() { songs = s; loading = false; }); }
  @override Widget build(BuildContext c) {
    final p = c.watch<PlaybackController>();
    return SafeArea(child: CustomScrollView(slivers: [
      SliverToBoxAdapter(child: Row(children: [IconButton(onPressed: () => Navigator.pop(c), icon: const Icon(Icons.arrow_back_rounded)), const Text('Liked songs', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700)), const Spacer(), TextButton(onPressed: songs.isEmpty ? null : () => p.setQueue(songs), child: const Text('Shuffle', style: TextStyle(color: AppColors.accent)))])),
      const SliverToBoxAdapter(child: SizedBox(height: 1)),
      if (loading) SliverList.builder(itemCount: 8, itemBuilder: (_, __) => const Padding(padding: EdgeInsets.symmetric(vertical: 5), child: SkeletonRow()))
      else SliverList.builder(itemCount: songs.length, itemBuilder: (_, i) { final s = songs[i]; return SongRow(title: s.title, artist: s.artistName, duration: s.duration, selected: p.current?.id == s.id, artwork: const ColoredBox(color: AppColors.surface2, child: Icon(Icons.music_note_rounded, color: AppColors.muted)), onTap: () => p.playSong(s, songs), onMenu: () {}); }),
    ]));
  }
}
