package com.mozaiklabs.tune

import android.content.Context
import android.media.AudioDeviceInfo
import android.media.AudioManager
import android.media.MediaExtractor
import android.media.MediaFormat
import android.media.MediaMetadataRetriever
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.mozaiklabs.tuneserver/library"
    private val BT_CHANNEL = "com.mozaiklabs.tuneserver/bluetooth"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "readMetadata" -> {
                        val path = call.argument<String>("path")
                        if (path == null) {
                            result.error("INVALID_ARG", "path is null", null)
                        } else {
                            result.success(readMetadata(path))
                        }
                    }
                    "readMetadataBatch" -> {
                        val paths = call.argument<List<String>>("paths") ?: emptyList()
                        val list = paths.map { readMetadata(it) }
                        result.success(list)
                    }
                    "readCoverData" -> {
                        val path = call.argument<String>("path")
                        if (path == null) {
                            result.success(null)
                        } else {
                            result.success(readCoverData(path))
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BT_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "listDevices" -> result.success(listBluetoothDevices())
                    else -> result.notImplemented()
                }
            }
    }

    // -------------------------------------------------------------------------
    // listBluetoothDevices — Bluetooth A2DP + SCO currently connected outputs.
    // Returns empty list if platform doesn't support or on error.
    // -------------------------------------------------------------------------
    private fun listBluetoothDevices(): List<Map<String, Any?>> {
        return try {
            val am = getSystemService(Context.AUDIO_SERVICE) as AudioManager
            val devices = am.getDevices(AudioManager.GET_DEVICES_OUTPUTS)
            devices.filter {
                it.type == AudioDeviceInfo.TYPE_BLUETOOTH_A2DP ||
                it.type == AudioDeviceInfo.TYPE_BLUETOOTH_SCO
            }.map { d ->
                val typeName = when (d.type) {
                    AudioDeviceInfo.TYPE_BLUETOOTH_A2DP -> "a2dp"
                    AudioDeviceInfo.TYPE_BLUETOOTH_SCO -> "sco"
                    else -> "other"
                }
                mapOf(
                    "id" to d.id.toString(),
                    "name" to (d.productName?.toString() ?: "Bluetooth"),
                    "type" to typeName,
                )
            }
        } catch (e: Exception) {
            emptyList()
        }
    }

    // -------------------------------------------------------------------------
    // readMetadata — extrait les tags d'un fichier audio via MediaMetadataRetriever
    // -------------------------------------------------------------------------
    private fun readMetadata(path: String): Map<String, Any?> {
        val retriever = MediaMetadataRetriever()
        return try {
            retriever.setDataSource(path)

            val title     = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_TITLE)
            val artist    = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_ARTIST)
            val album     = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_ALBUM)
            val genre     = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_GENRE)
            val albumArtist = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_ALBUMARTIST)
            val durationStr = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)
            val trackStr  = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_CD_TRACK_NUMBER)
            val discStr   = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DISC_NUMBER)
            val yearStr   = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_YEAR)

            // Track/disc number peut être "3/12" → on prend le premier
            val trackNumber = trackStr?.split("/")?.firstOrNull()?.trim()?.toIntOrNull()
            val discNumber  = discStr?.split("/")?.firstOrNull()?.trim()?.toIntOrNull()
            val durationMs  = durationStr?.toLongOrNull()?.toInt()
            val year        = yearStr?.toIntOrNull()
            // Full release date: yearStr may contain ISO date like "2007-04-11"
            val releaseDate = if (yearStr != null && yearStr.length > 4) yearStr else null

            val hasCoverData = retriever.embeddedPicture != null

            // MediaMetadataRetriever n'expose pas sampleRate/bitDepth —
            // on utilise MediaExtractor pour lire le MediaFormat de la piste audio.
            val (sampleRate, channels, bitDepth) = readAudioFormat(path)

            val extraTags = readExtraTags(path)

            // Compilation flag: from extra tags (Vorbis/ID3/M4A) or MediaMetadataRetriever (API 30+)
            val isCompilation = extraTags["compilation"] == "1" ||
                (android.os.Build.VERSION.SDK_INT >= 30 &&
                    retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_COMPILATION) == "1")

            mapOf(
                "filePath"    to path,
                "title"       to title,
                "artist"      to artist,
                "album"       to album,
                "genre"       to genre,
                "albumArtist" to albumArtist,
                "albumArtistSort" to extraTags["albumArtistSort"],
                "trackNumber" to trackNumber,
                "discNumber"  to discNumber,
                "durationMs"  to durationMs,
                "year"        to year,
                "originalYear" to (extraTags["originalYear"]?.toIntOrNull()),
                "releaseDate" to (extraTags["releaseDate"] ?: releaseDate),
                "originalDate" to extraTags["originalDate"],
                "format"      to formatFromExtension(path),
                "hasCoverData" to hasCoverData,
                "sampleRate"  to sampleRate,
                "channels"    to channels,
                "bitDepth"    to bitDepth,
                "musicbrainzRecordingId" to extraTags["musicbrainzRecordingId"],
                "musicbrainzReleaseId" to extraTags["musicbrainzReleaseId"],
                "musicbrainzReleaseGroupId" to extraTags["musicbrainzReleaseGroupId"],
                "discSubtitle" to extraTags["discSubtitle"],
                "compilation" to isCompilation,
            )
        } catch (e: Exception) {
            // Fallback : nom de fichier uniquement
            mapOf(
                "filePath"     to path,
                "title"        to path.substringAfterLast('/').substringBeforeLast('.'),
                "format"       to formatFromExtension(path),
                "hasCoverData" to false,
            )
        } finally {
            try { retriever.release() } catch (_: Exception) {}
        }
    }

    // -------------------------------------------------------------------------
    // readCoverData — retourne les octets de la pochette embarquée, ou null
    // -------------------------------------------------------------------------
    private fun readCoverData(path: String): List<Int>? {
        val retriever = MediaMetadataRetriever()
        return try {
            retriever.setDataSource(path)
            retriever.embeddedPicture?.map { it.toInt() and 0xFF }
        } catch (_: Exception) {
            null
        } finally {
            try { retriever.release() } catch (_: Exception) {}
        }
    }

    // -------------------------------------------------------------------------
    // readAudioFormat — sampleRate, channels, bitDepth via MediaExtractor
    // -------------------------------------------------------------------------
    private fun readAudioFormat(path: String): Triple<Int?, Int?, Int?> {
        val extractor = MediaExtractor()
        return try {
            extractor.setDataSource(path)
            var sampleRate: Int? = null
            var channels: Int? = null
            var bitDepth: Int? = null
            for (i in 0 until extractor.trackCount) {
                val fmt = extractor.getTrackFormat(i)
                val mime = fmt.getString(MediaFormat.KEY_MIME) ?: continue
                if (!mime.startsWith("audio/")) continue
                if (fmt.containsKey(MediaFormat.KEY_SAMPLE_RATE)) {
                    sampleRate = fmt.getInteger(MediaFormat.KEY_SAMPLE_RATE)
                }
                if (fmt.containsKey(MediaFormat.KEY_CHANNEL_COUNT)) {
                    channels = fmt.getInteger(MediaFormat.KEY_CHANNEL_COUNT)
                }
                if (fmt.containsKey(MediaFormat.KEY_PCM_ENCODING)) {
                    bitDepth = when (fmt.getInteger(MediaFormat.KEY_PCM_ENCODING)) {
                        2 -> 16  // AudioFormat.ENCODING_PCM_16BIT
                        4 -> 32  // AudioFormat.ENCODING_PCM_32BIT
                        101 -> 24 // AudioFormat.ENCODING_PCM_24BIT_PACKED
                        else -> null
                    }
                }
                break
            }
            Triple(sampleRate, channels, bitDepth)
        } catch (_: Exception) {
            Triple(null, null, null)
        } finally {
            extractor.release()
        }
    }

    // -------------------------------------------------------------------------
    // readExtraTags — MusicBrainz IDs + originalYear from FLAC/MP3 tags
    // MediaMetadataRetriever doesn't expose these, so we parse manually.
    // -------------------------------------------------------------------------
    private fun readExtraTags(path: String): Map<String, String?> {
        val result = mutableMapOf<String, String?>()
        try {
            val ext = path.substringAfterLast('.', "").lowercase()
            when (ext) {
                "flac" -> readFlacVorbisComments(path, result)
                "mp3" -> readId3v2TxxxFrames(path, result)
                "ogg" -> readFlacVorbisComments(path, result)
                "m4a", "aac", "mp4" -> readM4aFreeformAtoms(path, result)
            }
        } catch (_: Exception) {}
        return result
    }

    private fun readFlacVorbisComments(path: String, out: MutableMap<String, String?>) {
        java.io.RandomAccessFile(path, "r").use { raf ->
            val header = ByteArray(4)
            raf.readFully(header)
            val isFLAC = String(header) == "fLaC"
            val isOGG = header[0] == 'O'.code.toByte()
            if (!isFLAC && !isOGG) return

            if (isFLAC) {
                // Skip metadata blocks until we find VORBIS_COMMENT (type 4)
                while (true) {
                    val blockHeader = raf.read()
                    if (blockHeader == -1) return
                    val isLast = (blockHeader and 0x80) != 0
                    val blockType = blockHeader and 0x7F
                    val sizeBytes = ByteArray(3)
                    raf.readFully(sizeBytes)
                    val blockSize = ((sizeBytes[0].toInt() and 0xFF) shl 16) or
                            ((sizeBytes[1].toInt() and 0xFF) shl 8) or
                            (sizeBytes[2].toInt() and 0xFF)
                    if (blockType == 4) {
                        val data = ByteArray(blockSize)
                        raf.readFully(data)
                        parseVorbisComments(data, out)
                        return
                    }
                    raf.skipBytes(blockSize)
                    if (isLast) return
                }
            }
        }
    }

    private fun parseVorbisComments(data: ByteArray, out: MutableMap<String, String?>) {
        var offset = 0
        fun readLE32(): Int {
            if (offset + 4 > data.size) return 0
            val v = (data[offset].toInt() and 0xFF) or
                    ((data[offset + 1].toInt() and 0xFF) shl 8) or
                    ((data[offset + 2].toInt() and 0xFF) shl 16) or
                    ((data[offset + 3].toInt() and 0xFF) shl 24)
            offset += 4
            return v
        }
        // Skip vendor string
        val vendorLen = readLE32()
        offset += vendorLen
        val commentCount = readLE32()
        for (i in 0 until commentCount) {
            if (offset + 4 > data.size) break
            val len = readLE32()
            if (offset + len > data.size) break
            val comment = String(data, offset, len, Charsets.UTF_8)
            offset += len
            val eq = comment.indexOf('=')
            if (eq < 0) continue
            val key = comment.substring(0, eq).uppercase()
            val value = comment.substring(eq + 1)
            when (key) {
                "ORIGINALDATE", "ORIGINALYEAR" -> {
                    out.putIfAbsent("originalYear", value.take(4))
                    if (value.length > 4) out.putIfAbsent("originalDate", value)
                }
                "DATE" -> {
                    if (value.length > 4) out.putIfAbsent("releaseDate", value)
                }
                "MUSICBRAINZ_TRACKID" ->
                    out.putIfAbsent("musicbrainzRecordingId", value)
                "MUSICBRAINZ_ALBUMID" ->
                    out.putIfAbsent("musicbrainzReleaseId", value)
                "MUSICBRAINZ_RELEASEGROUPID" ->
                    out.putIfAbsent("musicbrainzReleaseGroupId", value)
                "DISCSUBTITLE", "SETSUBTITLE" ->
                    out.putIfAbsent("discSubtitle", value)
                "ALBUMARTISTSORT" ->
                    out.putIfAbsent("albumArtistSort", value)
                "COMPILATION", "ITUNESCOMPILATION" -> {
                    if (value == "1" || value.lowercase() == "true") {
                        out.putIfAbsent("compilation", "1")
                    }
                }
            }
        }
    }

    private fun readId3v2TxxxFrames(path: String, out: MutableMap<String, String?>) {
        java.io.RandomAccessFile(path, "r").use { raf ->
            val header = ByteArray(10)
            if (raf.read(header) < 10) return
            if (header[0] != 'I'.code.toByte() || header[1] != 'D'.code.toByte() || header[2] != '3'.code.toByte()) return
            val tagSize = ((header[6].toInt() and 0x7F) shl 21) or
                    ((header[7].toInt() and 0x7F) shl 14) or
                    ((header[8].toInt() and 0x7F) shl 7) or
                    (header[9].toInt() and 0x7F)
            val tagData = ByteArray(tagSize)
            raf.readFully(tagData)
            var offset = 0
            while (offset + 10 <= tagData.size) {
                val frameId = String(tagData, offset, 4, Charsets.ISO_8859_1)
                if (frameId[0] == ' ') break
                val frameSize = ((tagData[offset + 4].toInt() and 0xFF) shl 24) or
                        ((tagData[offset + 5].toInt() and 0xFF) shl 16) or
                        ((tagData[offset + 6].toInt() and 0xFF) shl 8) or
                        (tagData[offset + 7].toInt() and 0xFF)
                offset += 10
                if (frameSize <= 0 || offset + frameSize > tagData.size) break
                if (frameId == "TXXX" && frameSize > 1) {
                    val encoding = tagData[offset].toInt()
                    val textData = tagData.copyOfRange(offset + 1, offset + frameSize)
                    val charset = if (encoding == 3) Charsets.UTF_8 else Charsets.ISO_8859_1
                    val text = String(textData, charset)
                    val nullIdx = text.indexOf(' ')
                    if (nullIdx >= 0) {
                        val desc = text.substring(0, nullIdx).lowercase()
                        val value = text.substring(nullIdx + 1).trimEnd(' ')
                        when (desc) {
                            "musicbrainz track id", "musicbrainz recording id", "musicbrainz_trackid" ->
                                out.putIfAbsent("musicbrainzRecordingId", value)
                            "musicbrainz album id", "musicbrainz release id", "musicbrainz_albumid" ->
                                out.putIfAbsent("musicbrainzReleaseId", value)
                            "musicbrainz release group id", "musicbrainz_releasegroupid" ->
                                out.putIfAbsent("musicbrainzReleaseGroupId", value)
                            "originaldate", "originalyear" -> {
                                out.putIfAbsent("originalYear", value.take(4))
                                if (value.length > 4) out.putIfAbsent("originalDate", value)
                            }
                            "discsubtitle", "setsubtitle" ->
                                out.putIfAbsent("discSubtitle", value)
                            "compilation", "itunescompilation" -> {
                                if (value == "1" || value.lowercase() == "true") {
                                    out.putIfAbsent("compilation", "1")
                                }
                            }
                        }
                    }
                } else if (frameId == "TCMP" && frameSize > 1) {
                    // TCMP frame — iTunes compilation flag (ID3v2)
                    val encoding = tagData[offset].toInt()
                    val charset = if (encoding == 3) Charsets.UTF_8 else Charsets.ISO_8859_1
                    val value = String(tagData, offset + 1, frameSize - 1, charset).trimEnd(' ')
                    if (value == "1" || value.lowercase() == "true") {
                        out.putIfAbsent("compilation", "1")
                    }
                } else if ((frameId == "TDOR" || frameId == "TORY") && frameSize > 1) {
                    val encoding = tagData[offset].toInt()
                    val charset = if (encoding == 3) Charsets.UTF_8 else Charsets.ISO_8859_1
                    val value = String(tagData, offset + 1, frameSize - 1, charset).trimEnd(' ')
                    out.putIfAbsent("originalYear", value.take(4))
                    if (value.length > 4) out.putIfAbsent("originalDate", value)
                } else if (frameId == "TSST" && frameSize > 1) {
                    // Disc subtitle (ID3v2 TSST = Set Subtitle)
                    val encoding = tagData[offset].toInt()
                    val charset = if (encoding == 3) Charsets.UTF_8 else Charsets.ISO_8859_1
                    val value = String(tagData, offset + 1, frameSize - 1, charset).trimEnd(' ')
                    out.putIfAbsent("discSubtitle", value)
                } else if (frameId == "TSO2" && frameSize > 1) {
                    // Album artist sort order (ID3v2 TSO2)
                    val encoding = tagData[offset].toInt()
                    val charset = if (encoding == 3) Charsets.UTF_8 else Charsets.ISO_8859_1
                    val value = String(tagData, offset + 1, frameSize - 1, charset).trimEnd(' ')
                    out.putIfAbsent("albumArtistSort", value)
                }
                offset += frameSize
            }
        }
    }

    // -------------------------------------------------------------------------
    // readM4aFreeformAtoms — MusicBrainz IDs + originalYear from MP4/M4A atoms
    // Parses the moov→udta→meta→ilst box hierarchy for ---- freeform atoms
    // and the ©day atom for original year.
    // -------------------------------------------------------------------------
    private fun readM4aFreeformAtoms(path: String, out: MutableMap<String, String?>) {
        java.io.RandomAccessFile(path, "r").use { raf ->
            val fileLen = raf.length()
            // Find moov atom at top level
            val moovPos = findAtom(raf, 0, fileLen, "moov") ?: return
            val moovSize = readAtomSize(raf, moovPos)
            val moovDataStart = moovPos + 8
            val moovEnd = moovPos + moovSize

            // Find udta inside moov
            val udtaPos = findAtom(raf, moovDataStart, moovEnd, "udta") ?: return
            val udtaSize = readAtomSize(raf, udtaPos)
            val udtaDataStart = udtaPos + 8
            val udtaEnd = udtaPos + udtaSize

            // Find meta inside udta
            val metaPos = findAtom(raf, udtaDataStart, udtaEnd, "meta") ?: return
            val metaSize = readAtomSize(raf, metaPos)
            // meta atom has a 4-byte version/flags field after the standard 8-byte header
            val metaDataStart = metaPos + 12
            val metaEnd = metaPos + metaSize

            // Find ilst inside meta
            val ilstPos = findAtom(raf, metaDataStart, metaEnd, "ilst") ?: return
            val ilstSize = readAtomSize(raf, ilstPos)
            val ilstDataStart = ilstPos + 8
            val ilstEnd = ilstPos + ilstSize

            // Iterate atoms inside ilst
            var pos = ilstDataStart
            while (pos + 8 <= ilstEnd) {
                raf.seek(pos)
                val atomSize = raf.readInt().toLong() and 0xFFFFFFFFL
                if (atomSize < 8) break
                val typeBytes = ByteArray(4)
                raf.readFully(typeBytes)
                val atomType = String(typeBytes, Charsets.ISO_8859_1)
                val atomEnd = pos + atomSize

                if (atomType == "----") {
                    // Freeform atom: parse mean, name, data sub-atoms
                    parseFreeformAtom(raf, pos + 8, atomEnd, out)
                } else if (atomType == "soaa") {
                    // Album artist sort order (M4A soaa atom)
                    val dataPos = findAtom(raf, pos + 8, atomEnd, "data")
                    if (dataPos != null) {
                        val dataSize = readAtomSize(raf, dataPos)
                        val valueLen = (dataSize - 16).toInt()
                        if (valueLen > 0 && valueLen < 256) {
                            raf.seek(dataPos + 16)
                            val valBytes = ByteArray(valueLen)
                            raf.readFully(valBytes)
                            val sortStr = String(valBytes, Charsets.UTF_8).trim()
                            if (sortStr.isNotEmpty()) {
                                out.putIfAbsent("albumArtistSort", sortStr)
                            }
                        }
                    }
                } else if (atomType == "©day") {
                    // ©day atom contains date — parse its data sub-atom
                    val dataPos = findAtom(raf, pos + 8, atomEnd, "data")
                    if (dataPos != null) {
                        val dataSize = readAtomSize(raf, dataPos)
                        val valueLen = (dataSize - 16).toInt()
                        if (valueLen > 0 && valueLen < 256) {
                            raf.seek(dataPos + 16) // skip atom header (8) + version/flags + locale (8)
                            val valBytes = ByteArray(valueLen)
                            raf.readFully(valBytes)
                            val dateStr = String(valBytes, Charsets.UTF_8).trim()
                            if (dateStr.isNotEmpty()) {
                                out.putIfAbsent("originalYear", dateStr.take(4))
                                if (dateStr.length > 4) out.putIfAbsent("releaseDate", dateStr)
                            }
                        }
                    }
                } else if (atomType == "cpil") {
                    // cpil atom — compilation flag (native MP4 boolean)
                    val dataPos = findAtom(raf, pos + 8, atomEnd, "data")
                    if (dataPos != null) {
                        val dataSize = readAtomSize(raf, dataPos)
                        val valueLen = (dataSize - 16).toInt()
                        if (valueLen > 0) {
                            raf.seek(dataPos + 16)
                            val b = raf.read()
                            if (b == 1) {
                                out.putIfAbsent("compilation", "1")
                            }
                        }
                    }
                }

                pos = atomEnd
            }
        }
    }

    private fun findAtom(raf: java.io.RandomAccessFile, start: Long, end: Long, type: String): Long? {
        var pos = start
        while (pos + 8 <= end) {
            raf.seek(pos)
            val size = raf.readInt().toLong() and 0xFFFFFFFFL
            if (size < 8) return null
            val typeBytes = ByteArray(4)
            raf.readFully(typeBytes)
            val atomType = String(typeBytes, Charsets.ISO_8859_1)
            if (atomType == type) return pos
            pos += size
        }
        return null
    }

    private fun readAtomSize(raf: java.io.RandomAccessFile, pos: Long): Long {
        raf.seek(pos)
        return raf.readInt().toLong() and 0xFFFFFFFFL
    }

    private fun parseFreeformAtom(
        raf: java.io.RandomAccessFile,
        start: Long,
        end: Long,
        out: MutableMap<String, String?>
    ) {
        var meanStr: String? = null
        var nameStr: String? = null
        var dataStr: String? = null

        var pos = start
        while (pos + 8 <= end) {
            raf.seek(pos)
            val subSize = raf.readInt().toLong() and 0xFFFFFFFFL
            if (subSize < 8) break
            val typeBytes = ByteArray(4)
            raf.readFully(typeBytes)
            val subType = String(typeBytes, Charsets.ISO_8859_1)
            val subEnd = pos + subSize

            when (subType) {
                "mean" -> {
                    // mean: 8-byte header + 4-byte version/flags + string
                    val strLen = (subSize - 12).toInt()
                    if (strLen > 0 && strLen < 1024) {
                        raf.seek(pos + 12)
                        val buf = ByteArray(strLen)
                        raf.readFully(buf)
                        meanStr = String(buf, Charsets.UTF_8)
                    }
                }
                "name" -> {
                    // name: 8-byte header + 4-byte version/flags + string
                    val strLen = (subSize - 12).toInt()
                    if (strLen > 0 && strLen < 1024) {
                        raf.seek(pos + 12)
                        val buf = ByteArray(strLen)
                        raf.readFully(buf)
                        nameStr = String(buf, Charsets.UTF_8)
                    }
                }
                "data" -> {
                    // data: 8-byte header + 4-byte type/flags + 4-byte locale + value
                    val strLen = (subSize - 16).toInt()
                    if (strLen > 0 && strLen < 4096) {
                        raf.seek(pos + 16)
                        val buf = ByteArray(strLen)
                        raf.readFully(buf)
                        dataStr = String(buf, Charsets.UTF_8)
                    }
                }
            }

            pos = subEnd
        }

        // Match known MusicBrainz tags
        if (meanStr == "com.apple.iTunes" && nameStr != null && dataStr != null) {
            when (nameStr) {
                "MusicBrainz Track Id" ->
                    out.putIfAbsent("musicbrainzRecordingId", dataStr)
                "MusicBrainz Album Id" ->
                    out.putIfAbsent("musicbrainzReleaseId", dataStr)
                "MusicBrainz Release Group Id" ->
                    out.putIfAbsent("musicbrainzReleaseGroupId", dataStr)
                "ORIGINALDATE", "ORIGINALYEAR" -> {
                    out.putIfAbsent("originalYear", dataStr.take(4))
                    if (dataStr.length > 4) out.putIfAbsent("originalDate", dataStr)
                }
                "DISCSUBTITLE", "SETSUBTITLE" ->
                    out.putIfAbsent("discSubtitle", dataStr)
                "COMPILATION", "iTunesCompilation" -> {
                    if (dataStr == "1" || dataStr.lowercase() == "true") {
                        out.putIfAbsent("compilation", "1")
                    }
                }
            }
        }
    }

    private fun formatFromExtension(path: String): String {
        return when (path.substringAfterLast('.', "").lowercase()) {
            "flac"       -> "flac"
            "mp3"        -> "mp3"
            "m4a", "aac" -> "aac"
            "alac"       -> "alac"
            "ogg"        -> "ogg"
            "opus"       -> "opus"
            "wav"        -> "wav"
            "aiff", "aif" -> "aiff"
            "dsf", "dff" -> "dsd"
            else         -> path.substringAfterLast('.', "unknown").lowercase()
        }
    }
}
