import 'package:flutter/material.dart';

/// Key to the app's root [Navigator].
///
/// The phone player sheet ([PlayerSheet]) is mounted as a sibling of the
/// Navigator via `MaterialApp.builder`, so it has **no Navigator in its own
/// ancestors**. Navigating or opening modals with the sheet's local `context`
/// therefore failed silently in release: the volume popup never opened and the
/// artist/title links did nothing (Fabien, recurring on Android). Route those
/// through this key instead of the local context.
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();
