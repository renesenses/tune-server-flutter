import AVFoundation
import Flutter
import UIKit

// ---------------------------------------------------------------------------
// LibraryPlugin.swift — lecture de metadata audio via AVFoundation
// Canal : com.mozaiklabs.tuneserver/library
// Implémente les méthodes utilisées par MetadataReader.dart
// ---------------------------------------------------------------------------

public class LibraryPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "com.mozaiklabs.tuneserver/library",
            binaryMessenger: registrar.messenger()
        )
        let instance = LibraryPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "readMetadata":
            guard let args = call.arguments as? [String: Any],
                  let path = args["path"] as? String else {
                result(FlutterError(code: "INVALID_ARGS", message: "path requis", details: nil))
                return
            }
            DispatchQueue.global(qos: .utility).async {
                let meta = self.readMetadata(path: path)
                DispatchQueue.main.async { result(meta) }
            }

        case "readMetadataBatch":
            guard let args = call.arguments as? [String: Any],
                  let paths = args["paths"] as? [String] else {
                result([])
                return
            }
            DispatchQueue.global(qos: .utility).async {
                let metas = paths.map { self.readMetadata(path: $0) }
                DispatchQueue.main.async { result(metas) }
            }

        case "readCoverData":
            guard let args = call.arguments as? [String: Any],
                  let path = args["path"] as? String else {
                result(nil)
                return
            }
            DispatchQueue.global(qos: .utility).async {
                let data = self.readCoverData(path: path)
                DispatchQueue.main.async { result(data) }
            }

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Metadata

    private func readMetadata(path: String) -> [String: Any?] {
        let url = URL(fileURLWithPath: path)
        let asset = AVURLAsset(url: url, options: [AVURLAssetPreferPreciseDurationAndTimingKey: true])

        var dict: [String: Any?] = [
            "filePath": path,
            "format": formatFromExtension(path),
            "hasCoverData": false,
        ]

        // Durée
        let duration = asset.duration
        if duration.isValid && !duration.isIndefinite {
            dict["durationMs"] = Int(CMTimeGetSeconds(duration) * 1000)
        }

        // Metadata communes (iTunes + ID3)
        let formats = asset.availableMetadataFormats
        for format in formats {
            let items = asset.metadata(forFormat: format)
            for item in items {
                guard let key = item.commonKey?.rawValue else { continue }
                switch key {
                case "title":       dict["title"]       = item.stringValue
                case "artist":      dict["artist"]      = item.stringValue
                case "albumName":   dict["album"]       = item.stringValue
                case "type":        dict["genre"]       = item.stringValue
                case "artwork":
                    if item.dataValue != nil { dict["hasCoverData"] = true }
                default: break
                }
            }
        }

        // Metadata iTunes étendues (albumArtist, trackNumber, discNumber, year)
        let iTunesItems = asset.metadata(forFormat: .iTunesMetadata)
        for item in iTunesItems {
            guard let id = item.identifier else { continue }
            switch id {
            case .iTunesMetadataAlbumArtist:
                dict["albumArtist"] = item.stringValue
            case .iTunesMetadataTrackNumber:
                if let n = item.numberValue?.intValue { dict["trackNumber"] = n }
            case .iTunesMetadataDiscNumber:
                if let n = item.numberValue?.intValue { dict["discNumber"] = n }
            case .iTunesMetadataReleaseDate:
                dict["year"] = extractYear(item.stringValue)
            default: break
            }
        }

        // ID3 étendues
        let id3Items = asset.metadata(forFormat: .id3Metadata)
        for item in id3Items {
            guard let id = item.identifier else { continue }
            switch id {
            case .id3MetadataAlbumArtist:
                dict["albumArtist"] = item.stringValue
            case .id3MetadataTrackNumber:
                dict["trackNumber"] = parseTrackNumber(item.stringValue)
            case .id3MetadataPartOfASet:
                dict["discNumber"] = parseTrackNumber(item.stringValue)
            case .id3MetadataYear, .id3MetadataRecordingTime:
                dict["year"] = extractYear(item.stringValue)
            default: break
            }
        }

        // Audio tracks (sampleRate, bitDepth, channels)
        // [HI-RES-TODO] : AVAssetTrack.audioFormatDescriptions expose sampleRate et bitDepth
        let audioTracks = asset.tracks(withMediaType: .audio)
        if let audioTrack = audioTracks.first {
            for desc in audioTrack.formatDescriptions {
                if let streamDesc = CMAudioFormatDescriptionGetStreamBasicDescription(
                    desc as! CMAudioFormatDescription
                ) {
                    dict["sampleRate"] = Int(streamDesc.pointee.mSampleRate)
                    dict["channels"]   = Int(streamDesc.pointee.mChannelsPerFrame)
                    let bitDepth = streamDesc.pointee.mBitsPerChannel
                    if bitDepth > 0 { dict["bitDepth"] = Int(bitDepth) }
                }
            }
        }

        return dict
    }

    // MARK: - Cover Data

    private func readCoverData(path: String) -> FlutterStandardTypedData? {
        let url = URL(fileURLWithPath: path)
        let asset = AVURLAsset(url: url)

        for format in asset.availableMetadataFormats {
            let items = asset.metadata(forFormat: format)
            for item in items {
                if item.commonKey?.rawValue == "artwork",
                   let data = item.dataValue {
                    return FlutterStandardTypedData(bytes: data)
                }
            }
        }
        return nil
    }

    // MARK: - Helpers

    private func formatFromExtension(_ path: String) -> String {
        switch (path as NSString).pathExtension.lowercased() {
        case "flac":        return "flac"
        case "mp3":         return "mp3"
        case "m4a":         return "aac"
        case "alac":        return "alac"
        case "aac":         return "aac"
        case "ogg":         return "ogg"
        case "opus":        return "opus"
        case "wav":         return "wav"
        case "aiff", "aif": return "aiff"
        case "dsf", "dff":  return "dsd"
        default:            return "unknown"
        }
    }

    private func extractYear(_ string: String?) -> Int? {
        guard let s = string, s.count >= 4 else { return nil }
        return Int(s.prefix(4))
    }

    private func parseTrackNumber(_ string: String?) -> Int? {
        guard let s = string else { return nil }
        // "3/12" ou "3"
        return Int(s.split(separator: "/").first ?? Substring(s))
    }
}
