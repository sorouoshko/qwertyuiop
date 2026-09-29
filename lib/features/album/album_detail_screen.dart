import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common.dart';

class AlbumDetailScreen extends StatelessWidget {
  final String title, artist;
  const AlbumDetailScreen({super.key, this.title = 'ELZA2', this.artist = 'Elza Kanzaki'});
  @override Widget build(BuildContext c) {
    final titles = ['Oh UnHappy Day','Girls Don’t Cry','Toxic','Kakumei','Immortal','One Shot','Are You Ok?','The King Is Dead'];
    return Scaffold(backgroundColor: AppColors.bg, body: CustomScrollView(slivers: [
      SliverAppBar(pinned: true, backgroundColor: Colors.transparent, leading: IconButton(onPressed: () => Navigator.pop(c), icon: const Icon(Icons.arrow_back_rounded)), actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.share_rounded))], expandedHeight: 390, flexibleSpace: FlexibleSpaceBar(background: _header())),
      SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(14, 10, 14, 7), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('2024 · 8 songs · 32 min · High', style: TextStyle(color: AppColors.muted, fontSize: 10.5)), const SizedBox(height: 12), Row(children: [_action(Icons.shuffle_rounded, 'Shuffle'), const SizedBox(width: 8), _action(Icons.play_arrow_rounded, 'Play', accent: true), const SizedBox(width: 8), Container(width: 42, height: 42, decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(21)), child: const Icon(Icons.add_rounded, color: AppColors.muted))])]))),
      SliverList(delegate: SliverChildListDelegate([for (var i = 0; i < titles.length; i++) Padding(padding: const EdgeInsets.symmetric(horizontal: 14), child: SongRow(title: titles[i], artist: artist, duration: Duration(minutes: 2, seconds: 30 + i * 8), artwork: const ColoredBox(color: AppColors.surface2, child: Icon(Icons.music_note_rounded, color: AppColors.muted)), onTap: () {}, onMenu: () {}))])),
    ]));
  }
  Widget _header() => Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF343C42), AppColors.bg], stops: [0, .88])), child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [Hero(tag: 'album-$title', child: Container(width: 230, height: 230, decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(25)), child: const Icon(Icons.album_rounded, color: AppColors.muted, size: 72))), const SizedBox(height: 14), Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)), Text(artist, style: const TextStyle(color: AppColors.muted, fontSize: 12)), const SizedBox(height: 10)]));
  Widget _action(IconData icon, String text, {bool accent = false}) => Container(height: 42, padding: const EdgeInsets.symmetric(horizontal: 17), decoration: BoxDecoration(color: accent ? AppColors.accent : AppColors.surface2, borderRadius: BorderRadius.circular(21)), child: Row(children: [Icon(icon, size: 17, color: accent ? AppColors.bg : AppColors.text), const SizedBox(width: 7), Text(text, style: TextStyle(color: accent ? AppColors.bg : AppColors.text, fontSize: 11.5, fontWeight: FontWeight.w600))]));
}
