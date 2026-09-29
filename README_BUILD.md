# Offline Cinematic Player - Build

This copy fixes the Dart/Flutter compile errors found during Android release builds:
- removed unsupported `CustomScrollView(padding: ...)` usage
- replaced unavailable `CupertinoPageTransitionsBuilder`
- removed unsupported `SongModel.year` access for on_audio_query 2.9.0
- added missing `SkeletonBox` imports

Build with Flutter:

    flutter pub get
    flutter create . --platforms=android
    flutter build apk --release

APK output:

    build/app/outputs/flutter-apk/app-release.apk
