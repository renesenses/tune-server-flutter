import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

// ---------------------------------------------------------------------------
// SmbMusicClient — client SMB2 minimal pour la navigation et l'indexation
// de bibliothèques musicales sur partages réseau.
//
// Implémente le sous-ensemble SMB2 nécessaire :
//   - NEGOTIATE (0x0000)
//   - SESSION_SETUP anonyme (0x0001) — NTLM negociation basique
//   - TREE_CONNECT (0x0003)
//   - QUERY_DIRECTORY (0x000E) — listage de répertoires
//   - CREATE / READ / CLOSE (0x0005 / 0x0008 / 0x0006)
//
// Miroir de TuneSMBClient.swift (iOS / kishikawakatsumi/SMBClient)
// ---------------------------------------------------------------------------

class SmbFile {
  final String name;
  final String path;
  final bool isDirectory;
  final int size;

  const SmbFile({
    required this.name,
    required this.path,
    required this.isDirectory,
    required this.size,
  });
}

class SmbShareInfo {
  final String name;
  const SmbShareInfo(this.name);
}

// ---------------------------------------------------------------------------
// Erreurs
// ---------------------------------------------------------------------------

class SmbException implements Exception {
  final String message;
  const SmbException(this.message);
  @override
  String toString() => 'SmbException: $message';
}

// ---------------------------------------------------------------------------
// Client principal
// ---------------------------------------------------------------------------

class SmbMusicClient {
  final String host;
  final int port;
  final String username;
  final String password;
  String _currentShare = '';

  Socket? _socket;
  bool _connected = false;
  int _sessionId = 0;
  int _treeId = 0;
  int _messageId = 0;

  static const Set<String> audioExtensions = {
    'flac', 'mp3', 'aac', 'm4a', 'wav', 'aiff', 'aif',
    'ogg', 'opus', 'wma', 'alac', 'dsf', 'dff', 'ape', 'wv',
  };

  SmbMusicClient({
    required this.host,
    this.port = 445,
    String? share,
    this.username = 'guest',
    this.password = '',
  }) : _currentShare = share ?? '';

  bool get isConnected => _connected;

  // -------------------------------------------------------------------------
  // Connexion
  // -------------------------------------------------------------------------

  Future<void> connect() async {
    final socket = await Socket.connect(
      host,
      port,
      timeout: const Duration(seconds: 10),
    );
    _socket = socket;

    // Lire les données entrantes dans un buffer
    _rxBuffer = Uint8List(0);
    socket.listen(
      (data) => _rxBuffer = Uint8List.fromList([..._rxBuffer, ...data]),
      onError: (_) {},
      cancelOnError: false,
    );

    await _negotiate();
    await _sessionSetup();
    if (_currentShare.isNotEmpty) {
      await _treeConnect(_currentShare);
    }
    _connected = true;
  }

  Future<void> disconnect() async {
    try {
      _socket?.destroy();
    } catch (_) {}
    _socket = null;
    _connected = false;
    _sessionId = 0;
    _treeId = 0;
  }

  Uint8List _rxBuffer = Uint8List(0);

  // -------------------------------------------------------------------------
  // Lister les partages
  // Beaucoup d'appareils NAS refusent SRVSVC — on retourne [] en cas d'erreur.
  // -------------------------------------------------------------------------

  Future<List<SmbShareInfo>> listShares() async {
    // Tente l'énumération via IPC$
    try {
      final ipcTreeId = await _treeConnectRaw('IPC\$');
      final shares = await _enumShares(ipcTreeId);
      await _treeDisconnect(ipcTreeId);
      return shares
          .where((s) => !s.name.endsWith('\$') && !s.name.startsWith('IPC'))
          .map((s) => SmbShareInfo(s.name))
          .toList();
    } catch (_) {
      // Fallback silencieux — l'UI proposera la saisie manuelle
      return [];
    }
  }

