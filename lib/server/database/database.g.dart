// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ArtistsTable extends Artists with TableInfo<$ArtistsTable, Artist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArtistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortNameMeta = const VerificationMeta(
    'sortName',
  );
  @override
  late final GeneratedColumn<String> sortName = GeneratedColumn<String>(
    'sort_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _musicbrainzIdMeta = const VerificationMeta(
    'musicbrainzId',
  );
  @override
  late final GeneratedColumn<String> musicbrainzId = GeneratedColumn<String>(
    'musicbrainz_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discogsIdMeta = const VerificationMeta(
    'discogsId',
  );
  @override
  late final GeneratedColumn<String> discogsId = GeneratedColumn<String>(
    'discogs_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
    'bio',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    sortName,
    musicbrainzId,
    discogsId,
    bio,
    imagePath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'artists';
  @override
  VerificationContext validateIntegrity(
    Insertable<Artist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_name')) {
      context.handle(
        _sortNameMeta,
        sortName.isAcceptableOrUnknown(data['sort_name']!, _sortNameMeta),
      );
    }
    if (data.containsKey('musicbrainz_id')) {
      context.handle(
        _musicbrainzIdMeta,
        musicbrainzId.isAcceptableOrUnknown(
          data['musicbrainz_id']!,
          _musicbrainzIdMeta,
        ),
      );
    }
    if (data.containsKey('discogs_id')) {
      context.handle(
        _discogsIdMeta,
        discogsId.isAcceptableOrUnknown(data['discogs_id']!, _discogsIdMeta),
      );
    }
    if (data.containsKey('bio')) {
      context.handle(
        _bioMeta,
        bio.isAcceptableOrUnknown(data['bio']!, _bioMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Artist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Artist(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sort_name'],
      ),
      musicbrainzId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}musicbrainz_id'],
      ),
      discogsId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}discogs_id'],
      ),
      bio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bio'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
    );
  }

  @override
  $ArtistsTable createAlias(String alias) {
    return $ArtistsTable(attachedDatabase, alias);
  }
}

class Artist extends DataClass implements Insertable<Artist> {
  final int id;
  final String name;
  final String? sortName;
  final String? musicbrainzId;
  final String? discogsId;
  final String? bio;
  final String? imagePath;
  const Artist({
    required this.id,
    required this.name,
    this.sortName,
    this.musicbrainzId,
    this.discogsId,
    this.bio,
    this.imagePath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || sortName != null) {
      map['sort_name'] = Variable<String>(sortName);
    }
    if (!nullToAbsent || musicbrainzId != null) {
      map['musicbrainz_id'] = Variable<String>(musicbrainzId);
    }
    if (!nullToAbsent || discogsId != null) {
      map['discogs_id'] = Variable<String>(discogsId);
    }
    if (!nullToAbsent || bio != null) {
      map['bio'] = Variable<String>(bio);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    return map;
  }

  ArtistsCompanion toCompanion(bool nullToAbsent) {
    return ArtistsCompanion(
      id: Value(id),
      name: Value(name),
      sortName: sortName == null && nullToAbsent
          ? const Value.absent()
          : Value(sortName),
      musicbrainzId: musicbrainzId == null && nullToAbsent
          ? const Value.absent()
          : Value(musicbrainzId),
      discogsId: discogsId == null && nullToAbsent
          ? const Value.absent()
          : Value(discogsId),
      bio: bio == null && nullToAbsent ? const Value.absent() : Value(bio),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
    );
  }

  factory Artist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Artist(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sortName: serializer.fromJson<String?>(json['sortName']),
      musicbrainzId: serializer.fromJson<String?>(json['musicbrainzId']),
      discogsId: serializer.fromJson<String?>(json['discogsId']),
      bio: serializer.fromJson<String?>(json['bio']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'sortName': serializer.toJson<String?>(sortName),
      'musicbrainzId': serializer.toJson<String?>(musicbrainzId),
      'discogsId': serializer.toJson<String?>(discogsId),
      'bio': serializer.toJson<String?>(bio),
      'imagePath': serializer.toJson<String?>(imagePath),
    };
  }

  Artist copyWith({
    int? id,
    String? name,
    Value<String?> sortName = const Value.absent(),
    Value<String?> musicbrainzId = const Value.absent(),
    Value<String?> discogsId = const Value.absent(),
    Value<String?> bio = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
  }) => Artist(
    id: id ?? this.id,
    name: name ?? this.name,
    sortName: sortName.present ? sortName.value : this.sortName,
    musicbrainzId: musicbrainzId.present
        ? musicbrainzId.value
        : this.musicbrainzId,
    discogsId: discogsId.present ? discogsId.value : this.discogsId,
    bio: bio.present ? bio.value : this.bio,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
  );
  Artist copyWithCompanion(ArtistsCompanion data) {
    return Artist(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sortName: data.sortName.present ? data.sortName.value : this.sortName,
      musicbrainzId: data.musicbrainzId.present
          ? data.musicbrainzId.value
          : this.musicbrainzId,
      discogsId: data.discogsId.present ? data.discogsId.value : this.discogsId,
      bio: data.bio.present ? data.bio.value : this.bio,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Artist(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortName: $sortName, ')
          ..write('musicbrainzId: $musicbrainzId, ')
          ..write('discogsId: $discogsId, ')
          ..write('bio: $bio, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, sortName, musicbrainzId, discogsId, bio, imagePath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Artist &&
          other.id == this.id &&
          other.name == this.name &&
          other.sortName == this.sortName &&
          other.musicbrainzId == this.musicbrainzId &&
          other.discogsId == this.discogsId &&
          other.bio == this.bio &&
          other.imagePath == this.imagePath);
}

class ArtistsCompanion extends UpdateCompanion<Artist> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> sortName;
  final Value<String?> musicbrainzId;
  final Value<String?> discogsId;
  final Value<String?> bio;
  final Value<String?> imagePath;
  const ArtistsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sortName = const Value.absent(),
    this.musicbrainzId = const Value.absent(),
    this.discogsId = const Value.absent(),
    this.bio = const Value.absent(),
    this.imagePath = const Value.absent(),
  });
  ArtistsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.sortName = const Value.absent(),
    this.musicbrainzId = const Value.absent(),
    this.discogsId = const Value.absent(),
    this.bio = const Value.absent(),
    this.imagePath = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Artist> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? sortName,
    Expression<String>? musicbrainzId,
    Expression<String>? discogsId,
    Expression<String>? bio,
    Expression<String>? imagePath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sortName != null) 'sort_name': sortName,
      if (musicbrainzId != null) 'musicbrainz_id': musicbrainzId,
      if (discogsId != null) 'discogs_id': discogsId,
      if (bio != null) 'bio': bio,
      if (imagePath != null) 'image_path': imagePath,
    });
  }

  ArtistsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? sortName,
    Value<String?>? musicbrainzId,
    Value<String?>? discogsId,
    Value<String?>? bio,
    Value<String?>? imagePath,
  }) {
    return ArtistsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sortName: sortName ?? this.sortName,
      musicbrainzId: musicbrainzId ?? this.musicbrainzId,
      discogsId: discogsId ?? this.discogsId,
      bio: bio ?? this.bio,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortName.present) {
      map['sort_name'] = Variable<String>(sortName.value);
    }
    if (musicbrainzId.present) {
      map['musicbrainz_id'] = Variable<String>(musicbrainzId.value);
    }
    if (discogsId.present) {
      map['discogs_id'] = Variable<String>(discogsId.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArtistsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortName: $sortName, ')
          ..write('musicbrainzId: $musicbrainzId, ')
          ..write('discogsId: $discogsId, ')
          ..write('bio: $bio, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }
}

class $AlbumsTable extends Albums with TableInfo<$AlbumsTable, Album> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlbumsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artistIdMeta = const VerificationMeta(
    'artistId',
  );
  @override
  late final GeneratedColumn<int> artistId = GeneratedColumn<int>(
    'artist_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES artists (id)',
    ),
  );
  static const VerificationMeta _artistNameMeta = const VerificationMeta(
    'artistName',
  );
  @override
  late final GeneratedColumn<String> artistName = GeneratedColumn<String>(
    'artist_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genreMeta = const VerificationMeta('genre');
  @override
  late final GeneratedColumn<String> genre = GeneratedColumn<String>(
    'genre',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discCountMeta = const VerificationMeta(
    'discCount',
  );
  @override
  late final GeneratedColumn<int> discCount = GeneratedColumn<int>(
    'disc_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trackCountMeta = const VerificationMeta(
    'trackCount',
  );
  @override
  late final GeneratedColumn<int> trackCount = GeneratedColumn<int>(
    'track_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverPathMeta = const VerificationMeta(
    'coverPath',
  );
  @override
  late final GeneratedColumn<String> coverPath = GeneratedColumn<String>(
    'cover_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('local'),
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    artistId,
    artistName,
    year,
    genre,
    discCount,
    trackCount,
    coverPath,
    source,
    sourceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'albums';
  @override
  VerificationContext validateIntegrity(
    Insertable<Album> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('artist_id')) {
      context.handle(
        _artistIdMeta,
        artistId.isAcceptableOrUnknown(data['artist_id']!, _artistIdMeta),
      );
    }
    if (data.containsKey('artist_name')) {
      context.handle(
        _artistNameMeta,
        artistName.isAcceptableOrUnknown(data['artist_name']!, _artistNameMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('genre')) {
      context.handle(
        _genreMeta,
        genre.isAcceptableOrUnknown(data['genre']!, _genreMeta),
      );
    }
    if (data.containsKey('disc_count')) {
      context.handle(
        _discCountMeta,
        discCount.isAcceptableOrUnknown(data['disc_count']!, _discCountMeta),
      );
    }
    if (data.containsKey('track_count')) {
      context.handle(
        _trackCountMeta,
        trackCount.isAcceptableOrUnknown(data['track_count']!, _trackCountMeta),
      );
    }
    if (data.containsKey('cover_path')) {
      context.handle(
        _coverPathMeta,
        coverPath.isAcceptableOrUnknown(data['cover_path']!, _coverPathMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Album map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Album(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      artistId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}artist_id'],
      ),
      artistName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artist_name'],
      ),
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      genre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genre'],
      ),
      discCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}disc_count'],
      ),
      trackCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}track_count'],
      ),
      coverPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_path'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      ),
    );
  }

  @override
  $AlbumsTable createAlias(String alias) {
    return $AlbumsTable(attachedDatabase, alias);
  }
}

class Album extends DataClass implements Insertable<Album> {
  final int id;
  final String title;
  final int? artistId;
  final String? artistName;
  final int? year;
  final String? genre;
  final int? discCount;
  final int? trackCount;
  final String? coverPath;
  final String source;
  final String? sourceId;
  const Album({
    required this.id,
    required this.title,
    this.artistId,
    this.artistName,
    this.year,
    this.genre,
    this.discCount,
    this.trackCount,
    this.coverPath,
    required this.source,
    this.sourceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || artistId != null) {
      map['artist_id'] = Variable<int>(artistId);
    }
    if (!nullToAbsent || artistName != null) {
      map['artist_name'] = Variable<String>(artistName);
    }
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    if (!nullToAbsent || genre != null) {
      map['genre'] = Variable<String>(genre);
    }
    if (!nullToAbsent || discCount != null) {
      map['disc_count'] = Variable<int>(discCount);
    }
    if (!nullToAbsent || trackCount != null) {
      map['track_count'] = Variable<int>(trackCount);
    }
    if (!nullToAbsent || coverPath != null) {
      map['cover_path'] = Variable<String>(coverPath);
    }
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || sourceId != null) {
      map['source_id'] = Variable<String>(sourceId);
    }
    return map;
  }

  AlbumsCompanion toCompanion(bool nullToAbsent) {
    return AlbumsCompanion(
      id: Value(id),
      title: Value(title),
      artistId: artistId == null && nullToAbsent
          ? const Value.absent()
          : Value(artistId),
      artistName: artistName == null && nullToAbsent
          ? const Value.absent()
          : Value(artistName),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      genre: genre == null && nullToAbsent
          ? const Value.absent()
          : Value(genre),
      discCount: discCount == null && nullToAbsent
          ? const Value.absent()
          : Value(discCount),
      trackCount: trackCount == null && nullToAbsent
          ? const Value.absent()
          : Value(trackCount),
      coverPath: coverPath == null && nullToAbsent
          ? const Value.absent()
          : Value(coverPath),
      source: Value(source),
      sourceId: sourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceId),
    );
  }

  factory Album.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Album(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      artistId: serializer.fromJson<int?>(json['artistId']),
      artistName: serializer.fromJson<String?>(json['artistName']),
      year: serializer.fromJson<int?>(json['year']),
      genre: serializer.fromJson<String?>(json['genre']),
      discCount: serializer.fromJson<int?>(json['discCount']),
      trackCount: serializer.fromJson<int?>(json['trackCount']),
      coverPath: serializer.fromJson<String?>(json['coverPath']),
      source: serializer.fromJson<String>(json['source']),
      sourceId: serializer.fromJson<String?>(json['sourceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'artistId': serializer.toJson<int?>(artistId),
      'artistName': serializer.toJson<String?>(artistName),
      'year': serializer.toJson<int?>(year),
      'genre': serializer.toJson<String?>(genre),
      'discCount': serializer.toJson<int?>(discCount),
      'trackCount': serializer.toJson<int?>(trackCount),
      'coverPath': serializer.toJson<String?>(coverPath),
      'source': serializer.toJson<String>(source),
      'sourceId': serializer.toJson<String?>(sourceId),
    };
  }

  Album copyWith({
    int? id,
    String? title,
    Value<int?> artistId = const Value.absent(),
    Value<String?> artistName = const Value.absent(),
    Value<int?> year = const Value.absent(),
    Value<String?> genre = const Value.absent(),
    Value<int?> discCount = const Value.absent(),
    Value<int?> trackCount = const Value.absent(),
    Value<String?> coverPath = const Value.absent(),
    String? source,
    Value<String?> sourceId = const Value.absent(),
  }) => Album(
    id: id ?? this.id,
    title: title ?? this.title,
    artistId: artistId.present ? artistId.value : this.artistId,
    artistName: artistName.present ? artistName.value : this.artistName,
    year: year.present ? year.value : this.year,
    genre: genre.present ? genre.value : this.genre,
    discCount: discCount.present ? discCount.value : this.discCount,
    trackCount: trackCount.present ? trackCount.value : this.trackCount,
    coverPath: coverPath.present ? coverPath.value : this.coverPath,
    source: source ?? this.source,
    sourceId: sourceId.present ? sourceId.value : this.sourceId,
  );
  Album copyWithCompanion(AlbumsCompanion data) {
    return Album(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      artistId: data.artistId.present ? data.artistId.value : this.artistId,
      artistName: data.artistName.present
          ? data.artistName.value
          : this.artistName,
      year: data.year.present ? data.year.value : this.year,
      genre: data.genre.present ? data.genre.value : this.genre,
      discCount: data.discCount.present ? data.discCount.value : this.discCount,
      trackCount: data.trackCount.present
          ? data.trackCount.value
          : this.trackCount,
      coverPath: data.coverPath.present ? data.coverPath.value : this.coverPath,
      source: data.source.present ? data.source.value : this.source,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Album(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('artistId: $artistId, ')
          ..write('artistName: $artistName, ')
          ..write('year: $year, ')
          ..write('genre: $genre, ')
          ..write('discCount: $discCount, ')
          ..write('trackCount: $trackCount, ')
          ..write('coverPath: $coverPath, ')
          ..write('source: $source, ')
          ..write('sourceId: $sourceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    artistId,
    artistName,
    year,
    genre,
    discCount,
    trackCount,
    coverPath,
    source,
    sourceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Album &&
          other.id == this.id &&
          other.title == this.title &&
          other.artistId == this.artistId &&
          other.artistName == this.artistName &&
          other.year == this.year &&
          other.genre == this.genre &&
          other.discCount == this.discCount &&
          other.trackCount == this.trackCount &&
          other.coverPath == this.coverPath &&
          other.source == this.source &&
          other.sourceId == this.sourceId);
}

class AlbumsCompanion extends UpdateCompanion<Album> {
  final Value<int> id;
  final Value<String> title;
  final Value<int?> artistId;
  final Value<String?> artistName;
  final Value<int?> year;
  final Value<String?> genre;
  final Value<int?> discCount;
  final Value<int?> trackCount;
  final Value<String?> coverPath;
  final Value<String> source;
  final Value<String?> sourceId;
  const AlbumsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.artistId = const Value.absent(),
    this.artistName = const Value.absent(),
    this.year = const Value.absent(),
    this.genre = const Value.absent(),
    this.discCount = const Value.absent(),
    this.trackCount = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.source = const Value.absent(),
    this.sourceId = const Value.absent(),
  });
  AlbumsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.artistId = const Value.absent(),
    this.artistName = const Value.absent(),
    this.year = const Value.absent(),
    this.genre = const Value.absent(),
    this.discCount = const Value.absent(),
    this.trackCount = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.source = const Value.absent(),
    this.sourceId = const Value.absent(),
  }) : title = Value(title);
  static Insertable<Album> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? artistId,
    Expression<String>? artistName,
    Expression<int>? year,
    Expression<String>? genre,
    Expression<int>? discCount,
    Expression<int>? trackCount,
    Expression<String>? coverPath,
    Expression<String>? source,
    Expression<String>? sourceId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (artistId != null) 'artist_id': artistId,
      if (artistName != null) 'artist_name': artistName,
      if (year != null) 'year': year,
      if (genre != null) 'genre': genre,
      if (discCount != null) 'disc_count': discCount,
      if (trackCount != null) 'track_count': trackCount,
      if (coverPath != null) 'cover_path': coverPath,
      if (source != null) 'source': source,
      if (sourceId != null) 'source_id': sourceId,
    });
  }

  AlbumsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<int?>? artistId,
    Value<String?>? artistName,
    Value<int?>? year,
    Value<String?>? genre,
    Value<int?>? discCount,
    Value<int?>? trackCount,
    Value<String?>? coverPath,
    Value<String>? source,
    Value<String?>? sourceId,
  }) {
    return AlbumsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      artistId: artistId ?? this.artistId,
      artistName: artistName ?? this.artistName,
      year: year ?? this.year,
      genre: genre ?? this.genre,
      discCount: discCount ?? this.discCount,
      trackCount: trackCount ?? this.trackCount,
      coverPath: coverPath ?? this.coverPath,
      source: source ?? this.source,
      sourceId: sourceId ?? this.sourceId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (artistId.present) {
      map['artist_id'] = Variable<int>(artistId.value);
    }
    if (artistName.present) {
      map['artist_name'] = Variable<String>(artistName.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    if (discCount.present) {
      map['disc_count'] = Variable<int>(discCount.value);
    }
    if (trackCount.present) {
      map['track_count'] = Variable<int>(trackCount.value);
    }
    if (coverPath.present) {
      map['cover_path'] = Variable<String>(coverPath.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlbumsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('artistId: $artistId, ')
          ..write('artistName: $artistName, ')
          ..write('year: $year, ')
          ..write('genre: $genre, ')
          ..write('discCount: $discCount, ')
          ..write('trackCount: $trackCount, ')
          ..write('coverPath: $coverPath, ')
          ..write('source: $source, ')
          ..write('sourceId: $sourceId')
          ..write(')'))
        .toString();
  }
}

class $TracksTable extends Tracks with TableInfo<$TracksTable, Track> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TracksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _albumIdMeta = const VerificationMeta(
    'albumId',
  );
  @override
  late final GeneratedColumn<int> albumId = GeneratedColumn<int>(
    'album_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES albums (id)',
    ),
  );
  static const VerificationMeta _albumTitleMeta = const VerificationMeta(
    'albumTitle',
  );
  @override
  late final GeneratedColumn<String> albumTitle = GeneratedColumn<String>(
    'album_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _artistIdMeta = const VerificationMeta(
    'artistId',
  );
  @override
  late final GeneratedColumn<int> artistId = GeneratedColumn<int>(
    'artist_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES artists (id)',
    ),
  );
  static const VerificationMeta _artistNameMeta = const VerificationMeta(
    'artistName',
  );
  @override
  late final GeneratedColumn<String> artistName = GeneratedColumn<String>(
    'artist_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discNumberMeta = const VerificationMeta(
    'discNumber',
  );
  @override
  late final GeneratedColumn<int> discNumber = GeneratedColumn<int>(
    'disc_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trackNumberMeta = const VerificationMeta(
    'trackNumber',
  );
  @override
  late final GeneratedColumn<int> trackNumber = GeneratedColumn<int>(
    'track_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _formatMeta = const VerificationMeta('format');
  @override
  late final GeneratedColumn<String> format = GeneratedColumn<String>(
    'format',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sampleRateMeta = const VerificationMeta(
    'sampleRate',
  );
  @override
  late final GeneratedColumn<int> sampleRate = GeneratedColumn<int>(
    'sample_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bitDepthMeta = const VerificationMeta(
    'bitDepth',
  );
  @override
  late final GeneratedColumn<int> bitDepth = GeneratedColumn<int>(
    'bit_depth',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _channelsMeta = const VerificationMeta(
    'channels',
  );
  @override
  late final GeneratedColumn<int> channels = GeneratedColumn<int>(
    'channels',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverPathMeta = const VerificationMeta(
    'coverPath',
  );
  @override
  late final GeneratedColumn<String> coverPath = GeneratedColumn<String>(
    'cover_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('local'),
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _favoriteMeta = const VerificationMeta(
    'favorite',
  );
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
    'favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    albumId,
    albumTitle,
    artistId,
    artistName,
    discNumber,
    trackNumber,
    durationMs,
    filePath,
    format,
    sampleRate,
    bitDepth,
    channels,
    coverPath,
    source,
    sourceId,
    favorite,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tracks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Track> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('album_id')) {
      context.handle(
        _albumIdMeta,
        albumId.isAcceptableOrUnknown(data['album_id']!, _albumIdMeta),
      );
    }
    if (data.containsKey('album_title')) {
      context.handle(
        _albumTitleMeta,
        albumTitle.isAcceptableOrUnknown(data['album_title']!, _albumTitleMeta),
      );
    }
    if (data.containsKey('artist_id')) {
      context.handle(
        _artistIdMeta,
        artistId.isAcceptableOrUnknown(data['artist_id']!, _artistIdMeta),
      );
    }
    if (data.containsKey('artist_name')) {
      context.handle(
        _artistNameMeta,
        artistName.isAcceptableOrUnknown(data['artist_name']!, _artistNameMeta),
      );
    }
    if (data.containsKey('disc_number')) {
      context.handle(
        _discNumberMeta,
        discNumber.isAcceptableOrUnknown(data['disc_number']!, _discNumberMeta),
      );
    }
    if (data.containsKey('track_number')) {
      context.handle(
        _trackNumberMeta,
        trackNumber.isAcceptableOrUnknown(
          data['track_number']!,
          _trackNumberMeta,
        ),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    }
    if (data.containsKey('format')) {
      context.handle(
        _formatMeta,
        format.isAcceptableOrUnknown(data['format']!, _formatMeta),
      );
    }
    if (data.containsKey('sample_rate')) {
      context.handle(
        _sampleRateMeta,
        sampleRate.isAcceptableOrUnknown(data['sample_rate']!, _sampleRateMeta),
      );
    }
    if (data.containsKey('bit_depth')) {
      context.handle(
        _bitDepthMeta,
        bitDepth.isAcceptableOrUnknown(data['bit_depth']!, _bitDepthMeta),
      );
    }
    if (data.containsKey('channels')) {
      context.handle(
        _channelsMeta,
        channels.isAcceptableOrUnknown(data['channels']!, _channelsMeta),
      );
    }
    if (data.containsKey('cover_path')) {
      context.handle(
        _coverPathMeta,
        coverPath.isAcceptableOrUnknown(data['cover_path']!, _coverPathMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    }
    if (data.containsKey('favorite')) {
      context.handle(
        _favoriteMeta,
        favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Track map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Track(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      albumId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}album_id'],
      ),
      albumTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}album_title'],
      ),
      artistId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}artist_id'],
      ),
      artistName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artist_name'],
      ),
      discNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}disc_number'],
      ),
      trackNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}track_number'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      ),
      format: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}format'],
      ),
      sampleRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sample_rate'],
      ),
      bitDepth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bit_depth'],
      ),
      channels: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}channels'],
      ),
      coverPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_path'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      ),
      favorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}favorite'],
      )!,
    );
  }

  @override
  $TracksTable createAlias(String alias) {
    return $TracksTable(attachedDatabase, alias);
  }
}

