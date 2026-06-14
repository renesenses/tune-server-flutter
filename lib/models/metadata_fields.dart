// ---------------------------------------------------------------------------
// Configurable metadata fields — models for the extended metadata system.
// Mirrors MetadataFieldsResponse / MetadataCategory / MetadataField from
// the web client (metadata.ts).
// ---------------------------------------------------------------------------

/// A single metadata field definition (e.g. "composer", "conductor").
class MetadataField {
  final String key;
  final String label;
  bool enabled;

  MetadataField({
    required this.key,
    required this.label,
    required this.enabled,
  });

  factory MetadataField.fromJson(Map<String, dynamic> json) => MetadataField(
        key: json['key'] as String? ?? '',
        label: json['label'] as String? ?? '',
        enabled: json['enabled'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'key': key,
        'label': label,
        'enabled': enabled,
      };
}

/// A category grouping related metadata fields (e.g. "Credits", "Classification").
class MetadataCategory {
  final String name;
  final List<MetadataField> fields;

  MetadataCategory({required this.name, required this.fields});

  factory MetadataCategory.fromJson(Map<String, dynamic> json) => MetadataCategory(
        name: json['name'] as String? ?? '',
        fields: (json['fields'] as List<dynamic>?)
                ?.map((f) => MetadataField.fromJson(f as Map<String, dynamic>))
                .toList() ??
            [],
      );

  /// Number of enabled fields in this category.
  int get enabledCount => fields.where((f) => f.enabled).length;
}

/// Server response for `GET /api/v1/system/settings/metadata-fields`.
class MetadataFieldsResponse {
  final List<MetadataCategory> categories;

  MetadataFieldsResponse({required this.categories});

  factory MetadataFieldsResponse.fromJson(Map<String, dynamic> json) =>
      MetadataFieldsResponse(
        categories: (json['categories'] as List<dynamic>?)
                ?.map((c) => MetadataCategory.fromJson(c as Map<String, dynamic>))
                .toList() ??
            [],
      );

  /// Flat list of all enabled field keys (for saving back to server).
  List<String> get enabledKeys => categories
      .expand((c) => c.fields)
      .where((f) => f.enabled)
      .map((f) => f.key)
      .toList();

  /// Only categories that have at least one enabled field.
  List<MetadataCategory> get enabledCategories => categories
      .map((c) => MetadataCategory(
            name: c.name,
            fields: c.fields.where((f) => f.enabled).toList(),
          ))
      .where((c) => c.fields.isNotEmpty)
      .toList();
}