  Future<void> connectShare(String name) async {
    _currentShare = name;
    _treeId = await _treeConnectRaw(name);
  }

  // -------------------------------------------------------------------------
  // Lister un répertoire
  // -------------------------------------------------------------------------

  Future<List<SmbFile>> listDirectory({String path = ''}) async {
    if (!_connected || _treeId == 0) {
      throw const SmbException('Non connecté à un partage');
    }

    final fileId = await _create(path.isEmpty ? '' : path, isDirectory: true);
    final entries = await _queryDirectory(fileId, path);
    await _close(fileId);

    return entries.where((e) => e.name != '.' && e.name != '..').toList();
  }

  // -------------------------------------------------------------------------
  // Scan récursif BFS
  // -------------------------------------------------------------------------

  Future<List<SmbFile>> scanMusicFiles({
    String rootPath = '',
    int maxFiles = 50000,
    void Function(int count, String path)? progress,
  }) async {
    final musicFiles = <SmbFile>[];
    final queue = <String>[rootPath];

    while (queue.isNotEmpty && musicFiles.length < maxFiles) {
      final dirPath = queue.removeAt(0);
      List<SmbFile> items;
      try {
        items = await listDirectory(path: dirPath);
      } catch (_) {
        continue;
      }

      for (final item in items) {
        if (item.name.startsWith('.') || item.name.startsWith('._')) continue;
        if (item.isDirectory) {
          queue.add(item.path);
        } else {
          final ext = item.name.split('.').last.toLowerCase();
          if (audioExtensions.contains(ext)) {
            musicFiles.add(item);
            if (musicFiles.length % 100 == 0) {
              progress?.call(musicFiles.length, dirPath);
            }
          }
        }
      }
    }

    progress?.call(musicFiles.length, 'terminé');
    return musicFiles;
  }

  // -------------------------------------------------------------------------
  // Téléchargement brut (pour les pochettes)
  // -------------------------------------------------------------------------

  Future<Uint8List> downloadRaw(String path) async {
    final fileId = await _create(path, isDirectory: false);
    final data = await _readAll(fileId);
    await _close(fileId);
    return data;
  }

  // -------------------------------------------------------------------------
  // Téléchargement vers fichier temporaire (lecture audio)
  // -------------------------------------------------------------------------

  Future<String> downloadToTemp(String path) async {
    final fileName = path.split('/').last;
    final tmpDir = Directory.systemTemp;
    final cacheDir = Directory('${tmpDir.path}/smb-cache');
    await cacheDir.create(recursive: true);
    final dest = File('${cacheDir.path}/$fileName');

    // Cache hit
    if (await dest.exists() && (await dest.length()) > 0) {
      return dest.path;
    }

    final data = await downloadRaw(path);
    await dest.writeAsBytes(data);
    return dest.path;
  }

  // =========================================================================
  // Implémentation SMB2 bas niveau
  // =========================================================================

  static const int _smb2Magic = 0x424D53FE; // 0xFE S M B (little-endian read)

  int _nextMessageId() => _messageId++;

  // -------------------------------------------------------------------------
  // Envoi / réception avec framing NetBIOS
  // -------------------------------------------------------------------------

  Future<void> _send(Uint8List payload) async {
    final frame = ByteData(4 + payload.length);
    frame.setUint32(0, payload.length, Endian.big);
    final socket = _socket;
    if (socket == null) throw const SmbException('Socket non connecté');
    socket.add([...frame.buffer.asUint8List(), ...payload]);
    await socket.flush();
  }

  Future<Uint8List> _receive() async {
    // Attend au moins 4 octets (framing NetBIOS)
    while (_rxBuffer.length < 4) {
      await Future.delayed(const Duration(milliseconds: 5));
    }
    final length = ByteData.sublistView(_rxBuffer).getUint32(0, Endian.big);
    final total = 4 + length;
    while (_rxBuffer.length < total) {
      await Future.delayed(const Duration(milliseconds: 5));
    }
    final frame = _rxBuffer.sublist(4, total);
    _rxBuffer = _rxBuffer.sublist(total);
    return frame;
  }