class Track extends DataClass implements Insertable<Track> {
  final int id;
  final String title;
  final int? albumId;
  final String? albumTitle;
  final int? artistId;
  final String? artistName;
  final int? discNumber;
  final int? trackNumber;
  final int? durationMs;
  final String? filePath;
  final String? format;
  final int? sampleRate;
  final int? bitDepth;
  final int? channels;
  final String? coverPath;
  final String source;
  final String? sourceId;

  /// Marque la piste comme favori (migration v5)
  final bool favorite;
  const Track({
    required this.id,
    required this.title,
    this.albumId,
    this.albumTitle,
    this.artistId,
    this.artistName,
    this.discNumber,
    this.trackNumber,
    this.durationMs,
    this.filePath,
    this.format,
    this.sampleRate,
    this.bitDepth,
    this.channels,
    this.coverPath,
    required this.source,
    this.sourceId,
    required this.favorite,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || albumId != null) {
      map['album_id'] = Variable<int>(albumId);
    }
    if (!nullToAbsent || albumTitle != null) {
      map['album_title'] = Variable<String>(albumTitle);
    }
    if (!nullToAbsent || artistId != null) {
      map['artist_id'] = Variable<int>(artistId);
    }
    if (!nullToAbsent || artistName != null) {
      map['artist_name'] = Variable<String>(artistName);
    }
    if (!nullToAbsent || discNumber != null) {
      map['disc_number'] = Variable<int>(discNumber);
    }
    if (!nullToAbsent || trackNumber != null) {
      map['track_number'] = Variable<int>(trackNumber);
    }
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    if (!nullToAbsent || filePath != null) {
      map['file_path'] = Variable<String>(filePath);
    }
    if (!nullToAbsent || format != null) {
      map['format'] = Variable<String>(format);
    }
    if (!nullToAbsent || sampleRate != null) {
      map['sample_rate'] = Variable<int>(sampleRate);
    }
    if (!nullToAbsent || bitDepth != null) {
      map['bit_depth'] = Variable<int>(bitDepth);
    }
    if (!nullToAbsent || channels != null) {
      map['channels'] = Variable<int>(channels);
    }
    if (!nullToAbsent || coverPath != null) {
      map['cover_path'] = Variable<String>(coverPath);
    }
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || sourceId != null) {
      map['source_id'] = Variable<String>(sourceId);
    }
    map['favorite'] = Variable<bool>(favorite);
    return map;
  }

  TracksCompanion toCompanion(bool nullToAbsent) {
    return TracksCompanion(
      id: Value(id),
      title: Value(title),
      albumId: albumId == null && nullToAbsent
          ? const Value.absent()
          : Value(albumId),
      albumTitle: albumTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(albumTitle),
      artistId: artistId == null && nullToAbsent
          ? const Value.absent()
          : Value(artistId),
      artistName: artistName == null && nullToAbsent
          ? const Value.absent()
          : Value(artistName),
      discNumber: discNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(discNumber),
      trackNumber: trackNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(trackNumber),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      format: format == null && nullToAbsent
          ? const Value.absent()
          : Value(format),
      sampleRate: sampleRate == null && nullToAbsent
          ? const Value.absent()
          : Value(sampleRate),
      bitDepth: bitDepth == null && nullToAbsent
          ? const Value.absent()
          : Value(bitDepth),
      channels: channels == null && nullToAbsent
          ? const Value.absent()
          : Value(channels),
      coverPath: coverPath == null && nullToAbsent
          ? const Value.absent()
          : Value(coverPath),
      source: Value(source),
      sourceId: sourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceId),
      favorite: Value(favorite),
    );
  }

  factory Track.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Track(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      albumId: serializer.fromJson<int?>(json['albumId']),
      albumTitle: serializer.fromJson<String?>(json['albumTitle']),
      artistId: serializer.fromJson<int?>(json['artistId']),
      artistName: serializer.fromJson<String?>(json['artistName']),
      discNumber: serializer.fromJson<int?>(json['discNumber']),
      trackNumber: serializer.fromJson<int?>(json['trackNumber']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      filePath: serializer.fromJson<String?>(json['filePath']),
      format: serializer.fromJson<String?>(json['format']),
      sampleRate: serializer.fromJson<int?>(json['sampleRate']),
      bitDepth: serializer.fromJson<int?>(json['bitDepth']),
      channels: serializer.fromJson<int?>(json['channels']),
      coverPath: serializer.fromJson<String?>(json['coverPath']),
      source: serializer.fromJson<String>(json['source']),
      sourceId: serializer.fromJson<String?>(json['sourceId']),
      favorite: serializer.fromJson<bool>(json['favorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'albumId': serializer.toJson<int?>(albumId),
      'albumTitle': serializer.toJson<String?>(albumTitle),
      'artistId': serializer.toJson<int?>(artistId),
      'artistName': serializer.toJson<String?>(artistName),
      'discNumber': serializer.toJson<int?>(discNumber),
      'trackNumber': serializer.toJson<int?>(trackNumber),
      'durationMs': serializer.toJson<int?>(durationMs),
      'filePath': serializer.toJson<String?>(filePath),
      'format': serializer.toJson<String?>(format),
      'sampleRate': serializer.toJson<int?>(sampleRate),
      'bitDepth': serializer.toJson<int?>(bitDepth),
      'channels': serializer.toJson<int?>(channels),
      'coverPath': serializer.toJson<String?>(coverPath),
      'source': serializer.toJson<String>(source),
      'sourceId': serializer.toJson<String?>(sourceId),
      'favorite': serializer.toJson<bool>(favorite),
    };
  }

  Track copyWith({
    int? id,
    String? title,
    Value<int?> albumId = const Value.absent(),
    Value<String?> albumTitle = const Value.absent(),
    Value<int?> artistId = const Value.absent(),
    Value<String?> artistName = const Value.absent(),
    Value<int?> discNumber = const Value.absent(),
    Value<int?> trackNumber = const Value.absent(),
    Value<int?> durationMs = const Value.absent(),
    Value<String?> filePath = const Value.absent(),
    Value<String?> format = const Value.absent(),
    Value<int?> sampleRate = const Value.absent(),
    Value<int?> bitDepth = const Value.absent(),
    Value<int?> channels = const Value.absent(),
    Value<String?> coverPath = const Value.absent(),
    String? source,
    Value<String?> sourceId = const Value.absent(),
    bool? favorite,
  }) => Track(
    id: id ?? this.id,
    title: title ?? this.title,
    albumId: albumId.present ? albumId.value : this.albumId,
    albumTitle: albumTitle.present ? albumTitle.value : this.albumTitle,
    artistId: artistId.present ? artistId.value : this.artistId,
    artistName: artistName.present ? artistName.value : this.artistName,
    discNumber: discNumber.present ? discNumber.value : this.discNumber,
    trackNumber: trackNumber.present ? trackNumber.value : this.trackNumber,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    filePath: filePath.present ? filePath.value : this.filePath,
    format: format.present ? format.value : this.format,
    sampleRate: sampleRate.present ? sampleRate.value : this.sampleRate,
    bitDepth: bitDepth.present ? bitDepth.value : this.bitDepth,
    channels: channels.present ? channels.value : this.channels,
    coverPath: coverPath.present ? coverPath.value : this.coverPath,
    source: source ?? this.source,
    sourceId: sourceId.present ? sourceId.value : this.sourceId,
    favorite: favorite ?? this.favorite,
  );
  Track copyWithCompanion(TracksCompanion data) {
    return Track(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      albumId: data.albumId.present ? data.albumId.value : this.albumId,
      albumTitle: data.albumTitle.present
          ? data.albumTitle.value
          : this.albumTitle,
      artistId: data.artistId.present ? data.artistId.value : this.artistId,
      artistName: data.artistName.present
          ? data.artistName.value
          : this.artistName,
      discNumber: data.discNumber.present
          ? data.discNumber.value
          : this.discNumber,
      trackNumber: data.trackNumber.present
          ? data.trackNumber.value
          : this.trackNumber,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      format: data.format.present ? data.format.value : this.format,
      sampleRate: data.sampleRate.present
          ? data.sampleRate.value
          : this.sampleRate,
      bitDepth: data.bitDepth.present ? data.bitDepth.value : this.bitDepth,
      channels: data.channels.present ? data.channels.value : this.channels,
      coverPath: data.coverPath.present ? data.coverPath.value : this.coverPath,
      source: data.source.present ? data.source.value : this.source,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Track(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('albumId: $albumId, ')
          ..write('albumTitle: $albumTitle, ')
          ..write('artistId: $artistId, ')
          ..write('artistName: $artistName, ')
          ..write('discNumber: $discNumber, ')
          ..write('trackNumber: $trackNumber, ')
          ..write('durationMs: $durationMs, ')
          ..write('filePath: $filePath, ')
          ..write('format: $format, ')
          ..write('sampleRate: $sampleRate, ')
          ..write('bitDepth: $bitDepth, ')
          ..write('channels: $channels, ')
          ..write('coverPath: $coverPath, ')
          ..write('source: $source, ')
          ..write('sourceId: $sourceId, ')
          ..write('favorite: $favorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    albumId,
    albumTitle,
    artistId,
    artistName,
    discNumber,
    trackNumber,
    durationMs,
    filePath,
    format,
    sampleRate,
    bitDepth,
    channels,
    coverPath,
    source,
    sourceId,
    favorite,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Track &&
          other.id == this.id &&
          other.title == this.title &&
          other.albumId == this.albumId &&
          other.albumTitle == this.albumTitle &&
          other.artistId == this.artistId &&
          other.artistName == this.artistName &&
          other.discNumber == this.discNumber &&
          other.trackNumber == this.trackNumber &&
          other.durationMs == this.durationMs &&
          other.filePath == this.filePath &&
          other.format == this.format &&
          other.sampleRate == this.sampleRate &&
          other.bitDepth == this.bitDepth &&
          other.channels == this.channels &&
          other.coverPath == this.coverPath &&
          other.source == this.source &&
          other.sourceId == this.sourceId &&
          other.favorite == this.favorite);
}

class TracksCompanion extends UpdateCompanion<Track> {
  final Value<int> id;
  final Value<String> title;
  final Value<int?> albumId;
  final Value<String?> albumTitle;
  final Value<int?> artistId;
  final Value<String?> artistName;
  final Value<int?> discNumber;
  final Value<int?> trackNumber;
  final Value<int?> durationMs;
  final Value<String?> filePath;
  final Value<String?> format;
  final Value<int?> sampleRate;
  final Value<int?> bitDepth;
  final Value<int?> channels;
  final Value<String?> coverPath;
  final Value<String> source;
  final Value<String?> sourceId;
  final Value<bool> favorite;
  const TracksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.albumId = const Value.absent(),
    this.albumTitle = const Value.absent(),
    this.artistId = const Value.absent(),
    this.artistName = const Value.absent(),
    this.discNumber = const Value.absent(),
    this.trackNumber = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.filePath = const Value.absent(),
    this.format = const Value.absent(),
    this.sampleRate = const Value.absent(),
    this.bitDepth = const Value.absent(),
    this.channels = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.source = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.favorite = const Value.absent(),
  });
  TracksCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.albumId = const Value.absent(),
    this.albumTitle = const Value.absent(),
    this.artistId = const Value.absent(),
    this.artistName = const Value.absent(),
    this.discNumber = const Value.absent(),
    this.trackNumber = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.filePath = const Value.absent(),
    this.format = const Value.absent(),
    this.sampleRate = const Value.absent(),
    this.bitDepth = const Value.absent(),
    this.channels = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.source = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.favorite = const Value.absent(),
  }) : title = Value(title);
  static Insertable<Track> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? albumId,
    Expression<String>? albumTitle,
    Expression<int>? artistId,
    Expression<String>? artistName,
    Expression<int>? discNumber,
    Expression<int>? trackNumber,
    Expression<int>? durationMs,
    Expression<String>? filePath,
    Expression<String>? format,
    Expression<int>? sampleRate,
    Expression<int>? bitDepth,
    Expression<int>? channels,
    Expression<String>? coverPath,
    Expression<String>? source,
    Expression<String>? sourceId,
    Expression<bool>? favorite,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (albumId != null) 'album_id': albumId,
      if (albumTitle != null) 'album_title': albumTitle,
      if (artistId != null) 'artist_id': artistId,
      if (artistName != null) 'artist_name': artistName,
      if (discNumber != null) 'disc_number': discNumber,
      if (trackNumber != null) 'track_number': trackNumber,
      if (durationMs != null) 'duration_ms': durationMs,
      if (filePath != null) 'file_path': filePath,
      if (format != null) 'format': format,
      if (sampleRate != null) 'sample_rate': sampleRate,
      if (bitDepth != null) 'bit_depth': bitDepth,
      if (channels != null) 'channels': channels,
      if (coverPath != null) 'cover_path': coverPath,
      if (source != null) 'source': source,
      if (sourceId != null) 'source_id': sourceId,
      if (favorite != null) 'favorite': favorite,
    });
  }

  TracksCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<int?>? albumId,
    Value<String?>? albumTitle,
    Value<int?>? artistId,
    Value<String?>? artistName,
    Value<int?>? discNumber,
    Value<int?>? trackNumber,
    Value<int?>? durationMs,
    Value<String?>? filePath,
    Value<String?>? format,
    Value<int?>? sampleRate,
    Value<int?>? bitDepth,
    Value<int?>? channels,
    Value<String?>? coverPath,
    Value<String>? source,
    Value<String?>? sourceId,
    Value<bool>? favorite,
  }) {
    return TracksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      albumId: albumId ?? this.albumId,
      albumTitle: albumTitle ?? this.albumTitle,
      artistId: artistId ?? this.artistId,
      artistName: artistName ?? this.artistName,
      discNumber: discNumber ?? this.discNumber,
      trackNumber: trackNumber ?? this.trackNumber,
      durationMs: durationMs ?? this.durationMs,
      filePath: filePath ?? this.filePath,
      format: format ?? this.format,
      sampleRate: sampleRate ?? this.sampleRate,
      bitDepth: bitDepth ?? this.bitDepth,
      channels: channels ?? this.channels,
      coverPath: coverPath ?? this.coverPath,
      source: source ?? this.source,
      sourceId: sourceId ?? this.sourceId,
      favorite: favorite ?? this.favorite,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (albumId.present) {
      map['album_id'] = Variable<int>(albumId.value);
    }
    if (albumTitle.present) {
      map['album_title'] = Variable<String>(albumTitle.value);
    }
    if (artistId.present) {
      map['artist_id'] = Variable<int>(artistId.value);
    }
    if (artistName.present) {
      map['artist_name'] = Variable<String>(artistName.value);
    }
    if (discNumber.present) {
      map['disc_number'] = Variable<int>(discNumber.value);
    }
    if (trackNumber.present) {
      map['track_number'] = Variable<int>(trackNumber.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (format.present) {
      map['format'] = Variable<String>(format.value);
    }
    if (sampleRate.present) {
      map['sample_rate'] = Variable<int>(sampleRate.value);
    }
    if (bitDepth.present) {
      map['bit_depth'] = Variable<int>(bitDepth.value);
    }
    if (channels.present) {
      map['channels'] = Variable<int>(channels.value);
    }
    if (coverPath.present) {
      map['cover_path'] = Variable<String>(coverPath.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TracksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('albumId: $albumId, ')
          ..write('albumTitle: $albumTitle, ')
          ..write('artistId: $artistId, ')
          ..write('artistName: $artistName, ')
          ..write('discNumber: $discNumber, ')
          ..write('trackNumber: $trackNumber, ')
          ..write('durationMs: $durationMs, ')
          ..write('filePath: $filePath, ')
          ..write('format: $format, ')
          ..write('sampleRate: $sampleRate, ')
          ..write('bitDepth: $bitDepth, ')
          ..write('channels: $channels, ')
          ..write('coverPath: $coverPath, ')
          ..write('source: $source, ')
          ..write('sourceId: $sourceId, ')
          ..write('favorite: $favorite')
          ..write(')'))
        .toString();
  }
}

class $PlaylistsTable extends Playlists
    with TableInfo<$PlaylistsTable, Playlist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trackCountMeta = const VerificationMeta(
    'trackCount',
  );
  @override
  late final GeneratedColumn<int> trackCount = GeneratedColumn<int>(
    'track_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, description, trackCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlists';
  @override
  VerificationContext validateIntegrity(
    Insertable<Playlist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('track_count')) {
      context.handle(
        _trackCountMeta,
        trackCount.isAcceptableOrUnknown(data['track_count']!, _trackCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Playlist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Playlist(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      trackCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}track_count'],
      )!,
    );
  }

  @override
  $PlaylistsTable createAlias(String alias) {
    return $PlaylistsTable(attachedDatabase, alias);
  }
}

class Playlist extends DataClass implements Insertable<Playlist> {
  final int id;
  final String name;
  final String? description;
  final int trackCount;
  const Playlist({
    required this.id,
    required this.name,
    this.description,
    required this.trackCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['track_count'] = Variable<int>(trackCount);
    return map;
  }

  PlaylistsCompanion toCompanion(bool nullToAbsent) {
    return PlaylistsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      trackCount: Value(trackCount),
    );
  }

  factory Playlist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Playlist(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      trackCount: serializer.fromJson<int>(json['trackCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'trackCount': serializer.toJson<int>(trackCount),
    };
  }

  Playlist copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    int? trackCount,
  }) => Playlist(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    trackCount: trackCount ?? this.trackCount,
  );
  Playlist copyWithCompanion(PlaylistsCompanion data) {
    return Playlist(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      trackCount: data.trackCount.present
          ? data.trackCount.value
          : this.trackCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Playlist(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('trackCount: $trackCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, trackCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Playlist &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.trackCount == this.trackCount);
}

class PlaylistsCompanion extends UpdateCompanion<Playlist> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> trackCount;
  const PlaylistsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.trackCount = const Value.absent(),
  });
  PlaylistsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.trackCount = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Playlist> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? trackCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (trackCount != null) 'track_count': trackCount,
    });
  }

  PlaylistsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<int>? trackCount,
  }) {
    return PlaylistsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      trackCount: trackCount ?? this.trackCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (trackCount.present) {
      map['track_count'] = Variable<int>(trackCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('trackCount: $trackCount')
          ..write(')'))
        .toString();
  }
}

