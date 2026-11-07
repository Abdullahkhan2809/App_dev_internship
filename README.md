# Nokia LCD Snake

A retro, grid-based Snake game built with Flutter. It uses a Canvas painter for
the board, Geist Pixel typography from Google Fonts, keyboard/swipe/on-screen
controls, and local high-score and sound-preference storage.

## Run

From this directory:

```shell
flutter pub get
flutter run
```

## Controls

- Arrow keys or WASD: steer
- P, Space, or Escape: pause or resume
- Touch screens: swipe on the board or use the directional pad
- Enter: restart after game over

Sound effects use the platform's built-in click and alert sounds. High scores and
the sound-effects setting are saved with `SharedPreferences`.

## Verify

```shell
flutter analyze
flutter test
```