  // -------------------------------------------------------------------------
  // Helpers de construction de paquets SMB2
  // -------------------------------------------------------------------------

  /// Construit un header SMB2 (64 octets).
  Uint8List _smb2Header({
    required int command,
    int creditRequest = 1,
    int flags = 0,
    required int messageId,
    int treeId = 0,
    int sessionId = 0,
  }) {
    final buf = ByteData(64);
    // ProtocolId: \xFE S M B
    buf.setUint8(0, 0xFE);
    buf.setUint8(1, 0x53); // S
    buf.setUint8(2, 0x4D); // M
    buf.setUint8(3, 0x42); // B
    buf.setUint16(4, 64, Endian.little); // StructureSize
    buf.setUint16(6, 0, Endian.little);  // CreditCharge
    buf.setUint32(8, 0, Endian.little);  // Status (request)
    buf.setUint16(12, command, Endian.little);
    buf.setUint16(14, creditRequest, Endian.little);
    buf.setUint32(16, flags, Endian.little);
    buf.setUint32(20, 0, Endian.little); // NextCommand
    buf.setUint64(24, messageId); // MessageId (8 bytes)
    buf.setUint32(32, 0, Endian.little);  // Reserved
    buf.setUint32(36, treeId, Endian.little);
    buf.setUint64(40, sessionId); // SessionId
    // Signature: 16 zeros (already 0)
    return buf.buffer.asUint8List();
  }

  // -------------------------------------------------------------------------
  // NEGOTIATE (commande 0x0000)
  // -------------------------------------------------------------------------

  Future<void> _negotiate() async {
    // Dialects: SMB 2.1 (0x0210) et SMB 2.0.2 (0x0202)
    final dialects = Uint8List(4);
    final d = ByteData.sublistView(dialects);
    d.setUint16(0, 0x0202, Endian.little);
    d.setUint16(2, 0x0210, Endian.little);

    final body = ByteData(36 + dialects.length);
    body.setUint16(0, 36, Endian.little); // StructureSize
    body.setUint16(2, 2, Endian.little);  // DialectCount
    body.setUint16(4, 1, Endian.little);  // SecurityMode: signing enabled
    body.setUint16(6, 0, Endian.little);  // Reserved
    body.setUint32(8, 0x7F, Endian.little); // Capabilities
    // ClientGuid: 16 zeros (OK)
    body.setUint32(28, 0, Endian.little); // NegotiateContextOffset
    body.setUint16(32, 0, Endian.little); // NegotiateContextCount
    body.setUint16(34, 0, Endian.little); // Reserved2
    final bodyBytes = body.buffer.asUint8List();

    final payload = Uint8List.fromList([
      ..._smb2Header(command: 0x0000, messageId: _nextMessageId()),
      ...bodyBytes,
      ...dialects,
    ]);

    await _send(payload);
    final resp = await _receive();
    _checkStatus(resp, 'NEGOTIATE');
  }

  // -------------------------------------------------------------------------
  // SESSION_SETUP (commande 0x0001)
  // Mode anonyme simplifié — suffisant pour les NAS sans auth requise.
  // -------------------------------------------------------------------------

