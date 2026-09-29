import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});
  @override Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 2, right: 2, bottom: 10, top: 6),
    child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: -.2)),
  );
}

class GlassNav extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;
  final String? artwork;
  const GlassNav({super.key, required this.selected, required this.onChanged, this.artwork});
  @override Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xDD151A1E), borderRadius: BorderRadius.circular(28),
              boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 22, offset: Offset(0, 8))],
            ),
            child: Row(children: [
              _item(0, Icons.home_rounded, 'Home'), _item(1, Icons.search_rounded, 'Search'),
              _item(2, Icons.library_music_rounded, 'Library'), _item(3, Icons.settings_rounded, 'Settings'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () => onChanged(4),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 240), width: 40, height: 40,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: selected == 4 ? AppColors.accent : AppColors.surface2),
                    child: ClipOval(child: artwork == null ? const Icon(Icons.music_note_rounded, color: AppColors.muted) : Image.file(File(artwork!), fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.music_note_rounded))),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
  Widget _item(int i, IconData icon, String label) {
    final active = selected == i;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(i),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260), curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 10), padding: const EdgeInsets.symmetric(horizontal: 7),
          decoration: BoxDecoration(color: active ? AppColors.accent : Colors.transparent, borderRadius: BorderRadius.circular(16)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 18, color: active ? AppColors.bg : AppColors.muted),
            if (active) Text(label, style: const TextStyle(color: AppColors.bg, fontSize: 9, fontWeight: FontWeight.w600)),
          ]),
        ),
      ),
    );
  }
}

class MiniPlayer extends StatelessWidget {
  final VoidCallback onTap, onPlay; final String title, artist; final Widget artwork; final bool playing;
  const MiniPlayer({super.key, required this.onTap, required this.title, required this.artist, required this.artwork, required this.playing, required this.onPlay});
  @override Widget build(BuildContext c) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 62, margin: const EdgeInsets.fromLTRB(12, 0, 12, 8), padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(color: const Color(0xF0181E22), borderRadius: BorderRadius.circular(18), boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 16)]),
      child: Row(children: [
        ClipRRect(borderRadius: BorderRadius.circular(12), child: SizedBox(width: 48, height: 48, child: artwork)), const SizedBox(width: 10),
        Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 2), Text(artist, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
        ])),
        IconButton(onPressed: onPlay, icon: Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded), color: AppColors.text),
      ]),
    ),
  );
}

class SongRow extends StatelessWidget {
  final String title, artist; final Duration duration; final Widget artwork; final bool selected; final VoidCallback onTap; final VoidCallback? onMenu;
  const SongRow({super.key, required this.title, required this.artist, required this.duration, required this.artwork, required this.onTap, this.onMenu, this.selected = false});
  @override Widget build(BuildContext c) => Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(14), onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220), margin: const EdgeInsets.symmetric(vertical: 2), padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(color: selected ? const Color(0x263D5965) : Colors.transparent, borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          ClipRRect(borderRadius: BorderRadius.circular(10), child: SizedBox(width: 43, height: 43, child: artwork)), const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500)),
            const SizedBox(height: 3), Text(artist, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
          ])),
          Text(_fmt(duration), style: const TextStyle(color: AppColors.muted, fontSize: 10.5)),
          IconButton(onPressed: onMenu, icon: const Icon(Icons.more_vert_rounded, size: 19), color: AppColors.muted),
        ]),
      ),
    ),
  );
}
String _fmt(Duration d) => '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
