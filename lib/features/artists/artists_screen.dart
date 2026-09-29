import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common.dart';

class ArtistsScreen extends StatelessWidget {
  const ArtistsScreen({super.key});
  @override Widget build(BuildContext c) {
    const names = ['Ado','NEFFEX','Taylor Swift','Arijit Singh','ELZA2','Grupo Frime','Eminem','Sia','Ariana Grande'];
    return SafeArea(child: CustomScrollView(slivers: [
      SliverToBoxAdapter(child: Row(children: [IconButton(onPressed: () => Navigator.pop(c), icon: const Icon(Icons.arrow_back_rounded)), const Text('Artists', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700))])),
      SliverGrid.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 14, mainAxisSpacing: 18, childAspectRatio: .78), itemCount: names.length, itemBuilder: (_, i) {
        return GestureDetector(onTap: () => Navigator.push(c, _slide(ArtistDetailScreen(name: names[i]))), child: Column(children: [Hero(tag: 'artist-${names[i]}', child: Container(width: 92, height: 92, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.surface2), child: const Icon(Icons.person_rounded, color: AppColors.muted, size: 38))), const SizedBox(height: 8), Text(names[i], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600))]));
      }),
    ]));
  }
}

class ArtistDetailScreen extends StatelessWidget {
  final String name;
  const ArtistDetailScreen({super.key, required this.name});
  @override Widget build(BuildContext c) {
    final songs = List.generate(7, (i) => SongRow(title: i == 0 ? 'Without You' : 'Free Me', artist: name, duration: Duration(minutes: 2, seconds: 28 + i * 7), artwork: const ColoredBox(color: AppColors.surface2, child: Icon(Icons.music_note_rounded, color: AppColors.muted)), onTap: () {}, onMenu: () {}));
    return Scaffold(backgroundColor: AppColors.bg, body: CustomScrollView(slivers: [
      SliverAppBar(pinned: true, expandedHeight: 340, backgroundColor: AppColors.bg, leading: IconButton(onPressed: () => Navigator.pop(c), icon: const Icon(Icons.arrow_back_rounded)), actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.share_rounded))], flexibleSpace: FlexibleSpaceBar(background: _artistHeader())),
      SliverToBoxAdapter(child: _artistActions()),
      const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.only(left: 14, top: 10), child: Text('TOP SONGS', style: TextStyle(color: AppColors.muted, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2)))),
      SliverList(delegate: SliverChildListDelegate([for (final row in songs) Padding(padding: const EdgeInsets.symmetric(horizontal: 14), child: row)])),
      const SliverToBoxAdapter(child: SectionTitle('ALBUMS')),
      SliverToBoxAdapter(child: SizedBox(height: 150, child: ListView.separated(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 14), itemCount: 4, separatorBuilder: (_, __) => const SizedBox(width: 10), itemBuilder: (_, __) => Container(width: 125, decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.album_rounded, color: AppColors.muted, size: 36))))),
    ]));
  }
  Widget _artistHeader() => Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF29343A), AppColors.bg], stops: [0, .9])), child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [Hero(tag: 'artist-$name', child: Container(width: 148, height: 148, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.surface2), child: const Icon(Icons.person_rounded, color: AppColors.muted, size: 60))), const SizedBox(height: 14), Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)), const SizedBox(height: 5), const Text('1.2M monthly listeners', style: TextStyle(color: AppColors.muted, fontSize: 11)), const SizedBox(height: 16)]));
  Widget _artistActions() => Padding(padding: const EdgeInsets.fromLTRB(14, 14, 14, 5), child: Row(children: [Container(height: 38, padding: const EdgeInsets.symmetric(horizontal: 18), decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(20)), child: const Row(children: [Icon(Icons.shuffle_rounded, size: 17), SizedBox(width: 8), Text('Shuffle', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))])), const Spacer(), Container(width: 42, height: 42, decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle), child: const Icon(Icons.play_arrow_rounded, color: AppColors.bg))]));
}
Route _slide(Widget child) => PageRouteBuilder(pageBuilder: (_, a, b) => child, transitionDuration: const Duration(milliseconds: 320), reverseTransitionDuration: const Duration(milliseconds: 280), transitionsBuilder: (_, a, b, child) => SlideTransition(position: Tween(begin: const Offset(1, 0), end: Offset.zero).chain(CurveTween(curve: Curves.easeOutCubic)).animate(a), child: child));