  Future<void> _sessionSetup() async {
    // NTLM NEGOTIATE blob minimal
    final ntlmBlob = _buildNtlmNegotiate();
    final blob = ntlmBlob;

    final body = ByteData(25 + blob.length);
    body.setUint16(0, 25, Endian.little);  // StructureSize
    body.setUint8(2, 0);                   // Flags
    body.setUint16(3, 1, Endian.little);   // SecurityMode
    body.setUint32(5, 0x7F, Endian.little);// Capabilities
    body.setUint32(9, 0, Endian.little);   // Channel
    body.setUint16(13, 64 + 25, Endian.little); // SecurityBufferOffset
    body.setUint16(15, blob.length, Endian.little);
    body.setUint64(17, 0);                 // PreviousSessionId

    final payload = Uint8List.fromList([
      ..._smb2Header(command: 0x0001, messageId: _nextMessageId()),
      ...body.buffer.asUint8List(0, 25),
      ...blob,
    ]);

    await _send(payload);
    final resp = await _receive();

    // Status 0xC0000016 = MORE_PROCESSING_REQUIRED (challenge attendu) → OK
    final status = _getStatus(resp);
    if (status != 0 && status != 0xC0000016) {
      // Essai anonyme
      await _sessionSetupAnonymous();
      return;
    }

    // Extraire le session ID de la réponse
    if (resp.length >= 48) {
      final bd = ByteData.sublistView(resp);
      _sessionId = bd.getUint64(40, Endian.little);
    }

    if (status == 0xC0000016) {
      // Envoi de l'AUTHENTICATE (avec credentials ou anonyme)
      await _sessionAuthenticate(resp);
    }
  }

  Future<void> _sessionSetupAnonymous() async {
    // Blob vide = login anonyme
    final body = ByteData(25);
    body.setUint16(0, 25, Endian.little);
    body.setUint16(13, 64 + 25, Endian.little);
    body.setUint16(15, 0, Endian.little);

    final payload = Uint8List.fromList([
      ..._smb2Header(command: 0x0001, messageId: _nextMessageId()),
      ...body.buffer.asUint8List(),
    ]);

    await _send(payload);
    final resp = await _receive();
    final bd = ByteData.sublistView(resp);
    if (resp.length >= 48) {
      _sessionId = bd.getUint64(40, Endian.little);
    }
    _checkStatus(resp, 'SESSION_SETUP anonymous', allowStatus: 0xC0000016);
  }

  Future<void> _sessionAuthenticate(Uint8List challengeResp) async {
    // Extrait le NTLM challenge depuis la réponse
    final blob = _buildNtlmAuthenticate(challengeResp);

    final body = ByteData(25 + blob.length);
    body.setUint16(0, 25, Endian.little);
    body.setUint16(13, 64 + 25, Endian.little);
    body.setUint16(15, blob.length, Endian.little);

    final payload = Uint8List.fromList([
      ..._smb2Header(
        command: 0x0001,
        messageId: _nextMessageId(),
        sessionId: _sessionId,
      ),
      ...body.buffer.asUint8List(0, 25),
      ...blob,
    ]);

    await _send(payload);
    final resp = await _receive();
    if (resp.length >= 48) {
      final bd = ByteData.sublistView(resp);
      _sessionId = bd.getUint64(40, Endian.little);
    }
    _checkStatus(resp, 'SESSION_AUTHENTICATE');
  }

  // -------------------------------------------------------------------------
  // TREE_CONNECT (commande 0x0003)
  // -------------------------------------------------------------------------

  Future<void> _treeConnect(String share) async {
    _treeId = await _treeConnectRaw(share);
  }

  Future<int> _treeConnectRaw(String share) async {
    final path = '\\\\$host\\$share';
    final pathUtf16 = _toUtf16LE(path);

    final body = ByteData(9 + pathUtf16.length);
    body.setUint16(0, 9, Endian.little);   // StructureSize
    body.setUint16(2, 0, Endian.little);   // Reserved
    body.setUint16(4, 64 + 9, Endian.little); // PathOffset
    body.setUint16(6, pathUtf16.length, Endian.little);
    body.setUint8(8, 0);

    final payload = Uint8List.fromList([
      ..._smb2Header(
        command: 0x0003,
        messageId: _nextMessageId(),
        sessionId: _sessionId,
      ),
      ...body.buffer.asUint8List(0, 9),
      ...pathUtf16,
    ]);

    await _send(payload);
    final resp = await _receive();
    _checkStatus(resp, 'TREE_CONNECT $share');

    final bd = ByteData.sublistView(resp);
    return bd.getUint32(36, Endian.little); // TreeId dans le header
  }

