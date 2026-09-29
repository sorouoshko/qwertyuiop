import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFF0B0F12);
  static const surface = Color(0xFF151A1E);
  static const surface2 = Color(0xFF191F23);
  static const accent = Color(0xFF9EDDF5);
  static const accentStrong = Color(0xFF55BDEB);
  static const text = Color(0xFFF4F6F7);
  static const muted = Color(0xFF8C969D);
  static const divider = Color(0x221D252B);
}

ThemeData buildTheme() {
  final base = ThemeData.dark(useMaterial3: false);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.bg,
    canvasColor: AppColors.bg,
    colorScheme: const ColorScheme.dark(
      surface: AppColors.surface,
      primary: AppColors.accent,
      secondary: AppColors.accentStrong,
    ),
    splashFactory: InkSparkle.splashFactory,
    textTheme: base.textTheme.apply(
      fontFamily: 'Inter',
      bodyColor: AppColors.text,
      displayColor: AppColors.text,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
    }),
  );
}
