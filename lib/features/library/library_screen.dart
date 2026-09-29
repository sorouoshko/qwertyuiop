import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common.dart';
import '../artists/artists_screen.dart';
import '../liked/liked_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});
  @override Widget build(BuildContext c) => SafeArea(child: CustomScrollView(slivers: [
    const SliverToBoxAdapter(child: Text('Your Library', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700))),
    SliverToBoxAdapter(child: GestureDetector(onTap: () => Navigator.push(c, _slide(const LikedScreen())), child: Container(height: 92, margin: const EdgeInsets.only(top: 15, bottom: 10), padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(20)), child: Row(children: [
      const Icon(Icons.favorite_rounded, color: AppColors.bg, size: 25), const SizedBox(width: 12), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text('Liked songs', style: TextStyle(color: AppColors.bg, fontSize: 16, fontWeight: FontWeight.w700)), Text('27 songs', style: TextStyle(color: Color(0xAA0B0F12), fontSize: 10))])),
      Container(width: 48, height: 48, decoration: const BoxDecoration(color: Color(0x99FFFFFF), shape: BoxShape.circle), child: const Icon(Icons.play_arrow_rounded, color: AppColors.bg, size: 29)),
    ])))),
    SliverToBoxAdapter(child: GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 1.65, children: [
      _card('Albums', '2 albums', Icons.album_rounded), _card('Playlists', '2 playlists', Icons.queue_music_rounded), _card('Artists', '9 artists', Icons.person_rounded, onTap: () => Navigator.push(c, _slide(const ArtistsScreen()))), _card('History', 'Recently played', Icons.history_rounded),
    ])),
    const SliverToBoxAdapter(child: SizedBox(height: 17)),
    const SliverToBoxAdapter(child: SectionTitle('Recently saved')),
    SliverToBoxAdapter(child: SizedBox(height: 170, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: 3, separatorBuilder: (_, __) => const SizedBox(width: 12), itemBuilder: (_, i) => SizedBox(width: 145, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(height: 140, decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(20)), child: const Center(child: Icon(Icons.album_rounded, color: AppColors.muted, size: 42))), const SizedBox(height: 7), Text(['NEFFEX', 'Ado', 'ELZA2'][i], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)), const Text('Saved', style: TextStyle(color: AppColors.muted, fontSize: 10)),
    ]))))),
  ]));

  Widget _card(String t, String s, IconData i, {VoidCallback? onTap}) => GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [Icon(i, color: AppColors.accent, size: 18), const SizedBox(height: 9), Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)), Text(s, style: const TextStyle(color: AppColors.muted, fontSize: 10))])));
}
Route _slide(Widget child) => PageRouteBuilder(pageBuilder: (_, a, b) => child, transitionDuration: const Duration(milliseconds: 300), reverseTransitionDuration: const Duration(milliseconds: 280), transitionsBuilder: (_, a, b, child) => SlideTransition(position: Tween(begin: const Offset(1, 0), end: Offset.zero).chain(CurveTween(curve: Curves.easeOutCubic)).animate(a), child: child));
