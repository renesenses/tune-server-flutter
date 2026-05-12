// ignore_for_file: invalid_use_of_protected_member

part of 'metadata_view.dart';

// Extension _MetadataViewState — view builders appelés depuis build() :
// - _buildCompletenessCards : 4 cartes cliquables (cover/genre/année/artiste)
// - _buildFilterChips : ChoiceChips Tous/Covers/Genre/Année/Artiste/Douteux
// - _buildSearchAndDropdowns : TextField recherche + 2 DropdownButton
//   (artiste / genre)
// - _buildAlbumList : liste filtrée (max 50, message si plus)
// - _buildAlbumCard : carte album (read-only ou edit mode)
// - _buildEditMode : formulaire édition inline
// - _buildDuplicateGroup : carte d'un groupe d'albums dupliqués
// - _reasonLabel : map raison « douteux » → libellé FR

extension _MetadataViewStateBuilders on _MetadataViewState {

  // ---------------------------------------------------------------------------
  // Completeness Cards (clickable)
  // ---------------------------------------------------------------------------

  Widget _buildCompletenessCards() {
    if (_loadingCompleteness && _completeness == null) {
      return Container(
        color: TuneColors.surface,
        padding: const EdgeInsets.all(20),
        child: const Center(
          child: CircularProgressIndicator(color: TuneColors.accent),
        ),
      );
    }
    if (_completeness == null) {
      return Container(
        color: TuneColors.surface,
        padding: const EdgeInsets.all(16),
        child: Text(
          'Statistiques indisponibles',
          style: TuneFonts.footnote.copyWith(color: TuneColors.textTertiary),
        ),
      );
    }

    final totalAlbums = (_completeness!['total_albums'] ?? 0) as int;
    final totalTracks = (_completeness!['total_tracks'] ?? 0) as int;
    final noCover = (_completeness!['albums_without_cover'] ?? 0) as int;
    final noGenre = (_completeness!['albums_without_genre'] ?? 0) as int;
    final noYear = (_completeness!['albums_without_year'] ?? 0) as int;
    final noArtist = (_completeness!['tracks_without_artist'] ?? 0) as int;

    return Container(
      color: TuneColors.surface,
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _CompletenessCard(
            icon: Icons.image_rounded,
            label: 'Cover',
            missing: noCover,
            total: totalAlbums,
            color: TuneColors.accent,
            active: _filter == _MetaFilter.noCover,
            onTap: () => setState(() => _filter = _MetaFilter.noCover),
          ),
          _CompletenessCard(
            icon: Icons.category_rounded,
            label: 'Genre',
            missing: noGenre,
            total: totalAlbums,
            color: TuneColors.warning,
            active: _filter == _MetaFilter.noGenre,
            onTap: () => setState(() => _filter = _MetaFilter.noGenre),
          ),
          _CompletenessCard(
            icon: Icons.calendar_today_rounded,
            label: 'Année',
            missing: noYear,
            total: totalAlbums,
            color: TuneColors.accentLight,
            active: _filter == _MetaFilter.noYear,
            onTap: () => setState(() => _filter = _MetaFilter.noYear),
          ),
          _CompletenessCard(
            icon: Icons.person_rounded,
            label: 'Artiste',
            missing: noArtist,
            total: totalTracks,
            color: TuneColors.success,
            active: _filter == _MetaFilter.noArtist,
            onTap: () => setState(() => _filter = _MetaFilter.noArtist),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Filter chips for Corriger section
  // ---------------------------------------------------------------------------

  Widget _buildFilterChips() {
    return Container(
      color: TuneColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _filterChip('Tous', _MetaFilter.all),
            _filterChip('Covers manquantes', _MetaFilter.noCover),
            _filterChip('Genre manquant', _MetaFilter.noGenre),
            _filterChip('Année manquante', _MetaFilter.noYear),
            _filterChip('Artiste manquant', _MetaFilter.noArtist),
            _filterChip('Douteux', _MetaFilter.doubtful),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, _MetaFilter filter) {
    final selected = _filter == filter;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: TuneFonts.caption.copyWith(
          color: selected ? TuneColors.textPrimary : TuneColors.textSecondary,
        )),
        selected: selected,
        selectedColor: TuneColors.accent.withValues(alpha: 0.3),
        backgroundColor: TuneColors.surfaceVariant,
        side: BorderSide.none,
        onSelected: (_) {
          setState(() {
            _filter = filter;
            if (filter == _MetaFilter.doubtful && _doubtfulAlbums.isEmpty) {
              _loadDoubtful();
            }
          });
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Search + Artist/Genre dropdowns
  // ---------------------------------------------------------------------------

  Widget _buildSearchAndDropdowns() {
    return Container(
      color: TuneColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        children: [
          // Search text field
          TextField(
            controller: _searchCtrl,
            style: TuneFonts.body,
            decoration: InputDecoration(
              hintText: 'Rechercher des albums…',
              hintStyle: TuneFonts.body.copyWith(color: TuneColors.textTertiary),
              prefixIcon: const Icon(Icons.search_rounded,
                  color: TuneColors.textTertiary, size: 20),
              filled: true,
              fillColor: TuneColors.surfaceVariant,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              isDense: true,
              suffixIcon: _searchCtrl.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded,
                          size: 18, color: TuneColors.textTertiary),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() {});
                      },
                    )
                  : null,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          // Dropdowns row
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  value: _filterArtist.isEmpty ? null : _filterArtist,
                  hint: 'Tous les artistes',
                  items: _distinctArtists,
                  onChanged: (v) => setState(() => _filterArtist = v ?? ''),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDropdown(
                  value: _filterGenre.isEmpty ? null : _filterGenre,
                  hint: 'Tous les genres',
                  items: _distinctGenres,
                  onChanged: (v) => setState(() => _filterGenre = v ?? ''),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: TuneColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint,
              style: TuneFonts.caption.copyWith(color: TuneColors.textTertiary)),
          isExpanded: true,
          dropdownColor: TuneColors.surfaceHigh,
          style: TuneFonts.caption.copyWith(color: TuneColors.textPrimary),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: TuneColors.textTertiary, size: 18),
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text(hint, style: TuneFonts.caption
                  .copyWith(color: TuneColors.textTertiary)),
            ),
            ...items.map((s) => DropdownMenuItem(value: s, child: Text(s))),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Album cards list (unified view)
  // ---------------------------------------------------------------------------

  Widget _buildAlbumList() {
    if (_loadingAlbums && _allAlbums.isEmpty) {
      return Container(
        color: TuneColors.surface,
        padding: const EdgeInsets.all(20),
        child: const Center(
          child: CircularProgressIndicator(color: TuneColors.accent),
        ),
      );
    }
    if (_filter == _MetaFilter.doubtful && _loadingDoubtful) {
      return Container(
        color: TuneColors.surface,
        padding: const EdgeInsets.all(20),
        child: const Center(
          child: CircularProgressIndicator(color: TuneColors.accent),
        ),
      );
    }

    final albums = _filteredAlbums;
    if (albums.isEmpty) {
      return Container(
        color: TuneColors.surface,
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            'Aucun album correspondant',
            style: TuneFonts.body.copyWith(color: TuneColors.textTertiary),
          ),
        ),
      );
    }

    return Container(
      color: TuneColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              '${albums.length} albums',
              style: TuneFonts.caption,
            ),
          ),
          // Show max 50 at a time for performance
          ...albums.take(50).map((album) => _buildAlbumCard(album)),
          if (albums.length > 50)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '... et ${albums.length - 50} autres albums (filtrez pour affiner)',
                style: TuneFonts.caption,
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Single album card
  // ---------------------------------------------------------------------------

  Widget _buildAlbumCard(Map<String, dynamic> album) {
    final albumId = album['id'] as int;
    final isEditing = _editingAlbumId == albumId;
    final coverUrl = _coverUrl(album);
    final title = album['title'] ?? '';
    final artist = album['artist_name'] ?? '';
    final genre = album['genre'] ?? '';
    final year = album['year'];
    final folderPath = album['folder_path'] ?? '';
    final trackCount = album['track_count'];

    // Missing metadata tags
    final missingTags = <String>[];
    final coverPath = album['cover_path']?.toString() ?? '';
    if (coverPath.isEmpty) {
      missingTags.add('Cover');
    }
    if (genre.isEmpty) missingTags.add('Genre');
    if (year == null || year == 0) missingTags.add('Année');
    if (artist.isEmpty || artist == 'Unknown Artist') {
      missingTags.add('Artiste');
    }

    // Doubtful reasons
    final reasons = album['reasons'];

    return Column(
      children: [
        const Divider(height: 1, color: TuneColors.divider),
        if (isEditing) _buildEditMode(album) else
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover thumbnail (tappable)
              GestureDetector(
                onTap: () {
                  if (coverUrl != null) {
                    setState(() => _zoomCoverUrl = coverUrl);
                  } else {
                    _uploadCover(albumId);
                  }
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: TuneColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: coverUrl != null
                      ? Image.network(
                          coverUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.album_rounded,
                            color: TuneColors.textTertiary,
                            size: 28,
                          ),
                        )
                      : const Icon(
                          Icons.add_photo_alternate_outlined,
                          color: TuneColors.textTertiary,
                          size: 28,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TuneFonts.callout
                          .copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (artist.isNotEmpty)
                      Text(
                        artist,
                        style: TuneFonts.footnote,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    Row(
                      children: [
                        if (genre.isNotEmpty)
                          Text('$genre', style: TuneFonts.caption),
                        if (genre.isNotEmpty &&
                            year != null &&
                            year != 0)
                          Text(' · ', style: TuneFonts.caption),
                        if (year != null && year != 0)
                          Text('$year', style: TuneFonts.caption),
                        if (trackCount != null) ...[
                          Text(' · ', style: TuneFonts.caption),
                          Text('$trackCount pistes',
                              style: TuneFonts.caption),
                        ],
                      ],
                    ),
                    if (folderPath.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          folderPath,
                          style: TuneFonts.caption.copyWith(
                              color: TuneColors.textTertiary, fontSize: 10),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    // Missing metadata tags
                    if (missingTags.isNotEmpty || reasons != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            ...missingTags.map((tag) => _MetadataTag(tag)),
                            if (reasons != null)
                              ...(reasons as List).map(
                                (r) => _MetadataTag(
                                    _reasonLabel(r.toString())),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              // Actions
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_rounded,
                        size: 18, color: TuneColors.accent),
                    tooltip: 'Modifier',
                    onPressed: () => _startEdit(album),
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_photo_alternate_outlined,
                        size: 18, color: TuneColors.textSecondary),
                    tooltip: 'Upload cover',
                    onPressed: () => _uploadCover(albumId),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Edit mode for album card
  // ---------------------------------------------------------------------------

  Widget _buildEditMode(Map<String, dynamic> album) {
    final albumId = album['id'] as int;
    final coverUrl = _coverUrl(album);

    return Container(
      padding: const EdgeInsets.all(16),
      color: TuneColors.surfaceVariant.withValues(alpha: 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover
              GestureDetector(
                onTap: () => _uploadCover(albumId),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: TuneColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: coverUrl != null
                      ? Image.network(coverUrl, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                              Icons.album_rounded,
                              color: TuneColors.textTertiary,
                              size: 32))
                      : const Icon(Icons.add_photo_alternate_outlined,
                          color: TuneColors.textTertiary, size: 32),
                ),
              ),
              const SizedBox(width: 12),
              // Fields
              Expanded(
                child: Column(
                  children: [
                    _editField('Artiste', _editArtist),
                    const SizedBox(height: 6),
                    _editField('Album', _editTitle),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(child: _editField('Genre', _editGenre)),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 80,
                          child: _editField('Année', _editYear,
                              keyboardType: TextInputType.number),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action buttons
          Row(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: TuneColors.accent,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.check_rounded, size: 16),
                label: Text('Enregistrer', style: TuneFonts.footnote
                    .copyWith(color: Colors.white)),
                onPressed: _saveEdit,
              ),
              const SizedBox(width: 8),
              if (_savedAlbumId == albumId)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TuneColors.warning.withValues(alpha: 0.2),
                    foregroundColor: TuneColors.warning,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.save_alt_rounded, size: 16),
                  label:
                      Text('Graver tags', style: TuneFonts.footnote),
                  onPressed: () => _writeAlbumTags(albumId),
                ),
              const Spacer(),
              TextButton(
                onPressed: _cancelEdit,
                child: Text('Annuler',
                    style: TuneFonts.footnote
                        .copyWith(color: TuneColors.textSecondary)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _editField(String label, TextEditingController ctrl,
      {TextInputType? keyboardType}) {
    return TextField(
      controller: ctrl,
      style: TuneFonts.footnote.copyWith(color: TuneColors.textPrimary),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TuneFonts.caption,
        filled: true,
        fillColor: TuneColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        isDense: true,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Duplicate group card
  // ---------------------------------------------------------------------------

  Widget _buildDuplicateGroup(List<Map<String, dynamic>> group) {
    final first = group.first;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: TuneColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${first['title'] ?? ''} — ${first['artist_name'] ?? ''}',
                    style: TuneFonts.callout
                        .copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _ActionButton(
                  icon: Icons.merge_rounded,
                  label: 'Fusionner',
                  loading: false,
                  onPressed: () => _mergeGroup(group),
                ),
              ],
            ),
          ),
          ...group.map((a) {
            final tc = a['track_count'] ?? '?';
            final fp = a['folder_path'] ?? '';
            return Padding(
              padding: const EdgeInsets.fromLTRB(12, 2, 12, 4),
              child: Row(
                children: [
                  const Icon(Icons.album_rounded,
                      size: 14, color: TuneColors.textTertiary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$tc pistes${fp.isNotEmpty ? ' — $fp' : ''}',
                      style: TuneFonts.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _reasonLabel(String reason) {
    const labels = {
      'artist_uppercase': 'Artiste MAJ',
      'artist_placeholder': 'Artiste provisoire',
      'artist_has_year': 'Artiste = dossier',
      'genre_placeholder': 'Genre provisoire',
      'year_suspicious': 'Année suspecte',
      'title_uppercase': 'Titre MAJ',
      'artist_mismatch': 'Artiste différent',
    };
    return labels[reason] ?? reason;
  }
}