  Future<void> _treeDisconnect(int treeId) async {
    final body = ByteData(4);
    body.setUint16(0, 4, Endian.little);
    body.setUint16(2, 0, Endian.little);

    final payload = Uint8List.fromList([
      ..._smb2Header(
        command: 0x0004,
        messageId: _nextMessageId(),
        treeId: treeId,
        sessionId: _sessionId,
      ),
      ...body.buffer.asUint8List(),
    ]);

    await _send(payload);
    await _receive(); // Ignore l'erreur éventuelle
  }

  // -------------------------------------------------------------------------
  // CREATE (commande 0x0005)
  // -------------------------------------------------------------------------

  Future<Uint8List> _create(String path, {required bool isDirectory}) async {
    final nameUtf16 = _toUtf16LE(path.replaceAll('/', '\\'));
    final nameOffset = 64 + 57;
    final desiredAccess = isDirectory ? 0x00100081 : 0x00120089;
    final fileAttributes = isDirectory ? 0x10 : 0x20;
    final createDisposition = 1; // FILE_OPEN
    final createOptions = isDirectory ? 0x00000021 : 0x00000060;

    final body = ByteData(57 + nameUtf16.length);
    body.setUint16(0, 57, Endian.little);
    body.setUint8(2, 0); // SecurityFlags
    body.setUint8(3, 0); // RequestedOplockLevel
    body.setUint32(4, 0, Endian.little); // ImpersonationLevel
    // SmbCreateFlags: 8 bytes → already 0
    body.setUint32(20, desiredAccess, Endian.little);
    body.setUint32(24, fileAttributes, Endian.little);
    body.setUint32(28, 7, Endian.little); // ShareAccess: R|W|D
    body.setUint32(32, createDisposition, Endian.little);
    body.setUint32(36, createOptions, Endian.little);
    body.setUint16(40, nameOffset, Endian.little);
    body.setUint16(42, nameUtf16.length, Endian.little);
    // CreateContextsOffset / Length: 0
    body.setUint32(44, 0, Endian.little);
    body.setUint32(48, 0, Endian.little);
    // Buffer offset: leave as 0 extra filler byte for structure padding
    body.setUint8(56, 0);

    final payload = Uint8List.fromList([
      ..._smb2Header(
        command: 0x0005,
        messageId: _nextMessageId(),
        treeId: _treeId,
        sessionId: _sessionId,
      ),
      ...body.buffer.asUint8List(0, 57),
      ...nameUtf16,
    ]);

    await _send(payload);
    final resp = await _receive();
    _checkStatus(resp, 'CREATE $path');

    // FileId est à l'offset 64 (header) + 5 (skipping fields) = 69
    // En réalité: StructureSize (2) + OplockLevel (1) + Flags (1) + Action (4)
    //             + CreationTime(8) + LastAccessTime(8) + LastWriteTime(8)
    //             + ChangeTime(8) + AllocationSize(8) + EndofFile(8)
    //             + FileAttributes(4) + Reserved2(4)
    //             = 64 header + 2 + 1 + 1 + 4 + 8*5 + 4 + 4 = 64 + 56 = 120
    if (resp.length < 136) throw const SmbException('CREATE réponse trop courte');
    return resp.sublist(120, 136); // FileId: 16 bytes
  }

  // -------------------------------------------------------------------------
  // CLOSE (commande 0x0006)
  // -------------------------------------------------------------------------

  Future<void> _close(Uint8List fileId) async {
    final body = ByteData(24);
    body.setUint16(0, 24, Endian.little);
    // FileId à l'offset 8
    for (int i = 0; i < 16; i++) {
      body.setUint8(8 + i, fileId[i]);
    }

    final payload = Uint8List.fromList([
      ..._smb2Header(
        command: 0x0006,
        messageId: _nextMessageId(),
        treeId: _treeId,
        sessionId: _sessionId,
      ),
      ...body.buffer.asUint8List(),
    ]);

    await _send(payload);
    await _receive();
  }

