import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/models/music_models.dart';
import '../../data/repositories/music_repository.dart';
import '../theme/app_theme.dart';

class Artwork extends StatelessWidget {
  final String? path;
  final double? size;
  final double radius;
  final bool circle;
  final BoxFit fit;
  final Color? tint;
  const Artwork({super.key, this.path, this.size, this.radius = 18, this.circle = false, this.fit = BoxFit.cover, this.tint});

  @override
  Widget build(BuildContext context) {
    Widget child = path != null && path!.isNotEmpty
        ? Image.file(File(path!), width: size, height: size, fit: fit, errorBuilder: (_, __, ___) => _fallback())
        : _fallback();
    if (circle) return ClipOval(child: child);
    return ClipRRect(borderRadius: BorderRadius.circular(radius), child: child);
  }
  Widget _fallback() => Container(width: size, height: size, decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(circle ? 1000 : radius)), child: const Icon(Icons.music_note_rounded, color: AppColors.muted, size: 26));
}

class QueryArtwork extends StatelessWidget {
  final int id;
  final double size;
  final double radius;
  final bool circle;
  final MusicRepository repo;
  const QueryArtwork({super.key, required this.id, required this.size, required this.repo, this.radius = 18, this.circle = false});
  @override
  Widget build(BuildContext context) => FutureBuilder<Uint8List?>(future: repo.artwork(id), builder: (_, snap) {
    final img = snap.data;
    final child = img == null ? Container(color: AppColors.surface2, child: const Icon(Icons.music_note_rounded, color: AppColors.muted)) : Image.memory(img, width: size, height: size, fit: BoxFit.cover);
    return ClipRRect(borderRadius: BorderRadius.circular(circle ? 1000 : radius), child: child);
  });
}

class SkeletonBox extends StatefulWidget {
  final double width, height, radius;
  const SkeletonBox({super.key, required this.width, required this.height, this.radius = 16});
  @override State<SkeletonBox> createState() => _SkeletonBoxState();
}
class _SkeletonBoxState extends State<SkeletonBox> with SingleTickerProviderStateMixin {
  late final AnimationController c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..repeat(reverse: true);
  @override void dispose(){c.dispose();super.dispose();}
  @override Widget build(BuildContext context) => AnimatedBuilder(animation:c,builder:(_,__)=>Container(width:widget.width,height:widget.height,decoration:BoxDecoration(color:Color.lerp(AppColors.surface,AppColors.surface2,c.value),borderRadius:BorderRadius.circular(widget.radius))));
}
