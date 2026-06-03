import 'dart:async';

import 'package:flutter/foundation.dart';

import '../event_bus.dart';

// ---------------------------------------------------------------------------
// PluginSDK
// Plugin manifest, state, abstract TunePlugin class,
// PluginManager with register/enable/disable/notify.
// Miroir de plugin_sdk.rs (Rust)
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Plugin manifest
// ---------------------------------------------------------------------------

/// Metadata describing a plugin.
class PluginManifest {
  final String id;           // unique identifier, e.g. 'com.mozaiklabs.eq'
  final String name;         // display name
  final String version;      // semver
  final String? description;
  final String? author;
  final String? homepage;

  /// Required Tune server version (semver range).
  final String? minServerVersion;

  /// Plugin capabilities.
  final Set<String> capabilities; // e.g. {'audio_processor', 'metadata_provider'}

  const PluginManifest({
    required this.id,
    required this.name,
    required this.version,
    this.description,
    this.author,
    this.homepage,
    this.minServerVersion,
    this.capabilities = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'version': version,
        'description': description,
        'author': author,
        'homepage': homepage,
        'min_server_version': minServerVersion,
        'capabilities': capabilities.toList(),
      };
}

// ---------------------------------------------------------------------------
// Plugin state
// ---------------------------------------------------------------------------

enum PluginState {
  registered,   // Known but not started
  enabled,      // Active and running
  disabled,     // Explicitly disabled by user
  error,        // Failed to start or crashed
}

// ---------------------------------------------------------------------------
// Plugin events
// ---------------------------------------------------------------------------

class PluginEvent extends AppEvent {
  final String pluginId;
  final String action; // 'registered', 'enabled', 'disabled', 'error'
  final String? message;
  const PluginEvent(this.pluginId, this.action, {this.message});
}

/// Events that plugins can receive.
class PluginNotification {
  final String type;      // 'track_changed', 'playback_started', 'scan_completed', etc.
  final Map<String, dynamic> data;

  const PluginNotification({required this.type, this.data = const {}});
}

// ---------------------------------------------------------------------------
// Abstract plugin class
// ---------------------------------------------------------------------------

/// Base class for all Tune plugins.
/// Plugins extend this and implement the lifecycle methods.
abstract class TunePlugin {
  /// Plugin manifest (metadata).
  PluginManifest get manifest;

  /// Current state (managed by PluginManager).
  PluginState state = PluginState.registered;

  /// Called when the plugin is enabled. Initialize resources here.
  Future<void> onEnable();

  /// Called when the plugin is disabled. Clean up resources here.
  Future<void> onDisable();

  /// Called when the plugin receives a notification from the server.
  Future<void> onNotification(PluginNotification notification) async {}

  /// Plugin-specific status for the API.
  Map<String, dynamic> get status => {
        'id': manifest.id,
        'name': manifest.name,
        'version': manifest.version,
        'state': state.name,
      };
}

// ---------------------------------------------------------------------------
// Plugin manager
// ---------------------------------------------------------------------------

class PluginManager {
  PluginManager._();
  static final PluginManager instance = PluginManager._();

  final Map<String, TunePlugin> _plugins = {};

  // ---------------------------------------------------------------------------
  // Registration
  // ---------------------------------------------------------------------------

  /// Register a plugin. Does not enable it.
  bool register(TunePlugin plugin) {
    final id = plugin.manifest.id;
    if (_plugins.containsKey(id)) {
      debugPrint('[PluginManager] Plugin $id already registered');
      return false;
    }

    _plugins[id] = plugin;
    plugin.state = PluginState.registered;

    EventBus.instance.emit(PluginEvent(id, 'registered'));
    debugPrint('[PluginManager] Registered plugin: '
        '${plugin.manifest.name} v${plugin.manifest.version}');
    return true;
  }