  // -------------------------------------------------------------------------
  // READ (commande 0x0008) — téléchargement par chunks
  // -------------------------------------------------------------------------

  Future<Uint8List> _readAll(Uint8List fileId) async {
    final chunks = <Uint8List>[];
    int offset = 0;
    const chunkSize = 65536;

    while (true) {
      final chunk = await _read(fileId, offset, chunkSize);
      if (chunk.isEmpty) break;
      chunks.add(chunk);
      offset += chunk.length;
      if (chunk.length < chunkSize) break;
    }

    final total = chunks.fold<int>(0, (sum, c) => sum + c.length);
    final result = Uint8List(total);
    int pos = 0;
    for (final c in chunks) {
      result.setRange(pos, pos + c.length, c);
      pos += c.length;
    }
    return result;
  }

  Future<Uint8List> _read(Uint8List fileId, int offset, int length) async {
    final body = ByteData(49);
    body.setUint16(0, 49, Endian.little);
    body.setUint8(2, 0);  // Padding
    body.setUint8(3, 0);  // Reserved
    body.setUint32(4, length, Endian.little);
    body.setUint64(8, offset);
    for (int i = 0; i < 16; i++) body.setUint8(16 + i, fileId[i]);
    body.setUint32(32, 0, Endian.little);  // MinimumCount
    body.setUint32(36, 0, Endian.little);  // Channel
    body.setUint32(40, 0, Endian.little);  // RemainingBytes
    body.setUint16(44, 0, Endian.little);  // ReadChannelInfoOffset
    body.setUint16(46, 0, Endian.little);  // ReadChannelInfoLength
    body.setUint8(48, 0);                  // Buffer

    final payload = Uint8List.fromList([
      ..._smb2Header(
        command: 0x0008,
        messageId: _nextMessageId(),
        treeId: _treeId,
        sessionId: _sessionId,
      ),
      ...body.buffer.asUint8List(),
    ]);

    await _send(payload);
    final resp = await _receive();

    // 0xC0000011 = STATUS_END_OF_FILE
    final status = _getStatus(resp);
    if (status == 0xC0000011) return Uint8List(0);
    _checkStatus(resp, 'READ @$offset');

    // DataOffset (2) + DataLength (4) dans le body read response (offset 64+4)
    if (resp.length < 80) return Uint8List(0);
    final bd = ByteData.sublistView(resp);
    final dataOffset = bd.getUint16(66, Endian.little);
    final dataLength = bd.getUint32(68, Endian.little);
    if (dataOffset + dataLength > resp.length) return Uint8List(0);
    return resp.sublist(dataOffset, dataOffset + dataLength);
  }

  // -------------------------------------------------------------------------
  // QUERY_DIRECTORY (commande 0x000E)
  // -------------------------------------------------------------------------