class $PlaylistTracksTable extends PlaylistTracks
    with TableInfo<$PlaylistTracksTable, PlaylistTrack> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistTracksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _playlistIdMeta = const VerificationMeta(
    'playlistId',
  );
  @override
  late final GeneratedColumn<int> playlistId = GeneratedColumn<int>(
    'playlist_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES playlists (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _trackIdMeta = const VerificationMeta(
    'trackId',
  );
  @override
  late final GeneratedColumn<int> trackId = GeneratedColumn<int>(
    'track_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tracks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, playlistId, trackId, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlist_tracks';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlaylistTrack> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('playlist_id')) {
      context.handle(
        _playlistIdMeta,
        playlistId.isAcceptableOrUnknown(data['playlist_id']!, _playlistIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playlistIdMeta);
    }
    if (data.containsKey('track_id')) {
      context.handle(
        _trackIdMeta,
        trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaylistTrack map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistTrack(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      playlistId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}playlist_id'],
      )!,
      trackId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}track_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $PlaylistTracksTable createAlias(String alias) {
    return $PlaylistTracksTable(attachedDatabase, alias);
  }
}

class PlaylistTrack extends DataClass implements Insertable<PlaylistTrack> {
  final int id;
  final int playlistId;
  final int trackId;
  final int position;
  const PlaylistTrack({
    required this.id,
    required this.playlistId,
    required this.trackId,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['playlist_id'] = Variable<int>(playlistId);
    map['track_id'] = Variable<int>(trackId);
    map['position'] = Variable<int>(position);
    return map;
  }

  PlaylistTracksCompanion toCompanion(bool nullToAbsent) {
    return PlaylistTracksCompanion(
      id: Value(id),
      playlistId: Value(playlistId),
      trackId: Value(trackId),
      position: Value(position),
    );
  }

  factory PlaylistTrack.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaylistTrack(
      id: serializer.fromJson<int>(json['id']),
      playlistId: serializer.fromJson<int>(json['playlistId']),
      trackId: serializer.fromJson<int>(json['trackId']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'playlistId': serializer.toJson<int>(playlistId),
      'trackId': serializer.toJson<int>(trackId),
      'position': serializer.toJson<int>(position),
    };
  }

  PlaylistTrack copyWith({
    int? id,
    int? playlistId,
    int? trackId,
    int? position,
  }) => PlaylistTrack(
    id: id ?? this.id,
    playlistId: playlistId ?? this.playlistId,
    trackId: trackId ?? this.trackId,
    position: position ?? this.position,
  );
  PlaylistTrack copyWithCompanion(PlaylistTracksCompanion data) {
    return PlaylistTrack(
      id: data.id.present ? data.id.value : this.id,
      playlistId: data.playlistId.present
          ? data.playlistId.value
          : this.playlistId,
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistTrack(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('trackId: $trackId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, playlistId, trackId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaylistTrack &&
          other.id == this.id &&
          other.playlistId == this.playlistId &&
          other.trackId == this.trackId &&
          other.position == this.position);
}

class PlaylistTracksCompanion extends UpdateCompanion<PlaylistTrack> {
  final Value<int> id;
  final Value<int> playlistId;
  final Value<int> trackId;
  final Value<int> position;
  const PlaylistTracksCompanion({
    this.id = const Value.absent(),
    this.playlistId = const Value.absent(),
    this.trackId = const Value.absent(),
    this.position = const Value.absent(),
  });
  PlaylistTracksCompanion.insert({
    this.id = const Value.absent(),
    required int playlistId,
    required int trackId,
    required int position,
  }) : playlistId = Value(playlistId),
       trackId = Value(trackId),
       position = Value(position);
  static Insertable<PlaylistTrack> custom({
    Expression<int>? id,
    Expression<int>? playlistId,
    Expression<int>? trackId,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (playlistId != null) 'playlist_id': playlistId,
      if (trackId != null) 'track_id': trackId,
      if (position != null) 'position': position,
    });
  }

  PlaylistTracksCompanion copyWith({
    Value<int>? id,
    Value<int>? playlistId,
    Value<int>? trackId,
    Value<int>? position,
  }) {
    return PlaylistTracksCompanion(
      id: id ?? this.id,
      playlistId: playlistId ?? this.playlistId,
      trackId: trackId ?? this.trackId,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (playlistId.present) {
      map['playlist_id'] = Variable<int>(playlistId.value);
    }
    if (trackId.present) {
      map['track_id'] = Variable<int>(trackId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistTracksCompanion(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('trackId: $trackId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $ZonesTable extends Zones with TableInfo<$ZonesTable, Zone> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ZonesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outputTypeMeta = const VerificationMeta(
    'outputType',
  );
  @override
  late final GeneratedColumn<String> outputType = GeneratedColumn<String>(
    'output_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _outputDeviceIdMeta = const VerificationMeta(
    'outputDeviceId',
  );
  @override
  late final GeneratedColumn<String> outputDeviceId = GeneratedColumn<String>(
    'output_device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _volumeMeta = const VerificationMeta('volume');
  @override
  late final GeneratedColumn<double> volume = GeneratedColumn<double>(
    'volume',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.5),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncDelayMsMeta = const VerificationMeta(
    'syncDelayMs',
  );
  @override
  late final GeneratedColumn<int> syncDelayMs = GeneratedColumn<int>(
    'sync_delay_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    outputType,
    outputDeviceId,
    volume,
    groupId,
    syncDelayMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'zones';
  @override
  VerificationContext validateIntegrity(
    Insertable<Zone> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('output_type')) {
      context.handle(
        _outputTypeMeta,
        outputType.isAcceptableOrUnknown(data['output_type']!, _outputTypeMeta),
      );
    }
    if (data.containsKey('output_device_id')) {
      context.handle(
        _outputDeviceIdMeta,
        outputDeviceId.isAcceptableOrUnknown(
          data['output_device_id']!,
          _outputDeviceIdMeta,
        ),
      );
    }
    if (data.containsKey('volume')) {
      context.handle(
        _volumeMeta,
        volume.isAcceptableOrUnknown(data['volume']!, _volumeMeta),
      );
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    }
    if (data.containsKey('sync_delay_ms')) {
      context.handle(
        _syncDelayMsMeta,
        syncDelayMs.isAcceptableOrUnknown(
          data['sync_delay_ms']!,
          _syncDelayMsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Zone map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Zone(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      outputType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}output_type'],
      ),
      outputDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}output_device_id'],
      ),
      volume: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}volume'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      ),
      syncDelayMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_delay_ms'],
      )!,
    );
  }

  @override
  $ZonesTable createAlias(String alias) {
    return $ZonesTable(attachedDatabase, alias);
  }
}

class Zone extends DataClass implements Insertable<Zone> {
  final int id;
  final String name;
  final String? outputType;
  final String? outputDeviceId;
  final double volume;
  final String? groupId;
  final int syncDelayMs;
  const Zone({
    required this.id,
    required this.name,
    this.outputType,
    this.outputDeviceId,
    required this.volume,
    this.groupId,
    required this.syncDelayMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || outputType != null) {
      map['output_type'] = Variable<String>(outputType);
    }
    if (!nullToAbsent || outputDeviceId != null) {
      map['output_device_id'] = Variable<String>(outputDeviceId);
    }
    map['volume'] = Variable<double>(volume);
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<String>(groupId);
    }
    map['sync_delay_ms'] = Variable<int>(syncDelayMs);
    return map;
  }

  ZonesCompanion toCompanion(bool nullToAbsent) {
    return ZonesCompanion(
      id: Value(id),
      name: Value(name),
      outputType: outputType == null && nullToAbsent
          ? const Value.absent()
          : Value(outputType),
      outputDeviceId: outputDeviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(outputDeviceId),
      volume: Value(volume),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      syncDelayMs: Value(syncDelayMs),
    );
  }

  factory Zone.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Zone(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      outputType: serializer.fromJson<String?>(json['outputType']),
      outputDeviceId: serializer.fromJson<String?>(json['outputDeviceId']),
      volume: serializer.fromJson<double>(json['volume']),
      groupId: serializer.fromJson<String?>(json['groupId']),
      syncDelayMs: serializer.fromJson<int>(json['syncDelayMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'outputType': serializer.toJson<String?>(outputType),
      'outputDeviceId': serializer.toJson<String?>(outputDeviceId),
      'volume': serializer.toJson<double>(volume),
      'groupId': serializer.toJson<String?>(groupId),
      'syncDelayMs': serializer.toJson<int>(syncDelayMs),
    };
  }

  Zone copyWith({
    int? id,
    String? name,
    Value<String?> outputType = const Value.absent(),
    Value<String?> outputDeviceId = const Value.absent(),
    double? volume,
    Value<String?> groupId = const Value.absent(),
    int? syncDelayMs,
  }) => Zone(
    id: id ?? this.id,
    name: name ?? this.name,
    outputType: outputType.present ? outputType.value : this.outputType,
    outputDeviceId: outputDeviceId.present
        ? outputDeviceId.value
        : this.outputDeviceId,
    volume: volume ?? this.volume,
    groupId: groupId.present ? groupId.value : this.groupId,
    syncDelayMs: syncDelayMs ?? this.syncDelayMs,
  );
  Zone copyWithCompanion(ZonesCompanion data) {
    return Zone(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      outputType: data.outputType.present
          ? data.outputType.value
          : this.outputType,
      outputDeviceId: data.outputDeviceId.present
          ? data.outputDeviceId.value
          : this.outputDeviceId,
      volume: data.volume.present ? data.volume.value : this.volume,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      syncDelayMs: data.syncDelayMs.present
          ? data.syncDelayMs.value
          : this.syncDelayMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Zone(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('outputType: $outputType, ')
          ..write('outputDeviceId: $outputDeviceId, ')
          ..write('volume: $volume, ')
          ..write('groupId: $groupId, ')
          ..write('syncDelayMs: $syncDelayMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    outputType,
    outputDeviceId,
    volume,
    groupId,
    syncDelayMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Zone &&
          other.id == this.id &&
          other.name == this.name &&
          other.outputType == this.outputType &&
          other.outputDeviceId == this.outputDeviceId &&
          other.volume == this.volume &&
          other.groupId == this.groupId &&
          other.syncDelayMs == this.syncDelayMs);
}

class ZonesCompanion extends UpdateCompanion<Zone> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> outputType;
  final Value<String?> outputDeviceId;
  final Value<double> volume;
  final Value<String?> groupId;
  final Value<int> syncDelayMs;
  const ZonesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.outputType = const Value.absent(),
    this.outputDeviceId = const Value.absent(),
    this.volume = const Value.absent(),
    this.groupId = const Value.absent(),
    this.syncDelayMs = const Value.absent(),
  });
  ZonesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.outputType = const Value.absent(),
    this.outputDeviceId = const Value.absent(),
    this.volume = const Value.absent(),
    this.groupId = const Value.absent(),
    this.syncDelayMs = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Zone> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? outputType,
    Expression<String>? outputDeviceId,
    Expression<double>? volume,
    Expression<String>? groupId,
    Expression<int>? syncDelayMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (outputType != null) 'output_type': outputType,
      if (outputDeviceId != null) 'output_device_id': outputDeviceId,
      if (volume != null) 'volume': volume,
      if (groupId != null) 'group_id': groupId,
      if (syncDelayMs != null) 'sync_delay_ms': syncDelayMs,
    });
  }

  ZonesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? outputType,
    Value<String?>? outputDeviceId,
    Value<double>? volume,
    Value<String?>? groupId,
    Value<int>? syncDelayMs,
  }) {
    return ZonesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      outputType: outputType ?? this.outputType,
      outputDeviceId: outputDeviceId ?? this.outputDeviceId,
      volume: volume ?? this.volume,
      groupId: groupId ?? this.groupId,
      syncDelayMs: syncDelayMs ?? this.syncDelayMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (outputType.present) {
      map['output_type'] = Variable<String>(outputType.value);
    }
    if (outputDeviceId.present) {
      map['output_device_id'] = Variable<String>(outputDeviceId.value);
    }
    if (volume.present) {
      map['volume'] = Variable<double>(volume.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (syncDelayMs.present) {
      map['sync_delay_ms'] = Variable<int>(syncDelayMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ZonesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('outputType: $outputType, ')
          ..write('outputDeviceId: $outputDeviceId, ')
          ..write('volume: $volume, ')
          ..write('groupId: $groupId, ')
          ..write('syncDelayMs: $syncDelayMs')
          ..write(')'))
        .toString();
  }
}

class $QueueItemsTable extends QueueItems
    with TableInfo<$QueueItemsTable, QueueItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QueueItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _zoneIdMeta = const VerificationMeta('zoneId');
  @override
  late final GeneratedColumn<int> zoneId = GeneratedColumn<int>(
    'zone_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES zones (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _trackIdMeta = const VerificationMeta(
    'trackId',
  );
  @override
  late final GeneratedColumn<int> trackId = GeneratedColumn<int>(
    'track_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, zoneId, trackId, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'queue_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<QueueItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('zone_id')) {
      context.handle(
        _zoneIdMeta,
        zoneId.isAcceptableOrUnknown(data['zone_id']!, _zoneIdMeta),
      );
    } else if (isInserting) {
      context.missing(_zoneIdMeta);
    }
    if (data.containsKey('track_id')) {
      context.handle(
        _trackIdMeta,
        trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QueueItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QueueItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      zoneId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}zone_id'],
      )!,
      trackId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}track_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $QueueItemsTable createAlias(String alias) {
    return $QueueItemsTable(attachedDatabase, alias);
  }
}

class QueueItem extends DataClass implements Insertable<QueueItem> {
  final int id;
  final int zoneId;
  final int trackId;
  final int position;
  const QueueItem({
    required this.id,
    required this.zoneId,
    required this.trackId,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['zone_id'] = Variable<int>(zoneId);
    map['track_id'] = Variable<int>(trackId);
    map['position'] = Variable<int>(position);
    return map;
  }

  QueueItemsCompanion toCompanion(bool nullToAbsent) {
    return QueueItemsCompanion(
      id: Value(id),
      zoneId: Value(zoneId),
      trackId: Value(trackId),
      position: Value(position),
    );
  }

  factory QueueItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QueueItem(
      id: serializer.fromJson<int>(json['id']),
      zoneId: serializer.fromJson<int>(json['zoneId']),
      trackId: serializer.fromJson<int>(json['trackId']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'zoneId': serializer.toJson<int>(zoneId),
      'trackId': serializer.toJson<int>(trackId),
      'position': serializer.toJson<int>(position),
    };
  }

  QueueItem copyWith({int? id, int? zoneId, int? trackId, int? position}) =>
      QueueItem(
        id: id ?? this.id,
        zoneId: zoneId ?? this.zoneId,
        trackId: trackId ?? this.trackId,
        position: position ?? this.position,
      );
  QueueItem copyWithCompanion(QueueItemsCompanion data) {
    return QueueItem(
      id: data.id.present ? data.id.value : this.id,
      zoneId: data.zoneId.present ? data.zoneId.value : this.zoneId,
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QueueItem(')
          ..write('id: $id, ')
          ..write('zoneId: $zoneId, ')
          ..write('trackId: $trackId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, zoneId, trackId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QueueItem &&
          other.id == this.id &&
          other.zoneId == this.zoneId &&
          other.trackId == this.trackId &&
          other.position == this.position);
}

class QueueItemsCompanion extends UpdateCompanion<QueueItem> {
  final Value<int> id;
  final Value<int> zoneId;
  final Value<int> trackId;
  final Value<int> position;
  const QueueItemsCompanion({
    this.id = const Value.absent(),
    this.zoneId = const Value.absent(),
    this.trackId = const Value.absent(),
    this.position = const Value.absent(),
  });
  QueueItemsCompanion.insert({
    this.id = const Value.absent(),
    required int zoneId,
    required int trackId,
    required int position,
  }) : zoneId = Value(zoneId),
       trackId = Value(trackId),
       position = Value(position);
  static Insertable<QueueItem> custom({
    Expression<int>? id,
    Expression<int>? zoneId,
    Expression<int>? trackId,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (zoneId != null) 'zone_id': zoneId,
      if (trackId != null) 'track_id': trackId,
      if (position != null) 'position': position,
    });
  }

  QueueItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? zoneId,
    Value<int>? trackId,
    Value<int>? position,
  }) {
    return QueueItemsCompanion(
      id: id ?? this.id,
      zoneId: zoneId ?? this.zoneId,
      trackId: trackId ?? this.trackId,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (zoneId.present) {
      map['zone_id'] = Variable<int>(zoneId.value);
    }
    if (trackId.present) {
      map['track_id'] = Variable<int>(trackId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QueueItemsCompanion(')
          ..write('id: $id, ')
          ..write('zoneId: $zoneId, ')
          ..write('trackId: $trackId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $RadiosTable extends Radios with TableInfo<$RadiosTable, Radio> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RadiosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _streamUrlMeta = const VerificationMeta(
    'streamUrl',
  );
  @override
  late final GeneratedColumn<String> streamUrl = GeneratedColumn<String>(
    'stream_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _logoUrlMeta = const VerificationMeta(
    'logoUrl',
  );
  @override
  late final GeneratedColumn<String> logoUrl = GeneratedColumn<String>(
    'logo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genreMeta = const VerificationMeta('genre');
  @override
  late final GeneratedColumn<String> genre = GeneratedColumn<String>(
    'genre',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _codecMeta = const VerificationMeta('codec');
  @override
  late final GeneratedColumn<String> codec = GeneratedColumn<String>(
    'codec',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _homepageUrlMeta = const VerificationMeta(
    'homepageUrl',
  );
  @override
  late final GeneratedColumn<String> homepageUrl = GeneratedColumn<String>(
    'homepage_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _favoriteMeta = const VerificationMeta(
    'favorite',
  );
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
    'favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    streamUrl,
    logoUrl,
    genre,
    tags,
    codec,
    country,
    homepageUrl,
    favorite,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'radios';
  @override
  VerificationContext validateIntegrity(
    Insertable<Radio> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('stream_url')) {
      context.handle(
        _streamUrlMeta,
        streamUrl.isAcceptableOrUnknown(data['stream_url']!, _streamUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_streamUrlMeta);
    }
    if (data.containsKey('logo_url')) {
      context.handle(
        _logoUrlMeta,
        logoUrl.isAcceptableOrUnknown(data['logo_url']!, _logoUrlMeta),
      );
    }
    if (data.containsKey('genre')) {
      context.handle(
        _genreMeta,
        genre.isAcceptableOrUnknown(data['genre']!, _genreMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('codec')) {
      context.handle(
        _codecMeta,
        codec.isAcceptableOrUnknown(data['codec']!, _codecMeta),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    }
    if (data.containsKey('homepage_url')) {
      context.handle(
        _homepageUrlMeta,
        homepageUrl.isAcceptableOrUnknown(
          data['homepage_url']!,
          _homepageUrlMeta,
        ),
      );
    }
    if (data.containsKey('favorite')) {
      context.handle(
        _favoriteMeta,
        favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Radio map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Radio(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      streamUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stream_url'],
      )!,
      logoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_url'],
      ),
      genre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genre'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      codec: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codec'],
      ),
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      ),
      homepageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}homepage_url'],
      ),
      favorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}favorite'],
      )!,
    );
  }

  @override
  $RadiosTable createAlias(String alias) {
    return $RadiosTable(attachedDatabase, alias);
  }
}

class Radio extends DataClass implements Insertable<Radio> {
  final int id;
  final String name;
  final String streamUrl;
  final String? logoUrl;
  final String? genre;
  final String? tags;
  final String? codec;
  final String? country;
  final String? homepageUrl;
  final bool favorite;
  const Radio({
    required this.id,
    required this.name,
    required this.streamUrl,
    this.logoUrl,
    this.genre,
    this.tags,
    this.codec,
    this.country,
    this.homepageUrl,
    required this.favorite,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['stream_url'] = Variable<String>(streamUrl);
    if (!nullToAbsent || logoUrl != null) {
      map['logo_url'] = Variable<String>(logoUrl);
    }
    if (!nullToAbsent || genre != null) {
      map['genre'] = Variable<String>(genre);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    if (!nullToAbsent || codec != null) {
      map['codec'] = Variable<String>(codec);
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    if (!nullToAbsent || homepageUrl != null) {
      map['homepage_url'] = Variable<String>(homepageUrl);
    }
    map['favorite'] = Variable<bool>(favorite);
    return map;
  }

  RadiosCompanion toCompanion(bool nullToAbsent) {
    return RadiosCompanion(
      id: Value(id),
      name: Value(name),
      streamUrl: Value(streamUrl),
      logoUrl: logoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(logoUrl),
      genre: genre == null && nullToAbsent
          ? const Value.absent()
          : Value(genre),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      codec: codec == null && nullToAbsent
          ? const Value.absent()
          : Value(codec),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      homepageUrl: homepageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(homepageUrl),
      favorite: Value(favorite),
    );
  }

  factory Radio.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Radio(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      streamUrl: serializer.fromJson<String>(json['streamUrl']),
      logoUrl: serializer.fromJson<String?>(json['logoUrl']),
      genre: serializer.fromJson<String?>(json['genre']),
      tags: serializer.fromJson<String?>(json['tags']),
      codec: serializer.fromJson<String?>(json['codec']),
      country: serializer.fromJson<String?>(json['country']),
      homepageUrl: serializer.fromJson<String?>(json['homepageUrl']),
      favorite: serializer.fromJson<bool>(json['favorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'streamUrl': serializer.toJson<String>(streamUrl),
      'logoUrl': serializer.toJson<String?>(logoUrl),
      'genre': serializer.toJson<String?>(genre),
      'tags': serializer.toJson<String?>(tags),
      'codec': serializer.toJson<String?>(codec),
      'country': serializer.toJson<String?>(country),
      'homepageUrl': serializer.toJson<String?>(homepageUrl),
      'favorite': serializer.toJson<bool>(favorite),
    };
  }

  Radio copyWith({
    int? id,
    String? name,
    String? streamUrl,
    Value<String?> logoUrl = const Value.absent(),
    Value<String?> genre = const Value.absent(),
    Value<String?> tags = const Value.absent(),
    Value<String?> codec = const Value.absent(),
    Value<String?> country = const Value.absent(),
    Value<String?> homepageUrl = const Value.absent(),
    bool? favorite,
  }) => Radio(
    id: id ?? this.id,
    name: name ?? this.name,
    streamUrl: streamUrl ?? this.streamUrl,
    logoUrl: logoUrl.present ? logoUrl.value : this.logoUrl,
    genre: genre.present ? genre.value : this.genre,
    tags: tags.present ? tags.value : this.tags,
    codec: codec.present ? codec.value : this.codec,
    country: country.present ? country.value : this.country,
    homepageUrl: homepageUrl.present ? homepageUrl.value : this.homepageUrl,
    favorite: favorite ?? this.favorite,
  );
  Radio copyWithCompanion(RadiosCompanion data) {
    return Radio(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      streamUrl: data.streamUrl.present ? data.streamUrl.value : this.streamUrl,
      logoUrl: data.logoUrl.present ? data.logoUrl.value : this.logoUrl,
      genre: data.genre.present ? data.genre.value : this.genre,
      tags: data.tags.present ? data.tags.value : this.tags,
      codec: data.codec.present ? data.codec.value : this.codec,
      country: data.country.present ? data.country.value : this.country,
      homepageUrl: data.homepageUrl.present
          ? data.homepageUrl.value
          : this.homepageUrl,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Radio(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('streamUrl: $streamUrl, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('genre: $genre, ')
          ..write('tags: $tags, ')
          ..write('codec: $codec, ')
          ..write('country: $country, ')
          ..write('homepageUrl: $homepageUrl, ')
          ..write('favorite: $favorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    streamUrl,
    logoUrl,
    genre,
    tags,
    codec,
    country,
    homepageUrl,
    favorite,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Radio &&
          other.id == this.id &&
          other.name == this.name &&
          other.streamUrl == this.streamUrl &&
          other.logoUrl == this.logoUrl &&
          other.genre == this.genre &&
          other.tags == this.tags &&
          other.codec == this.codec &&
          other.country == this.country &&
          other.homepageUrl == this.homepageUrl &&
          other.favorite == this.favorite);
}

class RadiosCompanion extends UpdateCompanion<Radio> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> streamUrl;
  final Value<String?> logoUrl;
  final Value<String?> genre;
  final Value<String?> tags;
  final Value<String?> codec;
  final Value<String?> country;
  final Value<String?> homepageUrl;
  final Value<bool> favorite;
  const RadiosCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.streamUrl = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.genre = const Value.absent(),
    this.tags = const Value.absent(),
    this.codec = const Value.absent(),
    this.country = const Value.absent(),
    this.homepageUrl = const Value.absent(),
    this.favorite = const Value.absent(),
  });
  RadiosCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String streamUrl,
    this.logoUrl = const Value.absent(),
    this.genre = const Value.absent(),
    this.tags = const Value.absent(),
    this.codec = const Value.absent(),
    this.country = const Value.absent(),
    this.homepageUrl = const Value.absent(),
    this.favorite = const Value.absent(),
  }) : name = Value(name),
       streamUrl = Value(streamUrl);
  static Insertable<Radio> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? streamUrl,
    Expression<String>? logoUrl,
    Expression<String>? genre,
    Expression<String>? tags,
    Expression<String>? codec,
    Expression<String>? country,
    Expression<String>? homepageUrl,
    Expression<bool>? favorite,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (streamUrl != null) 'stream_url': streamUrl,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (genre != null) 'genre': genre,
      if (tags != null) 'tags': tags,
      if (codec != null) 'codec': codec,
      if (country != null) 'country': country,
      if (homepageUrl != null) 'homepage_url': homepageUrl,
      if (favorite != null) 'favorite': favorite,
    });
  }

  RadiosCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? streamUrl,
    Value<String?>? logoUrl,
    Value<String?>? genre,
    Value<String?>? tags,
    Value<String?>? codec,
    Value<String?>? country,
    Value<String?>? homepageUrl,
    Value<bool>? favorite,
  }) {
    return RadiosCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      streamUrl: streamUrl ?? this.streamUrl,
      logoUrl: logoUrl ?? this.logoUrl,
      genre: genre ?? this.genre,
      tags: tags ?? this.tags,
      codec: codec ?? this.codec,
      country: country ?? this.country,
      homepageUrl: homepageUrl ?? this.homepageUrl,
      favorite: favorite ?? this.favorite,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (streamUrl.present) {
      map['stream_url'] = Variable<String>(streamUrl.value);
    }
    if (logoUrl.present) {
      map['logo_url'] = Variable<String>(logoUrl.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (codec.present) {
      map['codec'] = Variable<String>(codec.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (homepageUrl.present) {
      map['homepage_url'] = Variable<String>(homepageUrl.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RadiosCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('streamUrl: $streamUrl, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('genre: $genre, ')
          ..write('tags: $tags, ')
          ..write('codec: $codec, ')
          ..write('country: $country, ')
          ..write('homepageUrl: $homepageUrl, ')
          ..write('favorite: $favorite')
          ..write(')'))
        .toString();
  }
}

class $MusicFoldersTable extends MusicFolders
    with TableInfo<$MusicFoldersTable, MusicFolder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MusicFoldersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _bookmarkDataMeta = const VerificationMeta(
    'bookmarkData',
  );
  @override
  late final GeneratedColumn<Uint8List> bookmarkData =
      GeneratedColumn<Uint8List>(
        'bookmark_data',
        aliasedName,
        true,
        type: DriftSqlType.blob,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<String> addedAt = GeneratedColumn<String>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, path, bookmarkData, addedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'music_folders';
  @override
  VerificationContext validateIntegrity(
    Insertable<MusicFolder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('bookmark_data')) {
      context.handle(
        _bookmarkDataMeta,
        bookmarkData.isAcceptableOrUnknown(
          data['bookmark_data']!,
          _bookmarkDataMeta,
        ),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MusicFolder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MusicFolder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      bookmarkData: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}bookmark_data'],
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $MusicFoldersTable createAlias(String alias) {
    return $MusicFoldersTable(attachedDatabase, alias);
  }
}

class MusicFolder extends DataClass implements Insertable<MusicFolder> {
  final int id;
  final String path;
  final Uint8List? bookmarkData;
  final String addedAt;
  const MusicFolder({
    required this.id,
    required this.path,
    this.bookmarkData,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['path'] = Variable<String>(path);
    if (!nullToAbsent || bookmarkData != null) {
      map['bookmark_data'] = Variable<Uint8List>(bookmarkData);
    }
    map['added_at'] = Variable<String>(addedAt);
    return map;
  }

  MusicFoldersCompanion toCompanion(bool nullToAbsent) {
    return MusicFoldersCompanion(
      id: Value(id),
      path: Value(path),
      bookmarkData: bookmarkData == null && nullToAbsent
          ? const Value.absent()
          : Value(bookmarkData),
      addedAt: Value(addedAt),
    );
  }

  factory MusicFolder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MusicFolder(
      id: serializer.fromJson<int>(json['id']),
      path: serializer.fromJson<String>(json['path']),
      bookmarkData: serializer.fromJson<Uint8List?>(json['bookmarkData']),
      addedAt: serializer.fromJson<String>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'path': serializer.toJson<String>(path),
      'bookmarkData': serializer.toJson<Uint8List?>(bookmarkData),
      'addedAt': serializer.toJson<String>(addedAt),
    };
  }

  MusicFolder copyWith({
    int? id,
    String? path,
    Value<Uint8List?> bookmarkData = const Value.absent(),
    String? addedAt,
  }) => MusicFolder(
    id: id ?? this.id,
    path: path ?? this.path,
    bookmarkData: bookmarkData.present ? bookmarkData.value : this.bookmarkData,
    addedAt: addedAt ?? this.addedAt,
  );
  MusicFolder copyWithCompanion(MusicFoldersCompanion data) {
    return MusicFolder(
      id: data.id.present ? data.id.value : this.id,
      path: data.path.present ? data.path.value : this.path,
      bookmarkData: data.bookmarkData.present
          ? data.bookmarkData.value
          : this.bookmarkData,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MusicFolder(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('bookmarkData: $bookmarkData, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, path, $driftBlobEquality.hash(bookmarkData), addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MusicFolder &&
          other.id == this.id &&
          other.path == this.path &&
          $driftBlobEquality.equals(other.bookmarkData, this.bookmarkData) &&
          other.addedAt == this.addedAt);
}

class MusicFoldersCompanion extends UpdateCompanion<MusicFolder> {
  final Value<int> id;
  final Value<String> path;
  final Value<Uint8List?> bookmarkData;
  final Value<String> addedAt;
  const MusicFoldersCompanion({
    this.id = const Value.absent(),
    this.path = const Value.absent(),
    this.bookmarkData = const Value.absent(),
    this.addedAt = const Value.absent(),
  });
  MusicFoldersCompanion.insert({
    this.id = const Value.absent(),
    required String path,
    this.bookmarkData = const Value.absent(),
    required String addedAt,
  }) : path = Value(path),
       addedAt = Value(addedAt);
  static Insertable<MusicFolder> custom({
    Expression<int>? id,
    Expression<String>? path,
    Expression<Uint8List>? bookmarkData,
    Expression<String>? addedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (path != null) 'path': path,
      if (bookmarkData != null) 'bookmark_data': bookmarkData,
      if (addedAt != null) 'added_at': addedAt,
    });
  }

  MusicFoldersCompanion copyWith({
    Value<int>? id,
    Value<String>? path,
    Value<Uint8List?>? bookmarkData,
    Value<String>? addedAt,
  }) {
    return MusicFoldersCompanion(
      id: id ?? this.id,
      path: path ?? this.path,
      bookmarkData: bookmarkData ?? this.bookmarkData,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (bookmarkData.present) {
      map['bookmark_data'] = Variable<Uint8List>(bookmarkData.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<String>(addedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MusicFoldersCompanion(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('bookmarkData: $bookmarkData, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }
}

class $SavedDevicesTable extends SavedDevices
    with TableInfo<$SavedDevicesTable, SavedDevice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedDevicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hostMeta = const VerificationMeta('host');
  @override
  late final GeneratedColumn<String> host = GeneratedColumn<String>(
    'host',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
    'port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capabilitiesJsonMeta = const VerificationMeta(
    'capabilitiesJson',
  );
  @override
  late final GeneratedColumn<String> capabilitiesJson = GeneratedColumn<String>(
    'capabilities_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<String> addedAt = GeneratedColumn<String>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    deviceId,
    name,
    type,
    host,
    port,
    capabilitiesJson,
    addedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_devices';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedDevice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('host')) {
      context.handle(
        _hostMeta,
        host.isAcceptableOrUnknown(data['host']!, _hostMeta),
      );
    } else if (isInserting) {
      context.missing(_hostMeta);
    }
    if (data.containsKey('port')) {
      context.handle(
        _portMeta,
        port.isAcceptableOrUnknown(data['port']!, _portMeta),
      );
    } else if (isInserting) {
      context.missing(_portMeta);
    }
    if (data.containsKey('capabilities_json')) {
      context.handle(
        _capabilitiesJsonMeta,
        capabilitiesJson.isAcceptableOrUnknown(
          data['capabilities_json']!,
          _capabilitiesJsonMeta,
        ),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {deviceId};
  @override
  SavedDevice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedDevice(
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      host: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}host'],
      )!,
      port: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}port'],
      )!,
      capabilitiesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}capabilities_json'],
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $SavedDevicesTable createAlias(String alias) {
    return $SavedDevicesTable(attachedDatabase, alias);
  }
}

class SavedDevice extends DataClass implements Insertable<SavedDevice> {
  final String deviceId;
  final String name;
  final String type;
  final String host;
  final int port;
  final String? capabilitiesJson;
  final String addedAt;
  const SavedDevice({
    required this.deviceId,
    required this.name,
    required this.type,
    required this.host,
    required this.port,
    this.capabilitiesJson,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['device_id'] = Variable<String>(deviceId);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['host'] = Variable<String>(host);
    map['port'] = Variable<int>(port);
    if (!nullToAbsent || capabilitiesJson != null) {
      map['capabilities_json'] = Variable<String>(capabilitiesJson);
    }
    map['added_at'] = Variable<String>(addedAt);
    return map;
  }

  SavedDevicesCompanion toCompanion(bool nullToAbsent) {
    return SavedDevicesCompanion(
      deviceId: Value(deviceId),
      name: Value(name),
      type: Value(type),
      host: Value(host),
      port: Value(port),
      capabilitiesJson: capabilitiesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(capabilitiesJson),
      addedAt: Value(addedAt),
    );
  }

  factory SavedDevice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedDevice(
      deviceId: serializer.fromJson<String>(json['deviceId']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      host: serializer.fromJson<String>(json['host']),
      port: serializer.fromJson<int>(json['port']),
      capabilitiesJson: serializer.fromJson<String?>(json['capabilitiesJson']),
      addedAt: serializer.fromJson<String>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'deviceId': serializer.toJson<String>(deviceId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'host': serializer.toJson<String>(host),
      'port': serializer.toJson<int>(port),
      'capabilitiesJson': serializer.toJson<String?>(capabilitiesJson),
      'addedAt': serializer.toJson<String>(addedAt),
    };
  }

  SavedDevice copyWith({
    String? deviceId,
    String? name,
    String? type,
    String? host,
    int? port,
    Value<String?> capabilitiesJson = const Value.absent(),
    String? addedAt,
  }) => SavedDevice(
    deviceId: deviceId ?? this.deviceId,
    name: name ?? this.name,
    type: type ?? this.type,
    host: host ?? this.host,
    port: port ?? this.port,
    capabilitiesJson: capabilitiesJson.present
        ? capabilitiesJson.value
        : this.capabilitiesJson,
    addedAt: addedAt ?? this.addedAt,
  );
  SavedDevice copyWithCompanion(SavedDevicesCompanion data) {
    return SavedDevice(
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      host: data.host.present ? data.host.value : this.host,
      port: data.port.present ? data.port.value : this.port,
      capabilitiesJson: data.capabilitiesJson.present
          ? data.capabilitiesJson.value
          : this.capabilitiesJson,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedDevice(')
          ..write('deviceId: $deviceId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('capabilitiesJson: $capabilitiesJson, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(deviceId, name, type, host, port, capabilitiesJson, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedDevice &&
          other.deviceId == this.deviceId &&
          other.name == this.name &&
          other.type == this.type &&
          other.host == this.host &&
          other.port == this.port &&
          other.capabilitiesJson == this.capabilitiesJson &&
          other.addedAt == this.addedAt);
}

class SavedDevicesCompanion extends UpdateCompanion<SavedDevice> {
  final Value<String> deviceId;
  final Value<String> name;
  final Value<String> type;
  final Value<String> host;
  final Value<int> port;
  final Value<String?> capabilitiesJson;
  final Value<String> addedAt;
  final Value<int> rowid;
  const SavedDevicesCompanion({
    this.deviceId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.host = const Value.absent(),
    this.port = const Value.absent(),
    this.capabilitiesJson = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedDevicesCompanion.insert({
    required String deviceId,
    required String name,
    required String type,
    required String host,
    required int port,
    this.capabilitiesJson = const Value.absent(),
    required String addedAt,
    this.rowid = const Value.absent(),
  }) : deviceId = Value(deviceId),
       name = Value(name),
       type = Value(type),
       host = Value(host),
       port = Value(port),
       addedAt = Value(addedAt);
  static Insertable<SavedDevice> custom({
    Expression<String>? deviceId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? host,
    Expression<int>? port,
    Expression<String>? capabilitiesJson,
    Expression<String>? addedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (deviceId != null) 'device_id': deviceId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (host != null) 'host': host,
      if (port != null) 'port': port,
      if (capabilitiesJson != null) 'capabilities_json': capabilitiesJson,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedDevicesCompanion copyWith({
    Value<String>? deviceId,
    Value<String>? name,
    Value<String>? type,
    Value<String>? host,
    Value<int>? port,
    Value<String?>? capabilitiesJson,
    Value<String>? addedAt,
    Value<int>? rowid,
  }) {
    return SavedDevicesCompanion(
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      type: type ?? this.type,
      host: host ?? this.host,
      port: port ?? this.port,
      capabilitiesJson: capabilitiesJson ?? this.capabilitiesJson,
      addedAt: addedAt ?? this.addedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (host.present) {
      map['host'] = Variable<String>(host.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (capabilitiesJson.present) {
      map['capabilities_json'] = Variable<String>(capabilitiesJson.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<String>(addedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedDevicesCompanion(')
          ..write('deviceId: $deviceId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('capabilitiesJson: $capabilitiesJson, ')
          ..write('addedAt: $addedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RadioFavoritesTable extends RadioFavorites
    with TableInfo<$RadioFavoritesTable, RadioFavorite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RadioFavoritesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  @override
  late final GeneratedColumn<String> artist = GeneratedColumn<String>(
    'artist',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stationNameMeta = const VerificationMeta(
    'stationName',
  );
  @override
  late final GeneratedColumn<String> stationName = GeneratedColumn<String>(
    'station_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _streamUrlMeta = const VerificationMeta(
    'streamUrl',
  );
  @override
  late final GeneratedColumn<String> streamUrl = GeneratedColumn<String>(
    'stream_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coverPathMeta = const VerificationMeta(
    'coverPath',
  );
  @override
  late final GeneratedColumn<String> coverPath = GeneratedColumn<String>(
    'cover_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _savedAtMeta = const VerificationMeta(
    'savedAt',
  );
  @override
  late final GeneratedColumn<String> savedAt = GeneratedColumn<String>(
    'saved_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    artist,
    stationName,
    streamUrl,
    coverPath,
    savedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'radio_favorites';
  @override
  VerificationContext validateIntegrity(
    Insertable<RadioFavorite> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('artist')) {
      context.handle(
        _artistMeta,
        artist.isAcceptableOrUnknown(data['artist']!, _artistMeta),
      );
    } else if (isInserting) {
      context.missing(_artistMeta);
    }
    if (data.containsKey('station_name')) {
      context.handle(
        _stationNameMeta,
        stationName.isAcceptableOrUnknown(
          data['station_name']!,
          _stationNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_stationNameMeta);
    }
    if (data.containsKey('stream_url')) {
      context.handle(
        _streamUrlMeta,
        streamUrl.isAcceptableOrUnknown(data['stream_url']!, _streamUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_streamUrlMeta);
    }
    if (data.containsKey('cover_path')) {
      context.handle(
        _coverPathMeta,
        coverPath.isAcceptableOrUnknown(data['cover_path']!, _coverPathMeta),
      );
    }
    if (data.containsKey('saved_at')) {
      context.handle(
        _savedAtMeta,
        savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_savedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RadioFavorite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RadioFavorite(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      artist: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artist'],
      )!,
      stationName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}station_name'],
      )!,
      streamUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stream_url'],
      )!,
      coverPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_path'],
      ),
      savedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}saved_at'],
      )!,
    );
  }

  @override
  $RadioFavoritesTable createAlias(String alias) {
    return $RadioFavoritesTable(attachedDatabase, alias);
  }
}

class RadioFavorite extends DataClass implements Insertable<RadioFavorite> {
  final int id;
  final String title;
  final String artist;
  final String stationName;
  final String streamUrl;
  final String? coverPath;
  final String savedAt;
  const RadioFavorite({
    required this.id,
    required this.title,
    required this.artist,
    required this.stationName,
    required this.streamUrl,
    this.coverPath,
    required this.savedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['artist'] = Variable<String>(artist);
    map['station_name'] = Variable<String>(stationName);
    map['stream_url'] = Variable<String>(streamUrl);
    if (!nullToAbsent || coverPath != null) {
      map['cover_path'] = Variable<String>(coverPath);
    }
    map['saved_at'] = Variable<String>(savedAt);
    return map;
  }

  RadioFavoritesCompanion toCompanion(bool nullToAbsent) {
    return RadioFavoritesCompanion(
      id: Value(id),
      title: Value(title),
      artist: Value(artist),
      stationName: Value(stationName),
      streamUrl: Value(streamUrl),
      coverPath: coverPath == null && nullToAbsent
          ? const Value.absent()
          : Value(coverPath),
      savedAt: Value(savedAt),
    );
  }

  factory RadioFavorite.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RadioFavorite(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      artist: serializer.fromJson<String>(json['artist']),
      stationName: serializer.fromJson<String>(json['stationName']),
      streamUrl: serializer.fromJson<String>(json['streamUrl']),
      coverPath: serializer.fromJson<String?>(json['coverPath']),
      savedAt: serializer.fromJson<String>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'artist': serializer.toJson<String>(artist),
      'stationName': serializer.toJson<String>(stationName),
      'streamUrl': serializer.toJson<String>(streamUrl),
      'coverPath': serializer.toJson<String?>(coverPath),
      'savedAt': serializer.toJson<String>(savedAt),
    };
  }

  RadioFavorite copyWith({
    int? id,
    String? title,
    String? artist,
    String? stationName,
    String? streamUrl,
    Value<String?> coverPath = const Value.absent(),
    String? savedAt,
  }) => RadioFavorite(
    id: id ?? this.id,
    title: title ?? this.title,
    artist: artist ?? this.artist,
    stationName: stationName ?? this.stationName,
    streamUrl: streamUrl ?? this.streamUrl,
    coverPath: coverPath.present ? coverPath.value : this.coverPath,
    savedAt: savedAt ?? this.savedAt,
  );
  RadioFavorite copyWithCompanion(RadioFavoritesCompanion data) {
    return RadioFavorite(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      artist: data.artist.present ? data.artist.value : this.artist,
      stationName: data.stationName.present
          ? data.stationName.value
          : this.stationName,
      streamUrl: data.streamUrl.present ? data.streamUrl.value : this.streamUrl,
      coverPath: data.coverPath.present ? data.coverPath.value : this.coverPath,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RadioFavorite(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('stationName: $stationName, ')
          ..write('streamUrl: $streamUrl, ')
          ..write('coverPath: $coverPath, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    artist,
    stationName,
    streamUrl,
    coverPath,
    savedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RadioFavorite &&
          other.id == this.id &&
          other.title == this.title &&
          other.artist == this.artist &&
          other.stationName == this.stationName &&
          other.streamUrl == this.streamUrl &&
          other.coverPath == this.coverPath &&
          other.savedAt == this.savedAt);
}

class RadioFavoritesCompanion extends UpdateCompanion<RadioFavorite> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> artist;
  final Value<String> stationName;
  final Value<String> streamUrl;
  final Value<String?> coverPath;
  final Value<String> savedAt;
  const RadioFavoritesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.artist = const Value.absent(),
    this.stationName = const Value.absent(),
    this.streamUrl = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.savedAt = const Value.absent(),
  });
  RadioFavoritesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String artist,
    required String stationName,
    required String streamUrl,
    this.coverPath = const Value.absent(),
    required String savedAt,
  }) : title = Value(title),
       artist = Value(artist),
       stationName = Value(stationName),
       streamUrl = Value(streamUrl),
       savedAt = Value(savedAt);
  static Insertable<RadioFavorite> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? artist,
    Expression<String>? stationName,
    Expression<String>? streamUrl,
    Expression<String>? coverPath,
    Expression<String>? savedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (artist != null) 'artist': artist,
      if (stationName != null) 'station_name': stationName,
      if (streamUrl != null) 'stream_url': streamUrl,
      if (coverPath != null) 'cover_path': coverPath,
      if (savedAt != null) 'saved_at': savedAt,
    });
  }

  RadioFavoritesCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? artist,
    Value<String>? stationName,
    Value<String>? streamUrl,
    Value<String?>? coverPath,
    Value<String>? savedAt,
  }) {
    return RadioFavoritesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      stationName: stationName ?? this.stationName,
      streamUrl: streamUrl ?? this.streamUrl,
      coverPath: coverPath ?? this.coverPath,
      savedAt: savedAt ?? this.savedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (artist.present) {
      map['artist'] = Variable<String>(artist.value);
    }
    if (stationName.present) {
      map['station_name'] = Variable<String>(stationName.value);
    }
    if (streamUrl.present) {
      map['stream_url'] = Variable<String>(streamUrl.value);
    }
    if (coverPath.present) {
      map['cover_path'] = Variable<String>(coverPath.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<String>(savedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RadioFavoritesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('stationName: $stationName, ')
          ..write('streamUrl: $streamUrl, ')
          ..write('coverPath: $coverPath, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }
}

class $StreamingAuthTable extends StreamingAuth
    with TableInfo<$StreamingAuthTable, StreamingAuthData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StreamingAuthTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serviceMeta = const VerificationMeta(
    'service',
  );
  @override
  late final GeneratedColumn<String> service = GeneratedColumn<String>(
    'service',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokenDataMeta = const VerificationMeta(
    'tokenData',
  );
  @override
  late final GeneratedColumn<String> tokenData = GeneratedColumn<String>(
    'token_data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [service, tokenData, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'streaming_auth';
  @override
  VerificationContext validateIntegrity(
    Insertable<StreamingAuthData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('service')) {
      context.handle(
        _serviceMeta,
        service.isAcceptableOrUnknown(data['service']!, _serviceMeta),
      );
    } else if (isInserting) {
      context.missing(_serviceMeta);
    }
    if (data.containsKey('token_data')) {
      context.handle(
        _tokenDataMeta,
        tokenData.isAcceptableOrUnknown(data['token_data']!, _tokenDataMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenDataMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {service};
  @override
  StreamingAuthData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StreamingAuthData(
      service: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service'],
      )!,
      tokenData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token_data'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $StreamingAuthTable createAlias(String alias) {
    return $StreamingAuthTable(attachedDatabase, alias);
  }
}

class StreamingAuthData extends DataClass
    implements Insertable<StreamingAuthData> {
  final String service;
  final String tokenData;
  final String updatedAt;
  const StreamingAuthData({
    required this.service,
    required this.tokenData,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['service'] = Variable<String>(service);
    map['token_data'] = Variable<String>(tokenData);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  StreamingAuthCompanion toCompanion(bool nullToAbsent) {
    return StreamingAuthCompanion(
      service: Value(service),
      tokenData: Value(tokenData),
      updatedAt: Value(updatedAt),
    );
  }

  factory StreamingAuthData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StreamingAuthData(
      service: serializer.fromJson<String>(json['service']),
      tokenData: serializer.fromJson<String>(json['tokenData']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'service': serializer.toJson<String>(service),
      'tokenData': serializer.toJson<String>(tokenData),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  StreamingAuthData copyWith({
    String? service,
    String? tokenData,
    String? updatedAt,
  }) => StreamingAuthData(
    service: service ?? this.service,
    tokenData: tokenData ?? this.tokenData,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  StreamingAuthData copyWithCompanion(StreamingAuthCompanion data) {
    return StreamingAuthData(
      service: data.service.present ? data.service.value : this.service,
      tokenData: data.tokenData.present ? data.tokenData.value : this.tokenData,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StreamingAuthData(')
          ..write('service: $service, ')
          ..write('tokenData: $tokenData, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(service, tokenData, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StreamingAuthData &&
          other.service == this.service &&
          other.tokenData == this.tokenData &&
          other.updatedAt == this.updatedAt);
}

class StreamingAuthCompanion extends UpdateCompanion<StreamingAuthData> {
  final Value<String> service;
  final Value<String> tokenData;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const StreamingAuthCompanion({
    this.service = const Value.absent(),
    this.tokenData = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StreamingAuthCompanion.insert({
    required String service,
    required String tokenData,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : service = Value(service),
       tokenData = Value(tokenData),
       updatedAt = Value(updatedAt);
  static Insertable<StreamingAuthData> custom({
    Expression<String>? service,
    Expression<String>? tokenData,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (service != null) 'service': service,
      if (tokenData != null) 'token_data': tokenData,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StreamingAuthCompanion copyWith({
    Value<String>? service,
    Value<String>? tokenData,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return StreamingAuthCompanion(
      service: service ?? this.service,
      tokenData: tokenData ?? this.tokenData,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (service.present) {
      map['service'] = Variable<String>(service.value);
    }
    if (tokenData.present) {
      map['token_data'] = Variable<String>(tokenData.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StreamingAuthCompanion(')
          ..write('service: $service, ')
          ..write('tokenData: $tokenData, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StreamingConfigTable extends StreamingConfig
    with TableInfo<$StreamingConfigTable, StreamingConfigData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StreamingConfigTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serviceMeta = const VerificationMeta(
    'service',
  );
  @override
  late final GeneratedColumn<String> service = GeneratedColumn<String>(
    'service',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _configJsonMeta = const VerificationMeta(
    'configJson',
  );
  @override
  late final GeneratedColumn<String> configJson = GeneratedColumn<String>(
    'config_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _qualityMeta = const VerificationMeta(
    'quality',
  );
  @override
  late final GeneratedColumn<String> quality = GeneratedColumn<String>(
    'quality',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [service, enabled, configJson, quality];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'streaming_config';
  @override
  VerificationContext validateIntegrity(
    Insertable<StreamingConfigData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('service')) {
      context.handle(
        _serviceMeta,
        service.isAcceptableOrUnknown(data['service']!, _serviceMeta),
      );
    } else if (isInserting) {
      context.missing(_serviceMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('config_json')) {
      context.handle(
        _configJsonMeta,
        configJson.isAcceptableOrUnknown(data['config_json']!, _configJsonMeta),
      );
    }
    if (data.containsKey('quality')) {
      context.handle(
        _qualityMeta,
        quality.isAcceptableOrUnknown(data['quality']!, _qualityMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {service};
  @override
  StreamingConfigData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StreamingConfigData(
      service: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      configJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}config_json'],
      ),
      quality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quality'],
      ),
    );
  }

  @override
  $StreamingConfigTable createAlias(String alias) {
    return $StreamingConfigTable(attachedDatabase, alias);
  }
}

class StreamingConfigData extends DataClass
    implements Insertable<StreamingConfigData> {
  final String service;
  final bool enabled;
  final String? configJson;
  final String? quality;
  const StreamingConfigData({
    required this.service,
    required this.enabled,
    this.configJson,
    this.quality,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['service'] = Variable<String>(service);
    map['enabled'] = Variable<bool>(enabled);
    if (!nullToAbsent || configJson != null) {
      map['config_json'] = Variable<String>(configJson);
    }
    if (!nullToAbsent || quality != null) {
      map['quality'] = Variable<String>(quality);
    }
    return map;
  }

  StreamingConfigCompanion toCompanion(bool nullToAbsent) {
    return StreamingConfigCompanion(
      service: Value(service),
      enabled: Value(enabled),
      configJson: configJson == null && nullToAbsent
          ? const Value.absent()
          : Value(configJson),
      quality: quality == null && nullToAbsent
          ? const Value.absent()
          : Value(quality),
    );
  }

  factory StreamingConfigData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StreamingConfigData(
      service: serializer.fromJson<String>(json['service']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      configJson: serializer.fromJson<String?>(json['configJson']),
      quality: serializer.fromJson<String?>(json['quality']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'service': serializer.toJson<String>(service),
      'enabled': serializer.toJson<bool>(enabled),
      'configJson': serializer.toJson<String?>(configJson),
      'quality': serializer.toJson<String?>(quality),
    };
  }

  StreamingConfigData copyWith({
    String? service,
    bool? enabled,
    Value<String?> configJson = const Value.absent(),
    Value<String?> quality = const Value.absent(),
  }) => StreamingConfigData(
    service: service ?? this.service,
    enabled: enabled ?? this.enabled,
    configJson: configJson.present ? configJson.value : this.configJson,
    quality: quality.present ? quality.value : this.quality,
  );
  StreamingConfigData copyWithCompanion(StreamingConfigCompanion data) {
    return StreamingConfigData(
      service: data.service.present ? data.service.value : this.service,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      configJson: data.configJson.present
          ? data.configJson.value
          : this.configJson,
      quality: data.quality.present ? data.quality.value : this.quality,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StreamingConfigData(')
          ..write('service: $service, ')
          ..write('enabled: $enabled, ')
          ..write('configJson: $configJson, ')
          ..write('quality: $quality')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(service, enabled, configJson, quality);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StreamingConfigData &&
          other.service == this.service &&
          other.enabled == this.enabled &&
          other.configJson == this.configJson &&
          other.quality == this.quality);
}

class StreamingConfigCompanion extends UpdateCompanion<StreamingConfigData> {
  final Value<String> service;
  final Value<bool> enabled;
  final Value<String?> configJson;
  final Value<String?> quality;
  final Value<int> rowid;
  const StreamingConfigCompanion({
    this.service = const Value.absent(),
    this.enabled = const Value.absent(),
    this.configJson = const Value.absent(),
    this.quality = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StreamingConfigCompanion.insert({
    required String service,
    this.enabled = const Value.absent(),
    this.configJson = const Value.absent(),
    this.quality = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : service = Value(service);
  static Insertable<StreamingConfigData> custom({
    Expression<String>? service,
    Expression<bool>? enabled,
    Expression<String>? configJson,
    Expression<String>? quality,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (service != null) 'service': service,
      if (enabled != null) 'enabled': enabled,
      if (configJson != null) 'config_json': configJson,
      if (quality != null) 'quality': quality,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StreamingConfigCompanion copyWith({
    Value<String>? service,
    Value<bool>? enabled,
    Value<String?>? configJson,
    Value<String?>? quality,
    Value<int>? rowid,
  }) {
    return StreamingConfigCompanion(
      service: service ?? this.service,
      enabled: enabled ?? this.enabled,
      configJson: configJson ?? this.configJson,
      quality: quality ?? this.quality,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (service.present) {
      map['service'] = Variable<String>(service.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (configJson.present) {
      map['config_json'] = Variable<String>(configJson.value);
    }
    if (quality.present) {
      map['quality'] = Variable<String>(quality.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StreamingConfigCompanion(')
          ..write('service: $service, ')
          ..write('enabled: $enabled, ')
          ..write('configJson: $configJson, ')
          ..write('quality: $quality, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$TuneDatabase extends GeneratedDatabase {
  _$TuneDatabase(QueryExecutor e) : super(e);
  $TuneDatabaseManager get managers => $TuneDatabaseManager(this);
  late final $ArtistsTable artists = $ArtistsTable(this);
  late final $AlbumsTable albums = $AlbumsTable(this);
  late final $TracksTable tracks = $TracksTable(this);
  late final $PlaylistsTable playlists = $PlaylistsTable(this);
  late final $PlaylistTracksTable playlistTracks = $PlaylistTracksTable(this);
  late final $ZonesTable zones = $ZonesTable(this);
  late final $QueueItemsTable queueItems = $QueueItemsTable(this);
  late final $RadiosTable radios = $RadiosTable(this);
  late final $MusicFoldersTable musicFolders = $MusicFoldersTable(this);
  late final $SavedDevicesTable savedDevices = $SavedDevicesTable(this);
  late final $RadioFavoritesTable radioFavorites = $RadioFavoritesTable(this);
  late final $StreamingAuthTable streamingAuth = $StreamingAuthTable(this);
  late final $StreamingConfigTable streamingConfig = $StreamingConfigTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    artists,
    albums,
    tracks,
    playlists,
    playlistTracks,
    zones,
    queueItems,
    radios,
    musicFolders,
    savedDevices,
    radioFavorites,
    streamingAuth,
    streamingConfig,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'playlists',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('playlist_tracks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tracks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('playlist_tracks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'zones',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('queue_items', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ArtistsTableCreateCompanionBuilder =
    ArtistsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> sortName,
      Value<String?> musicbrainzId,
      Value<String?> discogsId,
      Value<String?> bio,
      Value<String?> imagePath,
    });
typedef $$ArtistsTableUpdateCompanionBuilder =
    ArtistsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> sortName,
      Value<String?> musicbrainzId,
      Value<String?> discogsId,
      Value<String?> bio,
      Value<String?> imagePath,
    });

final class $$ArtistsTableReferences
    extends BaseReferences<_$TuneDatabase, $ArtistsTable, Artist> {
  $$ArtistsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AlbumsTable, List<Album>> _albumsRefsTable(
    _$TuneDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.albums,
    aliasName: $_aliasNameGenerator(db.artists.id, db.albums.artistId),
  );

  $$AlbumsTableProcessedTableManager get albumsRefs {
    final manager = $$AlbumsTableTableManager(
      $_db,
      $_db.albums,
    ).filter((f) => f.artistId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_albumsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TracksTable, List<Track>> _tracksRefsTable(
    _$TuneDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tracks,
    aliasName: $_aliasNameGenerator(db.artists.id, db.tracks.artistId),
  );

  $$TracksTableProcessedTableManager get tracksRefs {
    final manager = $$TracksTableTableManager(
      $_db,
      $_db.tracks,
    ).filter((f) => f.artistId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tracksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ArtistsTableFilterComposer
    extends Composer<_$TuneDatabase, $ArtistsTable> {
  $$ArtistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sortName => $composableBuilder(
    column: $table.sortName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get musicbrainzId => $composableBuilder(
    column: $table.musicbrainzId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get discogsId => $composableBuilder(
    column: $table.discogsId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> albumsRefs(
    Expression<bool> Function($$AlbumsTableFilterComposer f) f,
  ) {
    final $$AlbumsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.albums,
      getReferencedColumn: (t) => t.artistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlbumsTableFilterComposer(
            $db: $db,
            $table: $db.albums,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tracksRefs(
    Expression<bool> Function($$TracksTableFilterComposer f) f,
  ) {
    final $$TracksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.artistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TracksTableFilterComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ArtistsTableOrderingComposer
    extends Composer<_$TuneDatabase, $ArtistsTable> {
  $$ArtistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sortName => $composableBuilder(
    column: $table.sortName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get musicbrainzId => $composableBuilder(
    column: $table.musicbrainzId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discogsId => $composableBuilder(
    column: $table.discogsId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ArtistsTableAnnotationComposer
    extends Composer<_$TuneDatabase, $ArtistsTable> {
  $$ArtistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get sortName =>
      $composableBuilder(column: $table.sortName, builder: (column) => column);

  GeneratedColumn<String> get musicbrainzId => $composableBuilder(
    column: $table.musicbrainzId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get discogsId =>
      $composableBuilder(column: $table.discogsId, builder: (column) => column);

  GeneratedColumn<String> get bio =>
      $composableBuilder(column: $table.bio, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  Expression<T> albumsRefs<T extends Object>(
    Expression<T> Function($$AlbumsTableAnnotationComposer a) f,
  ) {
    final $$AlbumsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.albums,
      getReferencedColumn: (t) => t.artistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlbumsTableAnnotationComposer(
            $db: $db,
            $table: $db.albums,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tracksRefs<T extends Object>(
    Expression<T> Function($$TracksTableAnnotationComposer a) f,
  ) {
    final $$TracksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.artistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TracksTableAnnotationComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ArtistsTableTableManager
    extends
        RootTableManager<
          _$TuneDatabase,
          $ArtistsTable,
          Artist,
          $$ArtistsTableFilterComposer,
          $$ArtistsTableOrderingComposer,
          $$ArtistsTableAnnotationComposer,
          $$ArtistsTableCreateCompanionBuilder,
          $$ArtistsTableUpdateCompanionBuilder,
          (Artist, $$ArtistsTableReferences),
          Artist,
          PrefetchHooks Function({bool albumsRefs, bool tracksRefs})
        > {
  $$ArtistsTableTableManager(_$TuneDatabase db, $ArtistsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArtistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArtistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArtistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> sortName = const Value.absent(),
                Value<String?> musicbrainzId = const Value.absent(),
                Value<String?> discogsId = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
              }) => ArtistsCompanion(
                id: id,
                name: name,
                sortName: sortName,
                musicbrainzId: musicbrainzId,
                discogsId: discogsId,
                bio: bio,
                imagePath: imagePath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> sortName = const Value.absent(),
                Value<String?> musicbrainzId = const Value.absent(),
                Value<String?> discogsId = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
              }) => ArtistsCompanion.insert(
                id: id,
                name: name,
                sortName: sortName,
                musicbrainzId: musicbrainzId,
                discogsId: discogsId,
                bio: bio,
                imagePath: imagePath,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ArtistsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({albumsRefs = false, tracksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (albumsRefs) db.albums,
                if (tracksRefs) db.tracks,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (albumsRefs)
                    await $_getPrefetchedData<Artist, $ArtistsTable, Album>(
                      currentTable: table,
                      referencedTable: $$ArtistsTableReferences
                          ._albumsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ArtistsTableReferences(db, table, p0).albumsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.artistId == item.id),
                      typedResults: items,
                    ),
                  if (tracksRefs)
                    await $_getPrefetchedData<Artist, $ArtistsTable, Track>(
                      currentTable: table,
                      referencedTable: $$ArtistsTableReferences
                          ._tracksRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ArtistsTableReferences(db, table, p0).tracksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.artistId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ArtistsTableProcessedTableManager =
    ProcessedTableManager<
      _$TuneDatabase,
      $ArtistsTable,
      Artist,
      $$ArtistsTableFilterComposer,
      $$ArtistsTableOrderingComposer,
      $$ArtistsTableAnnotationComposer,
      $$ArtistsTableCreateCompanionBuilder,
      $$ArtistsTableUpdateCompanionBuilder,
      (Artist, $$ArtistsTableReferences),
      Artist,
      PrefetchHooks Function({bool albumsRefs, bool tracksRefs})
    >;
typedef $$AlbumsTableCreateCompanionBuilder =
    AlbumsCompanion Function({
      Value<int> id,
      required String title,
      Value<int?> artistId,
      Value<String?> artistName,
      Value<int?> year,
      Value<String?> genre,
      Value<int?> discCount,
      Value<int?> trackCount,
      Value<String?> coverPath,
      Value<String> source,
      Value<String?> sourceId,
    });
typedef $$AlbumsTableUpdateCompanionBuilder =
    AlbumsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<int?> artistId,
      Value<String?> artistName,
      Value<int?> year,
      Value<String?> genre,
      Value<int?> discCount,
      Value<int?> trackCount,
      Value<String?> coverPath,
      Value<String> source,
      Value<String?> sourceId,
    });

final class $$AlbumsTableReferences
    extends BaseReferences<_$TuneDatabase, $AlbumsTable, Album> {
  $$AlbumsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ArtistsTable _artistIdTable(_$TuneDatabase db) => db.artists
      .createAlias($_aliasNameGenerator(db.albums.artistId, db.artists.id));

  $$ArtistsTableProcessedTableManager? get artistId {
    final $_column = $_itemColumn<int>('artist_id');
    if ($_column == null) return null;
    final manager = $$ArtistsTableTableManager(
      $_db,
      $_db.artists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_artistIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TracksTable, List<Track>> _tracksRefsTable(
    _$TuneDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tracks,
    aliasName: $_aliasNameGenerator(db.albums.id, db.tracks.albumId),
  );

  $$TracksTableProcessedTableManager get tracksRefs {
    final manager = $$TracksTableTableManager(
      $_db,
      $_db.tracks,
    ).filter((f) => f.albumId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tracksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AlbumsTableFilterComposer
    extends Composer<_$TuneDatabase, $AlbumsTable> {
  $$AlbumsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artistName => $composableBuilder(
    column: $table.artistName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discCount => $composableBuilder(
    column: $table.discCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trackCount => $composableBuilder(
    column: $table.trackCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  $$ArtistsTableFilterComposer get artistId {
    final $$ArtistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artistId,
      referencedTable: $db.artists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistsTableFilterComposer(
            $db: $db,
            $table: $db.artists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> tracksRefs(
    Expression<bool> Function($$TracksTableFilterComposer f) f,
  ) {
    final $$TracksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.albumId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TracksTableFilterComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AlbumsTableOrderingComposer
    extends Composer<_$TuneDatabase, $AlbumsTable> {
  $$AlbumsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artistName => $composableBuilder(
    column: $table.artistName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discCount => $composableBuilder(
    column: $table.discCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trackCount => $composableBuilder(
    column: $table.trackCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  $$ArtistsTableOrderingComposer get artistId {
    final $$ArtistsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artistId,
      referencedTable: $db.artists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistsTableOrderingComposer(
            $db: $db,
            $table: $db.artists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AlbumsTableAnnotationComposer
    extends Composer<_$TuneDatabase, $AlbumsTable> {
  $$AlbumsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get artistName => $composableBuilder(
    column: $table.artistName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => column);

  GeneratedColumn<int> get discCount =>
      $composableBuilder(column: $table.discCount, builder: (column) => column);

  GeneratedColumn<int> get trackCount => $composableBuilder(
    column: $table.trackCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get coverPath =>
      $composableBuilder(column: $table.coverPath, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  $$ArtistsTableAnnotationComposer get artistId {
    final $$ArtistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artistId,
      referencedTable: $db.artists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistsTableAnnotationComposer(
            $db: $db,
            $table: $db.artists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> tracksRefs<T extends Object>(
    Expression<T> Function($$TracksTableAnnotationComposer a) f,
  ) {
    final $$TracksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.albumId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TracksTableAnnotationComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AlbumsTableTableManager
    extends
        RootTableManager<
          _$TuneDatabase,
          $AlbumsTable,
          Album,
          $$AlbumsTableFilterComposer,
          $$AlbumsTableOrderingComposer,
          $$AlbumsTableAnnotationComposer,
          $$AlbumsTableCreateCompanionBuilder,
          $$AlbumsTableUpdateCompanionBuilder,
          (Album, $$AlbumsTableReferences),
          Album,
          PrefetchHooks Function({bool artistId, bool tracksRefs})
        > {
  $$AlbumsTableTableManager(_$TuneDatabase db, $AlbumsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlbumsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlbumsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlbumsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int?> artistId = const Value.absent(),
                Value<String?> artistName = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<int?> discCount = const Value.absent(),
                Value<int?> trackCount = const Value.absent(),
                Value<String?> coverPath = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> sourceId = const Value.absent(),
              }) => AlbumsCompanion(
                id: id,
                title: title,
                artistId: artistId,
                artistName: artistName,
                year: year,
                genre: genre,
                discCount: discCount,
                trackCount: trackCount,
                coverPath: coverPath,
                source: source,
                sourceId: sourceId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<int?> artistId = const Value.absent(),
                Value<String?> artistName = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<int?> discCount = const Value.absent(),
                Value<int?> trackCount = const Value.absent(),
                Value<String?> coverPath = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> sourceId = const Value.absent(),
              }) => AlbumsCompanion.insert(
                id: id,
                title: title,
                artistId: artistId,
                artistName: artistName,
                year: year,
                genre: genre,
                discCount: discCount,
                trackCount: trackCount,
                coverPath: coverPath,
                source: source,
                sourceId: sourceId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$AlbumsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({artistId = false, tracksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tracksRefs) db.tracks],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (artistId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.artistId,
                                referencedTable: $$AlbumsTableReferences
                                    ._artistIdTable(db),
                                referencedColumn: $$AlbumsTableReferences
                                    ._artistIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tracksRefs)
                    await $_getPrefetchedData<Album, $AlbumsTable, Track>(
                      currentTable: table,
                      referencedTable: $$AlbumsTableReferences._tracksRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$AlbumsTableReferences(db, table, p0).tracksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.albumId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AlbumsTableProcessedTableManager =
    ProcessedTableManager<
      _$TuneDatabase,
      $AlbumsTable,
      Album,
      $$AlbumsTableFilterComposer,
      $$AlbumsTableOrderingComposer,
      $$AlbumsTableAnnotationComposer,
      $$AlbumsTableCreateCompanionBuilder,
      $$AlbumsTableUpdateCompanionBuilder,
      (Album, $$AlbumsTableReferences),
      Album,
      PrefetchHooks Function({bool artistId, bool tracksRefs})
    >;
typedef $$TracksTableCreateCompanionBuilder =
    TracksCompanion Function({
      Value<int> id,
      required String title,
      Value<int?> albumId,
      Value<String?> albumTitle,
      Value<int?> artistId,
      Value<String?> artistName,
      Value<int?> discNumber,
      Value<int?> trackNumber,
      Value<int?> durationMs,
      Value<String?> filePath,
      Value<String?> format,
      Value<int?> sampleRate,
      Value<int?> bitDepth,
      Value<int?> channels,
      Value<String?> coverPath,
      Value<String> source,
      Value<String?> sourceId,
      Value<bool> favorite,
    });
typedef $$TracksTableUpdateCompanionBuilder =
    TracksCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<int?> albumId,
      Value<String?> albumTitle,
      Value<int?> artistId,
      Value<String?> artistName,
      Value<int?> discNumber,
      Value<int?> trackNumber,
      Value<int?> durationMs,
      Value<String?> filePath,
      Value<String?> format,
      Value<int?> sampleRate,
      Value<int?> bitDepth,
      Value<int?> channels,
      Value<String?> coverPath,
      Value<String> source,
      Value<String?> sourceId,
      Value<bool> favorite,
    });

final class $$TracksTableReferences
    extends BaseReferences<_$TuneDatabase, $TracksTable, Track> {
  $$TracksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AlbumsTable _albumIdTable(_$TuneDatabase db) => db.albums.createAlias(
    $_aliasNameGenerator(db.tracks.albumId, db.albums.id),
  );

  $$AlbumsTableProcessedTableManager? get albumId {
    final $_column = $_itemColumn<int>('album_id');
    if ($_column == null) return null;
    final manager = $$AlbumsTableTableManager(
      $_db,
      $_db.albums,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_albumIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ArtistsTable _artistIdTable(_$TuneDatabase db) => db.artists
      .createAlias($_aliasNameGenerator(db.tracks.artistId, db.artists.id));

  $$ArtistsTableProcessedTableManager? get artistId {
    final $_column = $_itemColumn<int>('artist_id');
    if ($_column == null) return null;
    final manager = $$ArtistsTableTableManager(
      $_db,
      $_db.artists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_artistIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PlaylistTracksTable, List<PlaylistTrack>>
  _playlistTracksRefsTable(_$TuneDatabase db) => MultiTypedResultKey.fromTable(
    db.playlistTracks,
    aliasName: $_aliasNameGenerator(db.tracks.id, db.playlistTracks.trackId),
  );

  $$PlaylistTracksTableProcessedTableManager get playlistTracksRefs {
    final manager = $$PlaylistTracksTableTableManager(
      $_db,
      $_db.playlistTracks,
    ).filter((f) => f.trackId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_playlistTracksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TracksTableFilterComposer
    extends Composer<_$TuneDatabase, $TracksTable> {
  $$TracksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get albumTitle => $composableBuilder(
    column: $table.albumTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artistName => $composableBuilder(
    column: $table.artistName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discNumber => $composableBuilder(
    column: $table.discNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trackNumber => $composableBuilder(
    column: $table.trackNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sampleRate => $composableBuilder(
    column: $table.sampleRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bitDepth => $composableBuilder(
    column: $table.bitDepth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get channels => $composableBuilder(
    column: $table.channels,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnFilters(column),
  );

  $$AlbumsTableFilterComposer get albumId {
    final $$AlbumsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.albumId,
      referencedTable: $db.albums,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlbumsTableFilterComposer(
            $db: $db,
            $table: $db.albums,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ArtistsTableFilterComposer get artistId {
    final $$ArtistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artistId,
      referencedTable: $db.artists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistsTableFilterComposer(
            $db: $db,
            $table: $db.artists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> playlistTracksRefs(
    Expression<bool> Function($$PlaylistTracksTableFilterComposer f) f,
  ) {
    final $$PlaylistTracksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playlistTracks,
      getReferencedColumn: (t) => t.trackId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistTracksTableFilterComposer(
            $db: $db,
            $table: $db.playlistTracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TracksTableOrderingComposer
    extends Composer<_$TuneDatabase, $TracksTable> {
  $$TracksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get albumTitle => $composableBuilder(
    column: $table.albumTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artistName => $composableBuilder(
    column: $table.artistName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discNumber => $composableBuilder(
    column: $table.discNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trackNumber => $composableBuilder(
    column: $table.trackNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sampleRate => $composableBuilder(
    column: $table.sampleRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bitDepth => $composableBuilder(
    column: $table.bitDepth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get channels => $composableBuilder(
    column: $table.channels,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnOrderings(column),
  );

  $$AlbumsTableOrderingComposer get albumId {
    final $$AlbumsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.albumId,
      referencedTable: $db.albums,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlbumsTableOrderingComposer(
            $db: $db,
            $table: $db.albums,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ArtistsTableOrderingComposer get artistId {
    final $$ArtistsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artistId,
      referencedTable: $db.artists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistsTableOrderingComposer(
            $db: $db,
            $table: $db.artists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TracksTableAnnotationComposer
    extends Composer<_$TuneDatabase, $TracksTable> {
  $$TracksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get albumTitle => $composableBuilder(
    column: $table.albumTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get artistName => $composableBuilder(
    column: $table.artistName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discNumber => $composableBuilder(
    column: $table.discNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get trackNumber => $composableBuilder(
    column: $table.trackNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  GeneratedColumn<int> get sampleRate => $composableBuilder(
    column: $table.sampleRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bitDepth =>
      $composableBuilder(column: $table.bitDepth, builder: (column) => column);

  GeneratedColumn<int> get channels =>
      $composableBuilder(column: $table.channels, builder: (column) => column);

  GeneratedColumn<String> get coverPath =>
      $composableBuilder(column: $table.coverPath, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);

  $$AlbumsTableAnnotationComposer get albumId {
    final $$AlbumsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.albumId,
      referencedTable: $db.albums,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlbumsTableAnnotationComposer(
            $db: $db,
            $table: $db.albums,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ArtistsTableAnnotationComposer get artistId {
    final $$ArtistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artistId,
      referencedTable: $db.artists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistsTableAnnotationComposer(
            $db: $db,
            $table: $db.artists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> playlistTracksRefs<T extends Object>(
    Expression<T> Function($$PlaylistTracksTableAnnotationComposer a) f,
  ) {
    final $$PlaylistTracksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playlistTracks,
      getReferencedColumn: (t) => t.trackId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistTracksTableAnnotationComposer(
            $db: $db,
            $table: $db.playlistTracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TracksTableTableManager
    extends
        RootTableManager<
          _$TuneDatabase,
          $TracksTable,
          Track,
          $$TracksTableFilterComposer,
          $$TracksTableOrderingComposer,
          $$TracksTableAnnotationComposer,
          $$TracksTableCreateCompanionBuilder,
          $$TracksTableUpdateCompanionBuilder,
          (Track, $$TracksTableReferences),
          Track,
          PrefetchHooks Function({
            bool albumId,
            bool artistId,
            bool playlistTracksRefs,
          })
        > {
  $$TracksTableTableManager(_$TuneDatabase db, $TracksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TracksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TracksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TracksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int?> albumId = const Value.absent(),
                Value<String?> albumTitle = const Value.absent(),
                Value<int?> artistId = const Value.absent(),
                Value<String?> artistName = const Value.absent(),
                Value<int?> discNumber = const Value.absent(),
                Value<int?> trackNumber = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                Value<String?> format = const Value.absent(),
                Value<int?> sampleRate = const Value.absent(),
                Value<int?> bitDepth = const Value.absent(),
                Value<int?> channels = const Value.absent(),
                Value<String?> coverPath = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> sourceId = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
              }) => TracksCompanion(
                id: id,
                title: title,
                albumId: albumId,
                albumTitle: albumTitle,
                artistId: artistId,
                artistName: artistName,
                discNumber: discNumber,
                trackNumber: trackNumber,
                durationMs: durationMs,
                filePath: filePath,
                format: format,
                sampleRate: sampleRate,
                bitDepth: bitDepth,
                channels: channels,
                coverPath: coverPath,
                source: source,
                sourceId: sourceId,
                favorite: favorite,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<int?> albumId = const Value.absent(),
                Value<String?> albumTitle = const Value.absent(),
                Value<int?> artistId = const Value.absent(),
                Value<String?> artistName = const Value.absent(),
                Value<int?> discNumber = const Value.absent(),
                Value<int?> trackNumber = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                Value<String?> format = const Value.absent(),
                Value<int?> sampleRate = const Value.absent(),
                Value<int?> bitDepth = const Value.absent(),
                Value<int?> channels = const Value.absent(),
                Value<String?> coverPath = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> sourceId = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
              }) => TracksCompanion.insert(
                id: id,
                title: title,
                albumId: albumId,
                albumTitle: albumTitle,
                artistId: artistId,
                artistName: artistName,
                discNumber: discNumber,
                trackNumber: trackNumber,
                durationMs: durationMs,
                filePath: filePath,
                format: format,
                sampleRate: sampleRate,
                bitDepth: bitDepth,
                channels: channels,
                coverPath: coverPath,
                source: source,
                sourceId: sourceId,
                favorite: favorite,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TracksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                albumId = false,
                artistId = false,
                playlistTracksRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (playlistTracksRefs) db.playlistTracks,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (albumId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.albumId,
                                    referencedTable: $$TracksTableReferences
                                        ._albumIdTable(db),
                                    referencedColumn: $$TracksTableReferences
                                        ._albumIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (artistId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.artistId,
                                    referencedTable: $$TracksTableReferences
                                        ._artistIdTable(db),
                                    referencedColumn: $$TracksTableReferences
                                        ._artistIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (playlistTracksRefs)
                        await $_getPrefetchedData<
                          Track,
                          $TracksTable,
                          PlaylistTrack
                        >(
                          currentTable: table,
                          referencedTable: $$TracksTableReferences
                              ._playlistTracksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TracksTableReferences(
                                db,
                                table,
                                p0,
                              ).playlistTracksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.trackId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TracksTableProcessedTableManager =
    ProcessedTableManager<
      _$TuneDatabase,
      $TracksTable,
      Track,
      $$TracksTableFilterComposer,
      $$TracksTableOrderingComposer,
      $$TracksTableAnnotationComposer,
      $$TracksTableCreateCompanionBuilder,
      $$TracksTableUpdateCompanionBuilder,
      (Track, $$TracksTableReferences),
      Track,
      PrefetchHooks Function({
        bool albumId,
        bool artistId,
        bool playlistTracksRefs,
      })
    >;
typedef $$PlaylistsTableCreateCompanionBuilder =
    PlaylistsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      Value<int> trackCount,
    });
typedef $$PlaylistsTableUpdateCompanionBuilder =
    PlaylistsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<int> trackCount,
    });

final class $$PlaylistsTableReferences
    extends BaseReferences<_$TuneDatabase, $PlaylistsTable, Playlist> {
  $$PlaylistsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlaylistTracksTable, List<PlaylistTrack>>
  _playlistTracksRefsTable(_$TuneDatabase db) => MultiTypedResultKey.fromTable(
    db.playlistTracks,
    aliasName: $_aliasNameGenerator(
      db.playlists.id,
      db.playlistTracks.playlistId,
    ),
  );

  $$PlaylistTracksTableProcessedTableManager get playlistTracksRefs {
    final manager = $$PlaylistTracksTableTableManager(
      $_db,
      $_db.playlistTracks,
    ).filter((f) => f.playlistId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_playlistTracksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlaylistsTableFilterComposer
    extends Composer<_$TuneDatabase, $PlaylistsTable> {
  $$PlaylistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trackCount => $composableBuilder(
    column: $table.trackCount,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> playlistTracksRefs(
    Expression<bool> Function($$PlaylistTracksTableFilterComposer f) f,
  ) {
    final $$PlaylistTracksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playlistTracks,
      getReferencedColumn: (t) => t.playlistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistTracksTableFilterComposer(
            $db: $db,
            $table: $db.playlistTracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlaylistsTableOrderingComposer
    extends Composer<_$TuneDatabase, $PlaylistsTable> {
  $$PlaylistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trackCount => $composableBuilder(
    column: $table.trackCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlaylistsTableAnnotationComposer
    extends Composer<_$TuneDatabase, $PlaylistsTable> {
  $$PlaylistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get trackCount => $composableBuilder(
    column: $table.trackCount,
    builder: (column) => column,
  );

  Expression<T> playlistTracksRefs<T extends Object>(
    Expression<T> Function($$PlaylistTracksTableAnnotationComposer a) f,
  ) {
    final $$PlaylistTracksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playlistTracks,
      getReferencedColumn: (t) => t.playlistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistTracksTableAnnotationComposer(
            $db: $db,
            $table: $db.playlistTracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlaylistsTableTableManager
    extends
        RootTableManager<
          _$TuneDatabase,
          $PlaylistsTable,
          Playlist,
          $$PlaylistsTableFilterComposer,
          $$PlaylistsTableOrderingComposer,
          $$PlaylistsTableAnnotationComposer,
          $$PlaylistsTableCreateCompanionBuilder,
          $$PlaylistsTableUpdateCompanionBuilder,
          (Playlist, $$PlaylistsTableReferences),
          Playlist,
          PrefetchHooks Function({bool playlistTracksRefs})
        > {
  $$PlaylistsTableTableManager(_$TuneDatabase db, $PlaylistsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaylistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> trackCount = const Value.absent(),
              }) => PlaylistsCompanion(
                id: id,
                name: name,
                description: description,
                trackCount: trackCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<int> trackCount = const Value.absent(),
              }) => PlaylistsCompanion.insert(
                id: id,
                name: name,
                description: description,
                trackCount: trackCount,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlaylistsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({playlistTracksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (playlistTracksRefs) db.playlistTracks,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (playlistTracksRefs)
                    await $_getPrefetchedData<
                      Playlist,
                      $PlaylistsTable,
                      PlaylistTrack
                    >(
                      currentTable: table,
                      referencedTable: $$PlaylistsTableReferences
                          ._playlistTracksRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PlaylistsTableReferences(
                            db,
                            table,
                            p0,
                          ).playlistTracksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.playlistId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PlaylistsTableProcessedTableManager =
    ProcessedTableManager<
      _$TuneDatabase,
      $PlaylistsTable,
      Playlist,
      $$PlaylistsTableFilterComposer,
      $$PlaylistsTableOrderingComposer,
      $$PlaylistsTableAnnotationComposer,
      $$PlaylistsTableCreateCompanionBuilder,
      $$PlaylistsTableUpdateCompanionBuilder,
      (Playlist, $$PlaylistsTableReferences),
      Playlist,
      PrefetchHooks Function({bool playlistTracksRefs})
    >;
typedef $$PlaylistTracksTableCreateCompanionBuilder =
    PlaylistTracksCompanion Function({
      Value<int> id,
      required int playlistId,
      required int trackId,
      required int position,
    });
typedef $$PlaylistTracksTableUpdateCompanionBuilder =
    PlaylistTracksCompanion Function({
      Value<int> id,
      Value<int> playlistId,
      Value<int> trackId,
      Value<int> position,
    });

final class $$PlaylistTracksTableReferences
    extends
        BaseReferences<_$TuneDatabase, $PlaylistTracksTable, PlaylistTrack> {
  $$PlaylistTracksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PlaylistsTable _playlistIdTable(_$TuneDatabase db) =>
      db.playlists.createAlias(
        $_aliasNameGenerator(db.playlistTracks.playlistId, db.playlists.id),
      );

  $$PlaylistsTableProcessedTableManager get playlistId {
    final $_column = $_itemColumn<int>('playlist_id')!;

    final manager = $$PlaylistsTableTableManager(
      $_db,
      $_db.playlists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playlistIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TracksTable _trackIdTable(_$TuneDatabase db) => db.tracks.createAlias(
    $_aliasNameGenerator(db.playlistTracks.trackId, db.tracks.id),
  );

  $$TracksTableProcessedTableManager get trackId {
    final $_column = $_itemColumn<int>('track_id')!;

    final manager = $$TracksTableTableManager(
      $_db,
      $_db.tracks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trackIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlaylistTracksTableFilterComposer
    extends Composer<_$TuneDatabase, $PlaylistTracksTable> {
  $$PlaylistTracksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$PlaylistsTableFilterComposer get playlistId {
    final $$PlaylistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playlistId,
      referencedTable: $db.playlists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistsTableFilterComposer(
            $db: $db,
            $table: $db.playlists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TracksTableFilterComposer get trackId {
    final $$TracksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TracksTableFilterComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaylistTracksTableOrderingComposer
    extends Composer<_$TuneDatabase, $PlaylistTracksTable> {
  $$PlaylistTracksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlaylistsTableOrderingComposer get playlistId {
    final $$PlaylistsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playlistId,
      referencedTable: $db.playlists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistsTableOrderingComposer(
            $db: $db,
            $table: $db.playlists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TracksTableOrderingComposer get trackId {
    final $$TracksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TracksTableOrderingComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaylistTracksTableAnnotationComposer
    extends Composer<_$TuneDatabase, $PlaylistTracksTable> {
  $$PlaylistTracksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$PlaylistsTableAnnotationComposer get playlistId {
    final $$PlaylistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playlistId,
      referencedTable: $db.playlists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistsTableAnnotationComposer(
            $db: $db,
            $table: $db.playlists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TracksTableAnnotationComposer get trackId {
    final $$TracksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TracksTableAnnotationComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaylistTracksTableTableManager
    extends
        RootTableManager<
          _$TuneDatabase,
          $PlaylistTracksTable,
          PlaylistTrack,
          $$PlaylistTracksTableFilterComposer,
          $$PlaylistTracksTableOrderingComposer,
          $$PlaylistTracksTableAnnotationComposer,
          $$PlaylistTracksTableCreateCompanionBuilder,
          $$PlaylistTracksTableUpdateCompanionBuilder,
          (PlaylistTrack, $$PlaylistTracksTableReferences),
          PlaylistTrack,
          PrefetchHooks Function({bool playlistId, bool trackId})
        > {
  $$PlaylistTracksTableTableManager(
    _$TuneDatabase db,
    $PlaylistTracksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaylistTracksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistTracksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistTracksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> playlistId = const Value.absent(),
                Value<int> trackId = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => PlaylistTracksCompanion(
                id: id,
                playlistId: playlistId,
                trackId: trackId,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int playlistId,
                required int trackId,
                required int position,
              }) => PlaylistTracksCompanion.insert(
                id: id,
                playlistId: playlistId,
                trackId: trackId,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlaylistTracksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({playlistId = false, trackId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (playlistId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.playlistId,
                                referencedTable: $$PlaylistTracksTableReferences
                                    ._playlistIdTable(db),
                                referencedColumn:
                                    $$PlaylistTracksTableReferences
                                        ._playlistIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (trackId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.trackId,
                                referencedTable: $$PlaylistTracksTableReferences
                                    ._trackIdTable(db),
                                referencedColumn:
                                    $$PlaylistTracksTableReferences
                                        ._trackIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlaylistTracksTableProcessedTableManager =
    ProcessedTableManager<
      _$TuneDatabase,
      $PlaylistTracksTable,
      PlaylistTrack,
      $$PlaylistTracksTableFilterComposer,
      $$PlaylistTracksTableOrderingComposer,
      $$PlaylistTracksTableAnnotationComposer,
      $$PlaylistTracksTableCreateCompanionBuilder,
      $$PlaylistTracksTableUpdateCompanionBuilder,
      (PlaylistTrack, $$PlaylistTracksTableReferences),
      PlaylistTrack,
      PrefetchHooks Function({bool playlistId, bool trackId})
    >;
typedef $$ZonesTableCreateCompanionBuilder =
    ZonesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> outputType,
      Value<String?> outputDeviceId,
      Value<double> volume,
      Value<String?> groupId,
      Value<int> syncDelayMs,
    });
typedef $$ZonesTableUpdateCompanionBuilder =
    ZonesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> outputType,
      Value<String?> outputDeviceId,
      Value<double> volume,
      Value<String?> groupId,
      Value<int> syncDelayMs,
    });

final class $$ZonesTableReferences
    extends BaseReferences<_$TuneDatabase, $ZonesTable, Zone> {
  $$ZonesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$QueueItemsTable, List<QueueItem>>
  _queueItemsRefsTable(_$TuneDatabase db) => MultiTypedResultKey.fromTable(
    db.queueItems,
    aliasName: $_aliasNameGenerator(db.zones.id, db.queueItems.zoneId),
  );

  $$QueueItemsTableProcessedTableManager get queueItemsRefs {
    final manager = $$QueueItemsTableTableManager(
      $_db,
      $_db.queueItems,
    ).filter((f) => f.zoneId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_queueItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ZonesTableFilterComposer extends Composer<_$TuneDatabase, $ZonesTable> {
  $$ZonesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outputType => $composableBuilder(
    column: $table.outputType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outputDeviceId => $composableBuilder(
    column: $table.outputDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get volume => $composableBuilder(
    column: $table.volume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncDelayMs => $composableBuilder(
    column: $table.syncDelayMs,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> queueItemsRefs(
    Expression<bool> Function($$QueueItemsTableFilterComposer f) f,
  ) {
    final $$QueueItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.queueItems,
      getReferencedColumn: (t) => t.zoneId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QueueItemsTableFilterComposer(
            $db: $db,
            $table: $db.queueItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ZonesTableOrderingComposer
    extends Composer<_$TuneDatabase, $ZonesTable> {
  $$ZonesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outputType => $composableBuilder(
    column: $table.outputType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outputDeviceId => $composableBuilder(
    column: $table.outputDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get volume => $composableBuilder(
    column: $table.volume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncDelayMs => $composableBuilder(
    column: $table.syncDelayMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ZonesTableAnnotationComposer
    extends Composer<_$TuneDatabase, $ZonesTable> {
  $$ZonesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get outputType => $composableBuilder(
    column: $table.outputType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get outputDeviceId => $composableBuilder(
    column: $table.outputDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get volume =>
      $composableBuilder(column: $table.volume, builder: (column) => column);

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<int> get syncDelayMs => $composableBuilder(
    column: $table.syncDelayMs,
    builder: (column) => column,
  );

  Expression<T> queueItemsRefs<T extends Object>(
    Expression<T> Function($$QueueItemsTableAnnotationComposer a) f,
  ) {
    final $$QueueItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.queueItems,
      getReferencedColumn: (t) => t.zoneId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QueueItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.queueItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ZonesTableTableManager
    extends
        RootTableManager<
          _$TuneDatabase,
          $ZonesTable,
          Zone,
          $$ZonesTableFilterComposer,
          $$ZonesTableOrderingComposer,
          $$ZonesTableAnnotationComposer,
          $$ZonesTableCreateCompanionBuilder,
          $$ZonesTableUpdateCompanionBuilder,
          (Zone, $$ZonesTableReferences),
          Zone,
          PrefetchHooks Function({bool queueItemsRefs})
        > {
  $$ZonesTableTableManager(_$TuneDatabase db, $ZonesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ZonesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ZonesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ZonesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> outputType = const Value.absent(),
                Value<String?> outputDeviceId = const Value.absent(),
                Value<double> volume = const Value.absent(),
                Value<String?> groupId = const Value.absent(),
                Value<int> syncDelayMs = const Value.absent(),
              }) => ZonesCompanion(
                id: id,
                name: name,
                outputType: outputType,
                outputDeviceId: outputDeviceId,
                volume: volume,
                groupId: groupId,
                syncDelayMs: syncDelayMs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> outputType = const Value.absent(),
                Value<String?> outputDeviceId = const Value.absent(),
                Value<double> volume = const Value.absent(),
                Value<String?> groupId = const Value.absent(),
                Value<int> syncDelayMs = const Value.absent(),
              }) => ZonesCompanion.insert(
                id: id,
                name: name,
                outputType: outputType,
                outputDeviceId: outputDeviceId,
                volume: volume,
                groupId: groupId,
                syncDelayMs: syncDelayMs,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ZonesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({queueItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (queueItemsRefs) db.queueItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (queueItemsRefs)
                    await $_getPrefetchedData<Zone, $ZonesTable, QueueItem>(
                      currentTable: table,
                      referencedTable: $$ZonesTableReferences
                          ._queueItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ZonesTableReferences(db, table, p0).queueItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.zoneId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ZonesTableProcessedTableManager =
    ProcessedTableManager<
      _$TuneDatabase,
      $ZonesTable,
      Zone,
      $$ZonesTableFilterComposer,
      $$ZonesTableOrderingComposer,
      $$ZonesTableAnnotationComposer,
      $$ZonesTableCreateCompanionBuilder,
      $$ZonesTableUpdateCompanionBuilder,
      (Zone, $$ZonesTableReferences),
      Zone,
      PrefetchHooks Function({bool queueItemsRefs})
    >;
typedef $$QueueItemsTableCreateCompanionBuilder =
    QueueItemsCompanion Function({
      Value<int> id,
      required int zoneId,
      required int trackId,
      required int position,
    });
typedef $$QueueItemsTableUpdateCompanionBuilder =
    QueueItemsCompanion Function({
      Value<int> id,
      Value<int> zoneId,
      Value<int> trackId,
      Value<int> position,
    });

final class $$QueueItemsTableReferences
    extends BaseReferences<_$TuneDatabase, $QueueItemsTable, QueueItem> {
  $$QueueItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ZonesTable _zoneIdTable(_$TuneDatabase db) => db.zones.createAlias(
    $_aliasNameGenerator(db.queueItems.zoneId, db.zones.id),
  );

  $$ZonesTableProcessedTableManager get zoneId {
    final $_column = $_itemColumn<int>('zone_id')!;

    final manager = $$ZonesTableTableManager(
      $_db,
      $_db.zones,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_zoneIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QueueItemsTableFilterComposer
    extends Composer<_$TuneDatabase, $QueueItemsTable> {
  $$QueueItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trackId => $composableBuilder(
    column: $table.trackId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$ZonesTableFilterComposer get zoneId {
    final $$ZonesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.zoneId,
      referencedTable: $db.zones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZonesTableFilterComposer(
            $db: $db,
            $table: $db.zones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QueueItemsTableOrderingComposer
    extends Composer<_$TuneDatabase, $QueueItemsTable> {
  $$QueueItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trackId => $composableBuilder(
    column: $table.trackId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$ZonesTableOrderingComposer get zoneId {
    final $$ZonesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.zoneId,
      referencedTable: $db.zones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZonesTableOrderingComposer(
            $db: $db,
            $table: $db.zones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QueueItemsTableAnnotationComposer
    extends Composer<_$TuneDatabase, $QueueItemsTable> {
  $$QueueItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get trackId =>
      $composableBuilder(column: $table.trackId, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$ZonesTableAnnotationComposer get zoneId {
    final $$ZonesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.zoneId,
      referencedTable: $db.zones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZonesTableAnnotationComposer(
            $db: $db,
            $table: $db.zones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QueueItemsTableTableManager
    extends
        RootTableManager<
          _$TuneDatabase,
          $QueueItemsTable,
          QueueItem,
          $$QueueItemsTableFilterComposer,
          $$QueueItemsTableOrderingComposer,
          $$QueueItemsTableAnnotationComposer,
          $$QueueItemsTableCreateCompanionBuilder,
          $$QueueItemsTableUpdateCompanionBuilder,
          (QueueItem, $$QueueItemsTableReferences),
          QueueItem,
          PrefetchHooks Function({bool zoneId})
        > {
  $$QueueItemsTableTableManager(_$TuneDatabase db, $QueueItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QueueItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QueueItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QueueItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> zoneId = const Value.absent(),
                Value<int> trackId = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => QueueItemsCompanion(
                id: id,
                zoneId: zoneId,
                trackId: trackId,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int zoneId,
                required int trackId,
                required int position,
              }) => QueueItemsCompanion.insert(
                id: id,
                zoneId: zoneId,
                trackId: trackId,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QueueItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({zoneId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (zoneId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.zoneId,
                                referencedTable: $$QueueItemsTableReferences
                                    ._zoneIdTable(db),
                                referencedColumn: $$QueueItemsTableReferences
                                    ._zoneIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$QueueItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$TuneDatabase,
      $QueueItemsTable,
      QueueItem,
      $$QueueItemsTableFilterComposer,
      $$QueueItemsTableOrderingComposer,
      $$QueueItemsTableAnnotationComposer,
      $$QueueItemsTableCreateCompanionBuilder,
      $$QueueItemsTableUpdateCompanionBuilder,
      (QueueItem, $$QueueItemsTableReferences),
      QueueItem,
      PrefetchHooks Function({bool zoneId})
    >;
typedef $$RadiosTableCreateCompanionBuilder =
    RadiosCompanion Function({
      Value<int> id,
      required String name,
      required String streamUrl,
      Value<String?> logoUrl,
      Value<String?> genre,
      Value<String?> tags,
      Value<String?> codec,
      Value<String?> country,
      Value<String?> homepageUrl,
      Value<bool> favorite,
    });
typedef $$RadiosTableUpdateCompanionBuilder =
    RadiosCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> streamUrl,
      Value<String?> logoUrl,
      Value<String?> genre,
      Value<String?> tags,
      Value<String?> codec,
      Value<String?> country,
      Value<String?> homepageUrl,
      Value<bool> favorite,
    });

class $$RadiosTableFilterComposer
    extends Composer<_$TuneDatabase, $RadiosTable> {
  $$RadiosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get streamUrl => $composableBuilder(
    column: $table.streamUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoUrl => $composableBuilder(
    column: $table.logoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codec => $composableBuilder(
    column: $table.codec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get homepageUrl => $composableBuilder(
    column: $table.homepageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RadiosTableOrderingComposer
    extends Composer<_$TuneDatabase, $RadiosTable> {
  $$RadiosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get streamUrl => $composableBuilder(
    column: $table.streamUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoUrl => $composableBuilder(
    column: $table.logoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codec => $composableBuilder(
    column: $table.codec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get homepageUrl => $composableBuilder(
    column: $table.homepageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RadiosTableAnnotationComposer
    extends Composer<_$TuneDatabase, $RadiosTable> {
  $$RadiosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get streamUrl =>
      $composableBuilder(column: $table.streamUrl, builder: (column) => column);

  GeneratedColumn<String> get logoUrl =>
      $composableBuilder(column: $table.logoUrl, builder: (column) => column);

  GeneratedColumn<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get codec =>
      $composableBuilder(column: $table.codec, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<String> get homepageUrl => $composableBuilder(
    column: $table.homepageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);
}

class $$RadiosTableTableManager
    extends
        RootTableManager<
          _$TuneDatabase,
          $RadiosTable,
          Radio,
          $$RadiosTableFilterComposer,
          $$RadiosTableOrderingComposer,
          $$RadiosTableAnnotationComposer,
          $$RadiosTableCreateCompanionBuilder,
          $$RadiosTableUpdateCompanionBuilder,
          (Radio, BaseReferences<_$TuneDatabase, $RadiosTable, Radio>),
          Radio,
          PrefetchHooks Function()
        > {
  $$RadiosTableTableManager(_$TuneDatabase db, $RadiosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RadiosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RadiosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RadiosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> streamUrl = const Value.absent(),
                Value<String?> logoUrl = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> codec = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<String?> homepageUrl = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
              }) => RadiosCompanion(
                id: id,
                name: name,
                streamUrl: streamUrl,
                logoUrl: logoUrl,
                genre: genre,
                tags: tags,
                codec: codec,
                country: country,
                homepageUrl: homepageUrl,
                favorite: favorite,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String streamUrl,
                Value<String?> logoUrl = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> codec = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<String?> homepageUrl = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
              }) => RadiosCompanion.insert(
                id: id,
                name: name,
                streamUrl: streamUrl,
                logoUrl: logoUrl,
                genre: genre,
                tags: tags,
                codec: codec,
                country: country,
                homepageUrl: homepageUrl,
                favorite: favorite,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RadiosTableProcessedTableManager =
    ProcessedTableManager<
      _$TuneDatabase,
      $RadiosTable,
      Radio,
      $$RadiosTableFilterComposer,
      $$RadiosTableOrderingComposer,
      $$RadiosTableAnnotationComposer,
      $$RadiosTableCreateCompanionBuilder,
      $$RadiosTableUpdateCompanionBuilder,
      (Radio, BaseReferences<_$TuneDatabase, $RadiosTable, Radio>),
      Radio,
      PrefetchHooks Function()
    >;
typedef $$MusicFoldersTableCreateCompanionBuilder =
    MusicFoldersCompanion Function({
      Value<int> id,
      required String path,
      Value<Uint8List?> bookmarkData,
      required String addedAt,
    });
typedef $$MusicFoldersTableUpdateCompanionBuilder =
    MusicFoldersCompanion Function({
      Value<int> id,
      Value<String> path,
      Value<Uint8List?> bookmarkData,
      Value<String> addedAt,
    });

class $$MusicFoldersTableFilterComposer
    extends Composer<_$TuneDatabase, $MusicFoldersTable> {
  $$MusicFoldersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get bookmarkData => $composableBuilder(
    column: $table.bookmarkData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MusicFoldersTableOrderingComposer
    extends Composer<_$TuneDatabase, $MusicFoldersTable> {
  $$MusicFoldersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get bookmarkData => $composableBuilder(
    column: $table.bookmarkData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MusicFoldersTableAnnotationComposer
    extends Composer<_$TuneDatabase, $MusicFoldersTable> {
  $$MusicFoldersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<Uint8List> get bookmarkData => $composableBuilder(
    column: $table.bookmarkData,
    builder: (column) => column,
  );

  GeneratedColumn<String> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$MusicFoldersTableTableManager
    extends
        RootTableManager<
          _$TuneDatabase,
          $MusicFoldersTable,
          MusicFolder,
          $$MusicFoldersTableFilterComposer,
          $$MusicFoldersTableOrderingComposer,
          $$MusicFoldersTableAnnotationComposer,
          $$MusicFoldersTableCreateCompanionBuilder,
          $$MusicFoldersTableUpdateCompanionBuilder,
          (
            MusicFolder,
            BaseReferences<_$TuneDatabase, $MusicFoldersTable, MusicFolder>,
          ),
          MusicFolder,
          PrefetchHooks Function()
        > {
  $$MusicFoldersTableTableManager(_$TuneDatabase db, $MusicFoldersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MusicFoldersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MusicFoldersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MusicFoldersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<Uint8List?> bookmarkData = const Value.absent(),
                Value<String> addedAt = const Value.absent(),
              }) => MusicFoldersCompanion(
                id: id,
                path: path,
                bookmarkData: bookmarkData,
                addedAt: addedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String path,
                Value<Uint8List?> bookmarkData = const Value.absent(),
                required String addedAt,
              }) => MusicFoldersCompanion.insert(
                id: id,
                path: path,
                bookmarkData: bookmarkData,
                addedAt: addedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MusicFoldersTableProcessedTableManager =
    ProcessedTableManager<
      _$TuneDatabase,
      $MusicFoldersTable,
      MusicFolder,
      $$MusicFoldersTableFilterComposer,
      $$MusicFoldersTableOrderingComposer,
      $$MusicFoldersTableAnnotationComposer,
      $$MusicFoldersTableCreateCompanionBuilder,
      $$MusicFoldersTableUpdateCompanionBuilder,
      (
        MusicFolder,
        BaseReferences<_$TuneDatabase, $MusicFoldersTable, MusicFolder>,
      ),
      MusicFolder,
      PrefetchHooks Function()
    >;
typedef $$SavedDevicesTableCreateCompanionBuilder =
    SavedDevicesCompanion Function({
      required String deviceId,
      required String name,
      required String type,
      required String host,
      required int port,
      Value<String?> capabilitiesJson,
      required String addedAt,
      Value<int> rowid,
    });
typedef $$SavedDevicesTableUpdateCompanionBuilder =
    SavedDevicesCompanion Function({
      Value<String> deviceId,
      Value<String> name,
      Value<String> type,
      Value<String> host,
      Value<int> port,
      Value<String?> capabilitiesJson,
      Value<String> addedAt,
      Value<int> rowid,
    });

class $$SavedDevicesTableFilterComposer
    extends Composer<_$TuneDatabase, $SavedDevicesTable> {
  $$SavedDevicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get host => $composableBuilder(
    column: $table.host,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get capabilitiesJson => $composableBuilder(
    column: $table.capabilitiesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavedDevicesTableOrderingComposer
    extends Composer<_$TuneDatabase, $SavedDevicesTable> {
  $$SavedDevicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get host => $composableBuilder(
    column: $table.host,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get capabilitiesJson => $composableBuilder(
    column: $table.capabilitiesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavedDevicesTableAnnotationComposer
    extends Composer<_$TuneDatabase, $SavedDevicesTable> {
  $$SavedDevicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get host =>
      $composableBuilder(column: $table.host, builder: (column) => column);

  GeneratedColumn<int> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<String> get capabilitiesJson => $composableBuilder(
    column: $table.capabilitiesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$SavedDevicesTableTableManager
    extends
        RootTableManager<
          _$TuneDatabase,
          $SavedDevicesTable,
          SavedDevice,
          $$SavedDevicesTableFilterComposer,
          $$SavedDevicesTableOrderingComposer,
          $$SavedDevicesTableAnnotationComposer,
          $$SavedDevicesTableCreateCompanionBuilder,
          $$SavedDevicesTableUpdateCompanionBuilder,
          (
            SavedDevice,
            BaseReferences<_$TuneDatabase, $SavedDevicesTable, SavedDevice>,
          ),
          SavedDevice,
          PrefetchHooks Function()
        > {
  $$SavedDevicesTableTableManager(_$TuneDatabase db, $SavedDevicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedDevicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedDevicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedDevicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> deviceId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> host = const Value.absent(),
                Value<int> port = const Value.absent(),
                Value<String?> capabilitiesJson = const Value.absent(),
                Value<String> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedDevicesCompanion(
                deviceId: deviceId,
                name: name,
                type: type,
                host: host,
                port: port,
                capabilitiesJson: capabilitiesJson,
                addedAt: addedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String deviceId,
                required String name,
                required String type,
                required String host,
                required int port,
                Value<String?> capabilitiesJson = const Value.absent(),
                required String addedAt,
                Value<int> rowid = const Value.absent(),
              }) => SavedDevicesCompanion.insert(
                deviceId: deviceId,
                name: name,
                type: type,
                host: host,
                port: port,
                capabilitiesJson: capabilitiesJson,
                addedAt: addedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavedDevicesTableProcessedTableManager =
    ProcessedTableManager<
      _$TuneDatabase,
      $SavedDevicesTable,
      SavedDevice,
      $$SavedDevicesTableFilterComposer,
      $$SavedDevicesTableOrderingComposer,
      $$SavedDevicesTableAnnotationComposer,
      $$SavedDevicesTableCreateCompanionBuilder,
      $$SavedDevicesTableUpdateCompanionBuilder,
      (
        SavedDevice,
        BaseReferences<_$TuneDatabase, $SavedDevicesTable, SavedDevice>,
      ),
      SavedDevice,
      PrefetchHooks Function()
    >;
typedef $$RadioFavoritesTableCreateCompanionBuilder =
    RadioFavoritesCompanion Function({
      Value<int> id,
      required String title,
      required String artist,
      required String stationName,
      required String streamUrl,
      Value<String?> coverPath,
      required String savedAt,
    });
typedef $$RadioFavoritesTableUpdateCompanionBuilder =
    RadioFavoritesCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> artist,
      Value<String> stationName,
      Value<String> streamUrl,
      Value<String?> coverPath,
      Value<String> savedAt,
    });

class $$RadioFavoritesTableFilterComposer
    extends Composer<_$TuneDatabase, $RadioFavoritesTable> {
  $$RadioFavoritesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artist => $composableBuilder(
    column: $table.artist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stationName => $composableBuilder(
    column: $table.stationName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get streamUrl => $composableBuilder(
    column: $table.streamUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RadioFavoritesTableOrderingComposer
    extends Composer<_$TuneDatabase, $RadioFavoritesTable> {
  $$RadioFavoritesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artist => $composableBuilder(
    column: $table.artist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stationName => $composableBuilder(
    column: $table.stationName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get streamUrl => $composableBuilder(
    column: $table.streamUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RadioFavoritesTableAnnotationComposer
    extends Composer<_$TuneDatabase, $RadioFavoritesTable> {
  $$RadioFavoritesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get artist =>
      $composableBuilder(column: $table.artist, builder: (column) => column);

  GeneratedColumn<String> get stationName => $composableBuilder(
    column: $table.stationName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get streamUrl =>
      $composableBuilder(column: $table.streamUrl, builder: (column) => column);

  GeneratedColumn<String> get coverPath =>
      $composableBuilder(column: $table.coverPath, builder: (column) => column);

  GeneratedColumn<String> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);
}

class $$RadioFavoritesTableTableManager
    extends
        RootTableManager<
          _$TuneDatabase,
          $RadioFavoritesTable,
          RadioFavorite,
          $$RadioFavoritesTableFilterComposer,
          $$RadioFavoritesTableOrderingComposer,
          $$RadioFavoritesTableAnnotationComposer,
          $$RadioFavoritesTableCreateCompanionBuilder,
          $$RadioFavoritesTableUpdateCompanionBuilder,
          (
            RadioFavorite,
            BaseReferences<_$TuneDatabase, $RadioFavoritesTable, RadioFavorite>,
          ),
          RadioFavorite,
          PrefetchHooks Function()
        > {
  $$RadioFavoritesTableTableManager(
    _$TuneDatabase db,
    $RadioFavoritesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RadioFavoritesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RadioFavoritesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RadioFavoritesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> artist = const Value.absent(),
                Value<String> stationName = const Value.absent(),
                Value<String> streamUrl = const Value.absent(),
                Value<String?> coverPath = const Value.absent(),
                Value<String> savedAt = const Value.absent(),
              }) => RadioFavoritesCompanion(
                id: id,
                title: title,
                artist: artist,
                stationName: stationName,
                streamUrl: streamUrl,
                coverPath: coverPath,
                savedAt: savedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String artist,
                required String stationName,
                required String streamUrl,
                Value<String?> coverPath = const Value.absent(),
                required String savedAt,
              }) => RadioFavoritesCompanion.insert(
                id: id,
                title: title,
                artist: artist,
                stationName: stationName,
                streamUrl: streamUrl,
                coverPath: coverPath,
                savedAt: savedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RadioFavoritesTableProcessedTableManager =
    ProcessedTableManager<
      _$TuneDatabase,
      $RadioFavoritesTable,
      RadioFavorite,
      $$RadioFavoritesTableFilterComposer,
      $$RadioFavoritesTableOrderingComposer,
      $$RadioFavoritesTableAnnotationComposer,
      $$RadioFavoritesTableCreateCompanionBuilder,
      $$RadioFavoritesTableUpdateCompanionBuilder,
      (
        RadioFavorite,
        BaseReferences<_$TuneDatabase, $RadioFavoritesTable, RadioFavorite>,
      ),
      RadioFavorite,
      PrefetchHooks Function()
    >;
typedef $$StreamingAuthTableCreateCompanionBuilder =
    StreamingAuthCompanion Function({
      required String service,
      required String tokenData,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$StreamingAuthTableUpdateCompanionBuilder =
    StreamingAuthCompanion Function({
      Value<String> service,
      Value<String> tokenData,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$StreamingAuthTableFilterComposer
    extends Composer<_$TuneDatabase, $StreamingAuthTable> {
  $$StreamingAuthTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get service => $composableBuilder(
    column: $table.service,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tokenData => $composableBuilder(
    column: $table.tokenData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StreamingAuthTableOrderingComposer
    extends Composer<_$TuneDatabase, $StreamingAuthTable> {
  $$StreamingAuthTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get service => $composableBuilder(
    column: $table.service,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tokenData => $composableBuilder(
    column: $table.tokenData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StreamingAuthTableAnnotationComposer
    extends Composer<_$TuneDatabase, $StreamingAuthTable> {
  $$StreamingAuthTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get service =>
      $composableBuilder(column: $table.service, builder: (column) => column);

  GeneratedColumn<String> get tokenData =>
      $composableBuilder(column: $table.tokenData, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$StreamingAuthTableTableManager
    extends
        RootTableManager<
          _$TuneDatabase,
          $StreamingAuthTable,
          StreamingAuthData,
          $$StreamingAuthTableFilterComposer,
          $$StreamingAuthTableOrderingComposer,
          $$StreamingAuthTableAnnotationComposer,
          $$StreamingAuthTableCreateCompanionBuilder,
          $$StreamingAuthTableUpdateCompanionBuilder,
          (
            StreamingAuthData,
            BaseReferences<
              _$TuneDatabase,
              $StreamingAuthTable,
              StreamingAuthData
            >,
          ),
          StreamingAuthData,
          PrefetchHooks Function()
        > {
  $$StreamingAuthTableTableManager(_$TuneDatabase db, $StreamingAuthTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StreamingAuthTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StreamingAuthTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StreamingAuthTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> service = const Value.absent(),
                Value<String> tokenData = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StreamingAuthCompanion(
                service: service,
                tokenData: tokenData,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String service,
                required String tokenData,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => StreamingAuthCompanion.insert(
                service: service,
                tokenData: tokenData,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StreamingAuthTableProcessedTableManager =
    ProcessedTableManager<
      _$TuneDatabase,
      $StreamingAuthTable,
      StreamingAuthData,
      $$StreamingAuthTableFilterComposer,
      $$StreamingAuthTableOrderingComposer,
      $$StreamingAuthTableAnnotationComposer,
      $$StreamingAuthTableCreateCompanionBuilder,
      $$StreamingAuthTableUpdateCompanionBuilder,
      (
        StreamingAuthData,
        BaseReferences<_$TuneDatabase, $StreamingAuthTable, StreamingAuthData>,
      ),
      StreamingAuthData,
      PrefetchHooks Function()
    >;
typedef $$StreamingConfigTableCreateCompanionBuilder =
    StreamingConfigCompanion Function({
      required String service,
      Value<bool> enabled,
      Value<String?> configJson,
      Value<String?> quality,
      Value<int> rowid,
    });
typedef $$StreamingConfigTableUpdateCompanionBuilder =
    StreamingConfigCompanion Function({
      Value<String> service,
      Value<bool> enabled,
      Value<String?> configJson,
      Value<String?> quality,
      Value<int> rowid,
    });

class $$StreamingConfigTableFilterComposer
    extends Composer<_$TuneDatabase, $StreamingConfigTable> {
  $$StreamingConfigTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get service => $composableBuilder(
    column: $table.service,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StreamingConfigTableOrderingComposer
    extends Composer<_$TuneDatabase, $StreamingConfigTable> {
  $$StreamingConfigTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get service => $composableBuilder(
    column: $table.service,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StreamingConfigTableAnnotationComposer
    extends Composer<_$TuneDatabase, $StreamingConfigTable> {
  $$StreamingConfigTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get service =>
      $composableBuilder(column: $table.service, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get quality =>
      $composableBuilder(column: $table.quality, builder: (column) => column);
}

class $$StreamingConfigTableTableManager
    extends
        RootTableManager<
          _$TuneDatabase,
          $StreamingConfigTable,
          StreamingConfigData,
          $$StreamingConfigTableFilterComposer,
          $$StreamingConfigTableOrderingComposer,
          $$StreamingConfigTableAnnotationComposer,
          $$StreamingConfigTableCreateCompanionBuilder,
          $$StreamingConfigTableUpdateCompanionBuilder,
          (
            StreamingConfigData,
            BaseReferences<
              _$TuneDatabase,
              $StreamingConfigTable,
              StreamingConfigData
            >,
          ),
          StreamingConfigData,
          PrefetchHooks Function()
        > {
  $$StreamingConfigTableTableManager(
    _$TuneDatabase db,
    $StreamingConfigTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StreamingConfigTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StreamingConfigTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StreamingConfigTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> service = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<String?> configJson = const Value.absent(),
                Value<String?> quality = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StreamingConfigCompanion(
                service: service,
                enabled: enabled,
                configJson: configJson,
                quality: quality,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String service,
                Value<bool> enabled = const Value.absent(),
                Value<String?> configJson = const Value.absent(),
                Value<String?> quality = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StreamingConfigCompanion.insert(
                service: service,
                enabled: enabled,
                configJson: configJson,
                quality: quality,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StreamingConfigTableProcessedTableManager =
    ProcessedTableManager<
      _$TuneDatabase,
      $StreamingConfigTable,
      StreamingConfigData,
      $$StreamingConfigTableFilterComposer,
      $$StreamingConfigTableOrderingComposer,
      $$StreamingConfigTableAnnotationComposer,
      $$StreamingConfigTableCreateCompanionBuilder,
      $$StreamingConfigTableUpdateCompanionBuilder,
      (
        StreamingConfigData,
        BaseReferences<
          _$TuneDatabase,
          $StreamingConfigTable,
          StreamingConfigData
        >,
      ),
      StreamingConfigData,
      PrefetchHooks Function()
    >;

class $TuneDatabaseManager {
  final _$TuneDatabase _db;
  $TuneDatabaseManager(this._db);
  $$ArtistsTableTableManager get artists =>
      $$ArtistsTableTableManager(_db, _db.artists);
  $$AlbumsTableTableManager get albums =>
      $$AlbumsTableTableManager(_db, _db.albums);
  $$TracksTableTableManager get tracks =>
      $$TracksTableTableManager(_db, _db.tracks);
  $$PlaylistsTableTableManager get playlists =>
      $$PlaylistsTableTableManager(_db, _db.playlists);
  $$PlaylistTracksTableTableManager get playlistTracks =>
      $$PlaylistTracksTableTableManager(_db, _db.playlistTracks);
  $$ZonesTableTableManager get zones =>
      $$ZonesTableTableManager(_db, _db.zones);
  $$QueueItemsTableTableManager get queueItems =>
      $$QueueItemsTableTableManager(_db, _db.queueItems);
  $$RadiosTableTableManager get radios =>
      $$RadiosTableTableManager(_db, _db.radios);
  $$MusicFoldersTableTableManager get musicFolders =>
      $$MusicFoldersTableTableManager(_db, _db.musicFolders);
  $$SavedDevicesTableTableManager get savedDevices =>
      $$SavedDevicesTableTableManager(_db, _db.savedDevices);
  $$RadioFavoritesTableTableManager get radioFavorites =>
      $$RadioFavoritesTableTableManager(_db, _db.radioFavorites);
  $$StreamingAuthTableTableManager get streamingAuth =>
      $$StreamingAuthTableTableManager(_db, _db.streamingAuth);
  $$StreamingConfigTableTableManager get streamingConfig =>
      $$StreamingConfigTableTableManager(_db, _db.streamingConfig);
}
