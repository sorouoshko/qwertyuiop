import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import 'playback_controller.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});
  @override State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}
class _NowPlayingScreenState extends State<NowPlayingScreen> with SingleTickerProviderStateMixin {
  late final AnimationController wave;
  @override void initState() { super.initState(); wave = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300))..repeat(); }
  @override void dispose() { wave.dispose(); super.dispose(); }

  @override Widget build(BuildContext c) {
    final p = c.watch<PlaybackController>();
    final song = p.current;
    final maxMs = p.duration.inMilliseconds <= 0 ? 1 : p.duration.inMilliseconds;
    final currentMs = p.position.inMilliseconds.clamp(0, maxMs).toDouble();
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(fit: StackFit.expand, children: [
        const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF34444C), Color(0xE60B0F12), AppColors.bg], stops: [0, .48, 1]))),
        BackdropFilter(filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24), child: Container(color: const Color(0xAA0B0F12))),
        SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 18), child: Column(children: [
          Row(children: [IconButton(onPressed: () => Navigator.pop(c), icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 28)), const Spacer(), _topButton(Icons.shuffle_rounded, p.shuffle, p.toggleShuffle), const SizedBox(width: 7), _topButton(Icons.repeat_rounded, p.repeat != LoopMode.off, p.cycleRepeat), const SizedBox(width: 7), _topButton(Icons.queue_music_rounded, p.queueOpen, p.toggleQueue), const SizedBox(width: 4), IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border_rounded))]),
          const Spacer(),
          AnimatedContainer(duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic, width: MediaQuery.sizeOf(c).width * .84, height: MediaQuery.sizeOf(c).width * .84, decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(28), boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 40, spreadRadius: 4)]), child: const Center(child: Icon(Icons.album_rounded, size: 90, color: AppColors.muted))),
          const SizedBox(height: 24),
          Align(alignment: Alignment.centerLeft, child: Text(song?.title ?? 'Without You', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700))),
          Align(alignment: Alignment.centerLeft, child: Text(song?.artistName ?? 'NEFFEX', style: const TextStyle(color: AppColors.muted, fontSize: 13))),
          const SizedBox(height: 18),
          AnimatedBuilder(animation: wave, builder: (_, __) => CustomPaint(size: const Size(double.infinity, 42), painter: WavePainter(progress: currentMs / maxMs))),
          SliderTheme(data: SliderTheme.of(c).copyWith(activeTrackColor: AppColors.text, inactiveTrackColor: Colors.white24, thumbColor: AppColors.text, trackHeight: 2, overlayShape: SliderComponentShape.noOverlay), child: Slider(value: currentMs, min: 0, max: maxMs.toDouble(), onChanged: (v) => p.seek(Duration(milliseconds: v.toInt())))),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(_fmt(p.position), style: const TextStyle(color: AppColors.muted, fontSize: 10)), Text('-${_fmt(p.duration - p.position)}', style: const TextStyle(color: AppColors.muted, fontSize: 10))]),
          const SizedBox(height: 13),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [IconButton(onPressed: p.previous, icon: const Icon(Icons.skip_previous_rounded), iconSize: 30), const SizedBox(width: 18), GestureDetector(onTap: p.toggle, child: AnimatedScale(scale: p.playing ? 1 : .96, duration: const Duration(milliseconds: 160), child: Container(width: 68, height: 46, decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(23)), child: Icon(p.playing ? Icons.pause_rounded : Icons.play_arrow_rounded, color: AppColors.bg, size: 27)))), const SizedBox(width: 18), IconButton(onPressed: p.next, icon: const Icon(Icons.skip_next_rounded), iconSize: 30)]),
          if (p.queueOpen) _queue(p),
          const SizedBox(height: 4),
        ]))),
      ],
    ));
  }

  Widget _topButton(IconData icon, bool active, VoidCallback onTap) => GestureDetector(onTap: onTap, child: Container(width: 37, height: 30, decoration: BoxDecoration(color: active ? AppColors.accent : const Color(0x66151A1E), borderRadius: BorderRadius.circular(15)), child: Icon(icon, size: 16, color: active ? AppColors.bg : AppColors.muted)));
  Widget _queue(PlaybackController p) => AnimatedContainer(duration: const Duration(milliseconds: 280), margin: const EdgeInsets.only(top: 10), padding: const EdgeInsets.fromLTRB(12, 10, 12, 6), constraints: const BoxConstraints(maxHeight: 210), decoration: BoxDecoration(color: const Color(0xEE151A1E), borderRadius: BorderRadius.circular(22)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Playing from artist', style: TextStyle(fontSize: 11, color: AppColors.muted)), const SizedBox(height: 2), Text(p.current?.artistName ?? 'NEFFEX', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)), const SizedBox(height: 5), Expanded(child: ListView.builder(itemCount: p.queue.length, itemBuilder: (_, i) { final s = p.queue[i]; return Row(children: [Container(width: 28, height: 28, decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(7)), child: const Icon(Icons.music_note_rounded, size: 13, color: AppColors.muted)), const SizedBox(width: 8), Expanded(child: Text(s.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10.5))), Text(_fmt(s.duration), style: const TextStyle(color: AppColors.muted, fontSize: 9))]); }))]));
}

class WavePainter extends CustomPainter {
  final double progress;
  WavePainter({required this.progress});
  @override void paint(Canvas c, Size s) {
    final paint = Paint()..color = AppColors.text.withOpacity(.9)..strokeWidth = 1.3..strokeCap = StrokeCap.round;
    for (int i = 0; i < 72; i++) { final x = s.width * i / 71; final amp = 8 + 7 * (.5 + .5 * sin(i * .72)); final y = s.height / 2; final h = amp * (.7 + .3 * sin(i * .32)); c.drawLine(Offset(x, y - h), Offset(x, y + h), paint); }
    final x = s.width * progress.clamp(0, 1); c.drawLine(Offset(x, 0), Offset(x, s.height), Paint()..color = AppColors.text..strokeWidth = 2);
  }
  @override bool shouldRepaint(covariant WavePainter old) => old.progress != progress;
}
String _fmt(Duration d) => d.isNegative ? '0:00' : '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