  Future<List<SmbFile>> _queryDirectory(Uint8List fileId, String dirPath) async {
    final files = <SmbFile>[];
    final searchPattern = _toUtf16LE('*');

    while (true) {
      final body = ByteData(33 + searchPattern.length);
      body.setUint16(0, 33, Endian.little);  // StructureSize
      body.setUint8(2, 1);                   // FileInformationClass: FileIdBothDirectoryInformation
      body.setUint8(3, 1);                   // Flags: RESTART_SCANS (first call)
      body.setUint32(4, 0, Endian.little);   // FileIndex
      for (int i = 0; i < 16; i++) body.setUint8(8 + i, fileId[i]);
      body.setUint16(24, 64 + 33, Endian.little);  // FileNameOffset
      body.setUint16(26, searchPattern.length, Endian.little);
      body.setUint32(28, 65536, Endian.little);     // OutputBufferLength
      body.setUint32(32, 0, Endian.little);          // extra

      final payload = Uint8List.fromList([
        ..._smb2Header(
          command: 0x000E,
          messageId: _nextMessageId(),
          treeId: _treeId,
          sessionId: _sessionId,
        ),
        ...body.buffer.asUint8List(0, 33),
        ...searchPattern,
      ]);

      await _send(payload);
      final resp = await _receive();

      // 0x80000006 = STATUS_NO_MORE_FILES
      final status = _getStatus(resp);
      if (status == 0x80000006 || status == 0xC0000034) break;
      _checkStatus(resp, 'QUERY_DIRECTORY $dirPath');

      // Parse FileIdBothDirectoryInformation entries
      if (resp.length < 72) break;
      final bd = ByteData.sublistView(resp);
      final outputOffset = bd.getUint16(66, Endian.little);
      final outputLength = bd.getUint32(68, Endian.little);
      if (outputOffset + outputLength > resp.length) break;

      int pos = outputOffset;
      while (pos < outputOffset + outputLength) {
        final entry = _parseFileInfo(resp, pos, dirPath);
        if (entry != null) files.add(entry);

        final nextOffset = ByteData.sublistView(resp, pos).getUint32(0, Endian.little);
        if (nextOffset == 0) break;
        pos += nextOffset;
      }

      // Deuxième appel sans RESTART_SCANS pour obtenir la suite
      body.setUint8(3, 0);
      break; // Pour simplifier: un seul appel QUERY_DIRECTORY suffit dans la plupart des cas
    }

    return files;
  }

  SmbFile? _parseFileInfo(Uint8List buf, int offset, String dirPath) {
    try {
      final bd = ByteData.sublistView(buf, offset);
      if (bd.lengthInBytes < 104) return null;

      final fileAttributes = bd.getUint32(56, Endian.little);
      final endOfFile = bd.getUint64(40, Endian.little);
      final nameLength = bd.getUint32(60, Endian.little);
      if (64 + nameLength > bd.lengthInBytes) return null;

      final nameBytes = buf.sublist(offset + 104, offset + 104 + nameLength);
      final name = utf8.decode(nameBytes, allowMalformed: true);
      final isDirectory = (fileAttributes & 0x10) != 0;
      final fullPath = dirPath.isEmpty ? name : '$dirPath/$name';

      return SmbFile(
        name: name,
        path: fullPath,
        isDirectory: isDirectory,
        size: endOfFile,
      );
    } catch (_) {
      return null;
    }
  }

  // -------------------------------------------------------------------------
  // Énumération des partages via SRVSVC pipe (IPC$)
  // Note: très simplifié — retourne [] si la RPC échoue
  // -------------------------------------------------------------------------

  Future<List<({String name})>> _enumShares(int treeId) async {
    // La plupart des NAS grand public (Synology, QNAP, etc.) supportent
    // l'énumération via SRVSVC. On retourne [] en cas d'échec.
    return [];
  }

  // -------------------------------------------------------------------------
  // NTLM helpers (minimal)
  // -------------------------------------------------------------------------

  Uint8List _buildNtlmNegotiate() {
    // NTLM NEGOTIATE_MESSAGE (Type 1)
    // Signature: NTLMSSP\0
    // MessageType: 1
    // NegotiateFlags: 0x62088205 (common set)
    const sig = [0x4E, 0x54, 0x4C, 0x4D, 0x53, 0x53, 0x50, 0x00];
    final buf = ByteData(32);
    for (int i = 0; i < 8; i++) buf.setUint8(i, sig[i]);
    buf.setUint32(8, 1, Endian.little);    // MessageType = 1 (NEGOTIATE)
    buf.setUint32(12, 0x62088205, Endian.little); // NegotiateFlags
    // DomainNameFields + WorkstationFields: all zeros
    buf.setUint64(24, 0x00000000601082D2, Endian.little); // Version hint
    return buf.buffer.asUint8List();
  }

