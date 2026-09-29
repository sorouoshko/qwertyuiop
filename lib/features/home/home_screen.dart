import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override Widget build(BuildContext context) => SafeArea(
    child: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: Row(children: [const Expanded(child: Text('Home', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, letterSpacing: -.8))), IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded)), IconButton(onPressed: () {}, icon: const Icon(Icons.history_rounded))])),
        SliverToBoxAdapter(child: _hero()),
        SliverToBoxAdapter(child: _carousel('NEW RELEASES', ['ELZA2', "Pop's Biggest Hits", 'Punjabi Now'], ['ELZA2', "Pop's Biggest Hits", 'Punjabi Hits'])),
        SliverToBoxAdapter(child: _carousel('THROWBACKS', ["Classic Rock's Greatest", 'The Hits: 80s', 'Throwback Pop'], ['Throwback', '80s', 'Old School'])),
        SliverToBoxAdapter(child: const SectionTitle('Quick picks')),
        SliverToBoxAdapter(child: _quickPicks()),
        SliverToBoxAdapter(child: const SectionTitle('All-time essentials')),
        SliverToBoxAdapter(child: _carousel('', ["Pop's Biggest Hits", 'Essential Energy', 'Best of Ado'], ['Pop', 'Arijit Singh', 'Ado'])),
        SliverToBoxAdapter(child: const SectionTitle('Low key vibes')),
        SliverToBoxAdapter(child: _smallPills()),
      ],
    ),
  );

  Widget _hero() => Container(
    height: 205, margin: const EdgeInsets.only(top: 12, bottom: 16), clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: AppColors.surface2),
    child: Stack(fit: StackFit.expand, children: [
      const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x662E8BB2), Color(0xFF101417)]))),
      Padding(padding: const EdgeInsets.all(16), child: Align(alignment: Alignment.bottomLeft, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('FOR YOU', style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.4)), const SizedBox(height: 6),
        const Text('Without You', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)), const Text('NEFFEX', style: TextStyle(color: AppColors.muted, fontSize: 12)), const SizedBox(height: 12),
        Container(width: 96, height: 34, decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(18)), child: const Center(child: Text('Play', style: TextStyle(color: AppColors.bg, fontWeight: FontWeight.w700)))),
      ]))),
    ]),
  );

  Widget _carousel(String title, List<String> names, List<String> subs) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (title.isNotEmpty) SectionTitle(title),
      SizedBox(height: title.isEmpty ? 4 : 0, child: SingleChildScrollView(scrollDirection: Axis.horizontal, physics: const BouncingScrollPhysics(), child: Row(children: [
        for (var i = 0; i < names.length; i++) Container(width: 150, margin: EdgeInsets.only(right: i == names.length - 1 ? 0 : 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Hero(tag: 'art-${names[i]}', child: Container(height: 150, decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(20)), child: const Center(child: Icon(Icons.album_rounded, color: AppColors.muted, size: 42)))),
          const SizedBox(height: 7), Text(names[i], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)), Text(subs[i], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 10.5)),
        ])),
      ]))),
    ]),
  );

  Widget _quickPicks() {
    final items = ['Babylon', 'Amor De Antes', 'Last Thing You Need (from GTA)', 'Soy Un Joven'];
    return Column(children: [for (var i = 0; i < items.length; i++) Container(
      margin: const EdgeInsets.only(bottom: 5), padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
      child: Row(children: [Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFF20282D), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.music_note_rounded, color: AppColors.muted)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(items[i], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500)), Text(i.isEven ? 'Taylor Swift' : 'Grupo Frime', style: const TextStyle(color: AppColors.muted, fontSize: 10.5))])), const Icon(Icons.more_vert_rounded, color: AppColors.muted, size: 18)]),
    )]);
  }

  Widget _smallPills() => SizedBox(
    height: 105,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(width: 10),
      itemBuilder: (_, i) => Container(
        width: 140,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
          Icon([Icons.nightlight_round, Icons.water_drop_outlined, Icons.headphones_rounded, Icons.cloud_outlined][i], color: AppColors.accent, size: 19),
          const SizedBox(height: 8),
          Text(['Midnight', 'Rainy room', 'Headphones', 'Cloudy day'][i], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        ]),
      ),
    ),
  );
}