  /// Unregister a plugin. Disables it first if enabled.
  Future<bool> unregister(String pluginId) async {
    final plugin = _plugins[pluginId];
    if (plugin == null) return false;

    if (plugin.state == PluginState.enabled) {
      await disable(pluginId);
    }

    _plugins.remove(pluginId);
    debugPrint('[PluginManager] Unregistered plugin: $pluginId');
    return true;
  }

  // ---------------------------------------------------------------------------
  // Enable / Disable
  // ---------------------------------------------------------------------------

  /// Enable a registered plugin.
  Future<bool> enable(String pluginId) async {
    final plugin = _plugins[pluginId];
    if (plugin == null) {
      debugPrint('[PluginManager] Plugin $pluginId not found');
      return false;
    }

    if (plugin.state == PluginState.enabled) return true;

    try {
      await plugin.onEnable();
      plugin.state = PluginState.enabled;
      EventBus.instance.emit(PluginEvent(pluginId, 'enabled'));
      debugPrint('[PluginManager] Enabled plugin: ${plugin.manifest.name}');
      return true;
    } catch (e) {
      plugin.state = PluginState.error;
      EventBus.instance.emit(
        PluginEvent(pluginId, 'error', message: 'Enable failed: $e'),
      );
      debugPrint('[PluginManager] Failed to enable $pluginId: $e');
      return false;
    }
  }

  /// Disable an enabled plugin.
  Future<bool> disable(String pluginId) async {
    final plugin = _plugins[pluginId];
    if (plugin == null) return false;

    if (plugin.state != PluginState.enabled) {
      plugin.state = PluginState.disabled;
      return true;
    }

    try {
      await plugin.onDisable();
      plugin.state = PluginState.disabled;
      EventBus.instance.emit(PluginEvent(pluginId, 'disabled'));
      debugPrint('[PluginManager] Disabled plugin: ${plugin.manifest.name}');
      return true;
    } catch (e) {
      plugin.state = PluginState.error;
      debugPrint('[PluginManager] Error disabling $pluginId: $e');
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Notifications
  // ---------------------------------------------------------------------------

  /// Notify all enabled plugins of an event.
  Future<void> notify(PluginNotification notification) async {
    for (final plugin in _plugins.values) {
      if (plugin.state != PluginState.enabled) continue;

      try {
        await plugin.onNotification(notification);
      } catch (e) {
        debugPrint('[PluginManager] Error notifying ${plugin.manifest.id}: $e');
      }
    }
  }

  /// Notify plugins with a specific capability.
  Future<void> notifyWithCapability(
    String capability,
    PluginNotification notification,
  ) async {
    for (final plugin in _plugins.values) {
      if (plugin.state != PluginState.enabled) continue;
      if (!plugin.manifest.capabilities.contains(capability)) continue;

      try {
        await plugin.onNotification(notification);
      } catch (e) {
        debugPrint('[PluginManager] Error notifying ${plugin.manifest.id}: $e');
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Queries
  // ---------------------------------------------------------------------------

  /// Get a plugin by ID.
  TunePlugin? getPlugin(String pluginId) => _plugins[pluginId];

  /// Get all registered plugins.
  List<TunePlugin> get allPlugins => _plugins.values.toList();

  /// Get all enabled plugins.
  List<TunePlugin> get enabledPlugins =>
      _plugins.values.where((p) => p.state == PluginState.enabled).toList();

  /// Get plugins with a specific capability.
  List<TunePlugin> withCapability(String capability) =>
      _plugins.values
          .where((p) => p.manifest.capabilities.contains(capability))
          .toList();

  /// Plugin count.
  int get count => _plugins.length;

  // ---------------------------------------------------------------------------
  // Status for API
  // ---------------------------------------------------------------------------

  Map<String, dynamic> get status => {
        'total': _plugins.length,
        'enabled': enabledPlugins.length,
        'plugins': _plugins.values.map((p) => p.status).toList(),
      };

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  /// Disable all plugins and clear.
  Future<void> dispose() async {
    for (final pluginId in _plugins.keys.toList()) {
      await disable(pluginId);
    }
    _plugins.clear();
  }
}
