import Flutter
import MediaPlayer
import UIKit

// ---------------------------------------------------------------------------
// AppleMusicPlugin.swift — platform channel MPMediaLibrary
// Canal : com.mozaiklabs.tuneserver/apple_music
// Miroir de AppleMusicLibrary.swift (app iOS GRDB)
// ---------------------------------------------------------------------------

public class AppleMusicPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "com.mozaiklabs.tuneserver/apple_music",
            binaryMessenger: registrar.messenger()
        )
        let instance = AppleMusicPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "authorizationStatus":
            result(authorizationStatus())
        case "requestAuthorization":
            requestAuthorization(result: result)
        case "allTracks":
            result(allTracks())
        case "allAlbums":
            result(allAlbums())
        case "allArtists":
            result(allArtists())
        case "streamUrl":
            guard let args = call.arguments as? [String: Any],
                  let persistentId = args["persistentId"] as? String else {
                result(nil)
                return
            }
            result(streamUrl(persistentId: persistentId))
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Authorization

    private func authorizationStatus() -> String {
        switch MPMediaLibrary.authorizationStatus() {
        case .authorized:      return "authorized"
        case .denied:          return "denied"
        case .restricted:      return "restricted"
        case .notDetermined:   return "notDetermined"
        @unknown default:      return "notDetermined"
        }
    }

    private func requestAuthorization(result: @escaping FlutterResult) {
        MPMediaLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized: result("authorized")
                default:          result("denied")
                }
            }
        }
    }

    // MARK: - All Tracks

    private func allTracks() -> [[String: Any?]] {
        guard MPMediaLibrary.authorizationStatus() == .authorized else { return [] }

        let query = MPMediaQuery.songs()
        query.groupingType = .title
        let items = query.items ?? []

        return items.map { item in
            var dict: [String: Any?] = [
                "persistentID":    String(item.persistentID),
                "title":           item.title,
                "artist":          item.artist,
                "albumArtist":     item.albumArtist,
                "albumTitle":      item.albumTitle,
                "albumTrackNumber": item.albumTrackNumber > 0 ? item.albumTrackNumber : nil,
                "discNumber":      item.discNumber > 0 ? item.discNumber : nil,
                "genre":           item.genre,
                "playbackDuration": item.playbackDuration,
                "assetURL":        item.assetURL?.absoluteString,
                "hasArtwork":      item.artwork != nil,
            ]
            // releaseDate
            if let date = item.releaseDate {
                let formatter = ISO8601DateFormatter()
                dict["releaseDate"] = formatter.string(from: date)
            }
            return dict
        }
    }

    // MARK: - All Albums

    private func allAlbums() -> [[String: Any?]] {
        guard MPMediaLibrary.authorizationStatus() == .authorized else { return [] }

        let query = MPMediaQuery.albums()
        let collections = query.collections ?? []

        return collections.compactMap { collection in
            guard let rep = collection.representativeItem else { return nil }
            return [
                "albumTitle":  rep.albumTitle,
                "albumArtist": rep.albumArtist,
                "trackCount":  collection.count,
                "year":        rep.releaseDate.map { Calendar.current.component(.year, from: $0) },
            ]
        }
    }

    // MARK: - All Artists

    private func allArtists() -> [[String: Any?]] {
        guard MPMediaLibrary.authorizationStatus() == .authorized else { return [] }

        let query = MPMediaQuery.artists()
        let collections = query.collections ?? []

        return collections.compactMap { collection in
            guard let rep = collection.representativeItem else { return nil }
            return [
                "name":       rep.artist,
                "albumCount": collection.count,
            ]
        }
    }

    // MARK: - Stream URL

    private func streamUrl(persistentId: String) -> String? {
        guard MPMediaLibrary.authorizationStatus() == .authorized,
              let id = UInt64(persistentId) else { return nil }

        let predicate = MPMediaPropertyPredicate(
            value: NSNumber(value: id),
            forProperty: MPMediaItemPropertyPersistentID
        )
        let query = MPMediaQuery()
        query.addFilterPredicate(predicate)

        return query.items?.first?.assetURL?.absoluteString
    }
}
