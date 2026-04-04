# CLAUDE.md — Tune Server Flutter

## Project

Flutter multiplatform app (iOS + Android) for the Tune music server. Operates as an **embedded server** with local playback — NOT a remote client. Includes full library scanning, playback, streaming services, zone management, and multi-room grouping.

## Build

```bash
flutter pub get
flutter run               # debug
flutter build apk         # Android release
flutter build ios         # iOS release
```

- **Flutter SDK**: ^3.11.3, Dart ^3.11.3
- **Min targets**: iOS 16.0, Android SDK 24

## Architecture

```
lib/
├── main.dart              # Entry point, Provider setup
├── models/
│   └── domain_models.dart # ZoneWithState, PlaybackState, OutputType
├── server/
│   ├── database/          # Drift (SQLite ORM)
│   │   ├── schema.dart    # Tables: zones, tracks, albums, artists, playlists, play_queue
│   │   └── repositories/  # ZoneRepository, TrackRepository, etc.
│   ├── zones/
│   │   ├── zone_manager.dart   # Zone lifecycle, grouping, output management
│   │   └── zone_instance.dart  # Player + Queue + Output per zone
│   ├── playback/          # Player, PlayQueue
│   ├── event_bus.dart     # Async pub/sub events
│   └── outputs/           # OutputTarget: local, DLNA, Bluetooth
├── state/
│   ├── app_state.dart     # Central ChangeNotifier, all actions
│   └── zone_state.dart    # Zone list, current zone, groups
├── views/
│   ├── zones/zones_view.dart        # Zone management + multiroom grouping
│   ├── library/                     # Albums, artists, tracks views
│   ├── streaming/                   # Tidal, Qobuz, YouTube views
│   ├── radios/                      # Radio stations
│   ├── settings/                    # Settings view
│   └── iphone_content_view.dart     # Tab navigation (iPhone)
│       ipad_content_view.dart       # Sidebar navigation (iPad)
└── l10n/                  # 8 languages: en, fr, de, es, it, zh, ko, ja
```

## Key Patterns

- **State management**: Provider + ChangeNotifier (NOT Riverpod or Bloc)
- **Database**: Drift (SQLite ORM, equivalent to GRDB on iOS)
- **Audio**: just_audio for local playback
- **HTTP Server**: shelf + shelf_router (embedded, not connecting to remote)
- **Events**: EventBus with typed events (ZoneCreatedEvent, PlaybackStartedEvent, etc.)
- **Zone grouping**: groupId + syncDelayMs fields on Zone table, ZoneGroup model in zone_state.dart

## Dependencies

- `drift` (2.20+) — SQLite database
- `just_audio` (0.10+) — Audio playback
- `shelf` + `shelf_router` — Embedded HTTP server
- `provider` (6.1+) — State management
- `flutter_localizations` — i18n

## Localization

ARB files in `lib/l10n/app_*.arb`, generated classes in `lib/l10n/app_localizations_*.dart`.
8 languages supported. Add strings to all `.arb` files + regenerate with `flutter gen-l10n`.

## CRITICAL RULES

- **NEVER mention or reference recorder, recording, or special-edition features.** This is a public repo.
