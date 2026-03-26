package com.mozaiklabs.tune_server

import android.media.MediaMetadataRetriever
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.mozaiklabs.tuneserver/library"

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
                "sampleRate"  to null,
                "channels"    to null,
                "bitDepth"    to null,
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
            retriever.embeddedPicture?.toList()
        } catch (_: Exception) {
            null
        } finally {
            try { retriever.release() } catch (_: Exception) {}
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
