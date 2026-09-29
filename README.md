# Offline Cinematic Player

A Flutter prototype reconstructed from the supplied 382x858 screen recording. It is intentionally offline-first: the production data path scans local audio, persists library state locally, and uses a single reactive playback controller shared by every screen.

## Reference observations
- 382x858 portrait recording, ~86s.
- Floating translucent bottom navigation with Home/Search/Library/Settings/artwork.
- Cyan selected capsule, near-black charcoal surfaces, compact typography.
- Full-screen player uses the current artwork as a blurred/darkened background.
- Queue appears as a lower floating sheet/stack, not a separate route.
- Detail routes slide in from the right and reverse on back.
- Library has a large cyan Liked Songs hero and four dark utility cards.

## Run

Flutter is required on the development machine. From this directory:

```bash
flutter pub get
flutter run
```

The source was generated in an environment without Flutter/Dart installed, so compilation could not be executed here. The project is structured to be directly opened in Android Studio or VS Code and then checked with `flutter analyze` / `flutter test`.

## Android local audio

`on_audio_query` is used for the local media catalog. The Android manifest includes READ_MEDIA_AUDIO for modern Android and READ_EXTERNAL_STORAGE for older Android. Background playback is provided through `just_audio` + `audio_service`.

## iOS

iOS local-library permission and background audio capability should be enabled in Xcode. The same repository and player abstractions are used; platform permission details live in the service layer.