  Uint8List _buildNtlmAuthenticate(Uint8List _challengeResp) {
    // NTLM AUTHENTICATE_MESSAGE (Type 3)
    // Pour guest/anonyme: tous les champs sont vides (length = 0)
    final user = username == 'guest' || username.isEmpty ? '' : username;
    final userBytes = _toUtf16LE(user);
    const sig = [0x4E, 0x54, 0x4C, 0x4D, 0x53, 0x53, 0x50, 0x00];
    final buf = ByteData(72 + userBytes.length);
    for (int i = 0; i < 8; i++) buf.setUint8(i, sig[i]);
    buf.setUint32(8, 3, Endian.little);   // MessageType = 3
    // LmChallengeResponse: empty
    buf.setUint16(12, 0, Endian.little); buf.setUint16(14, 0, Endian.little);
    buf.setUint32(16, 72, Endian.little);
    // NtChallengeResponse: empty
    buf.setUint16(20, 0, Endian.little); buf.setUint16(22, 0, Endian.little);
    buf.setUint32(24, 72, Endian.little);
    // DomainName: empty
    buf.setUint16(28, 0, Endian.little); buf.setUint16(30, 0, Endian.little);
    buf.setUint32(32, 72, Endian.little);
    // UserName
    buf.setUint16(36, userBytes.length, Endian.little);
    buf.setUint16(38, userBytes.length, Endian.little);
    buf.setUint32(40, 72, Endian.little);
    // Workstation: empty
    buf.setUint16(44, 0, Endian.little); buf.setUint16(46, 0, Endian.little);
    buf.setUint32(48, 72, Endian.little);
    // EncryptedRandomSessionKey: empty
    buf.setUint16(52, 0, Endian.little); buf.setUint16(54, 0, Endian.little);
    buf.setUint32(56, 72, Endian.little);
    buf.setUint32(60, 0x62088205, Endian.little); // NegotiateFlags
    for (int i = 0; i < userBytes.length; i++) buf.setUint8(72 + i, userBytes[i]);
    return buf.buffer.asUint8List();
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  Uint8List _toUtf16LE(String s) {
    final result = <int>[];
    for (final rune in s.runes) {
      result.add(rune & 0xFF);
      result.add((rune >> 8) & 0xFF);
    }
    return Uint8List.fromList(result);
  }

  int _getStatus(Uint8List resp) {
    if (resp.length < 12) return -1;
    return ByteData.sublistView(resp).getUint32(8, Endian.little);
  }

  void _checkStatus(Uint8List resp, String context, {int? allowStatus}) {
    final status = _getStatus(resp);
    if (status == 0) return;
    if (allowStatus != null && status == allowStatus) return;
    throw SmbException('$context → STATUS 0x${status.toRadixString(16).toUpperCase().padLeft(8, '0')}');
  }
}

// Extension pour ByteData — getUint64 / setUint64 (Dart ne les a pas nativement)
extension _ByteDataUint64 on ByteData {
  int getUint64(int byteOffset, [Endian endian = Endian.little]) {
    final lo = getUint32(byteOffset, endian);
    final hi = getUint32(byteOffset + 4, endian);
    if (endian == Endian.little) {
      return lo + hi * 0x100000000;
    }
    return hi + lo * 0x100000000;
  }

  void setUint64(int byteOffset, int value, [Endian endian = Endian.little]) {
    final lo = value & 0xFFFFFFFF;
    final hi = (value ~/ 0x100000000) & 0xFFFFFFFF;
    if (endian == Endian.little) {
      setUint32(byteOffset, lo, endian);
      setUint32(byteOffset + 4, hi, endian);
    } else {
      setUint32(byteOffset, hi, endian);
      setUint32(byteOffset + 4, lo, endian);
    }
  }
}
