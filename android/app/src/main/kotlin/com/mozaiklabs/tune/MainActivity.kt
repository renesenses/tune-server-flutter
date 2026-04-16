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

            val hasCoverData = retriever.embeddedPicture != null

            // MediaMetadataRetriever n'expose pas sampleRate/bitDepth —
            // on utilise MediaExtractor pour lire le MediaFormat de la piste audio.
            val (sampleRate, channels, bitDepth) = readAudioFormat(path)

            mapOf(
                "filePath"    to path,
                "title"       to title,
                "artist"      to artist,
                "album"       to album,
                "genre"       to genre,
                "albumArtist" to albumArtist,
                "trackNumber" to trackNumber,
                "discNumber"  to discNumber,
                "durationMs"  to durationMs,
                "year"        to year,
                "format"      to formatFromExtension(path),
                "hasCoverData" to hasCoverData,
                "sampleRate"  to sampleRate,
                "channels"    to channels,
                "bitDepth"    to bitDepth,
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
