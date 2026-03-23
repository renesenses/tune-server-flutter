import AVFoundation
import Flutter
import MediaPlayer
import UIKit

// ---------------------------------------------------------------------------
// AirPlayPlugin.swift — côté iOS du platform channel AirPlay
// Canal : com.mozaiklabs.tuneserver/airplay
// Miroir de AirPlayOutput.swift (app iOS GRDB)
//
// Utilise AVPlayer pour la lecture + AVRoutePickerView pour la sélection AirPlay.
// Les métadonnées sont exposées dans MPNowPlayingInfoCenter.
// ---------------------------------------------------------------------------

public class AirPlayPlugin: NSObject, FlutterPlugin {

    // MARK: - Registration

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "com.mozaiklabs.tuneserver/airplay",
            binaryMessenger: registrar.messenger()
        )
        let instance = AirPlayPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    // MARK: - State

    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var timeObserver: Any?

    // MARK: - FlutterPlugin

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "prepare":
            prepare(result: result)
        case "play":
            guard let args = call.arguments as? [String: Any],
                  let url = args["url"] as? String else {
                result(FlutterError(code: "INVALID_ARGS", message: "url requis", details: nil))
                return
            }
            play(
                url: url,
                title: args["title"] as? String,
                artist: args["artist"] as? String,
                albumArtUrl: args["albumArtUrl"] as? String,
                result: result
            )
        case "pause":
            player?.pause()
            result(nil)
        case "resume":
            player?.play()
            result(nil)
        case "stop":
            stop(result: result)
        case "seek":
            guard let args = call.arguments as? [String: Any],
                  let ms = args["positionMs"] as? Int else {
                result(FlutterError(code: "INVALID_ARGS", message: "positionMs requis", details: nil))
                return
            }
            seek(milliseconds: ms, result: result)
        case "setVolume":
            guard let args = call.arguments as? [String: Any],
                  let volume = args["volume"] as? Double else {
                result(FlutterError(code: "INVALID_ARGS", message: "volume requis", details: nil))
                return
            }
            player?.volume = Float(volume)
            result(nil)
        case "currentPositionMs":
            result(currentPositionMs())
        case "durationMs":
            result(durationMs())
        case "showRoutePicker":
            showRoutePicker(result: result)
        case "dispose":
            stop(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Prepare

    private func prepare(result: @escaping FlutterResult) {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default, options: [.allowBluetooth, .allowAirPlay])
            try session.setActive(true)
            result(nil)
        } catch {
            result(FlutterError(code: "SESSION_ERROR", message: error.localizedDescription, details: nil))
        }
    }

    // MARK: - Play

    private func play(
        url: String,
        title: String?,
        artist: String?,
        albumArtUrl: String?,
        result: @escaping FlutterResult
    ) {
        guard let url = URL(string: url) else {
            result(FlutterError(code: "INVALID_URL", message: "URL invalide : \(url)", details: nil))
            return
        }

        // Nettoie le player précédent
        teardownPlayer()

        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()

        // Métadonnées Now Playing
        updateNowPlaying(title: title, artist: artist, albumArtUrl: albumArtUrl)

        result(nil)
    }

    // MARK: - Stop

    private func stop(result: @escaping FlutterResult) {
        teardownPlayer()
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        result(nil)
    }

    private func teardownPlayer() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
        player?.pause()
        player = nil
        playerItem = nil
    }

    // MARK: - Seek

    private func seek(milliseconds: Int, result: @escaping FlutterResult) {
        let time = CMTime(value: CMTimeValue(milliseconds), timescale: 1000)
        player?.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero) { _ in
            result(nil)
        }
    }

    // MARK: - Position / Duration

    private func currentPositionMs() -> Int? {
        guard let time = player?.currentTime(), time.isValid, !time.isIndefinite else {
            return nil
        }
        return Int(CMTimeGetSeconds(time) * 1000)
    }

    private func durationMs() -> Int? {
        guard let duration = player?.currentItem?.duration,
              duration.isValid,
              !duration.isIndefinite else {
            return nil
        }
        return Int(CMTimeGetSeconds(duration) * 1000)
    }

    // MARK: - Now Playing

    private func updateNowPlaying(title: String?, artist: String?, albumArtUrl: String?) {
        var info: [String: Any] = [:]
        if let title { info[MPMediaItemPropertyTitle] = title }
        if let artist { info[MPMediaItemPropertyArtist] = artist }
        info[MPNowPlayingInfoPropertyMediaType] = MPNowPlayingInfoMediaType.audio.rawValue

        if let albumArtUrl, let url = URL(string: albumArtUrl) {
            // Chargement de l'artwork de façon asynchrone
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data, let image = UIImage(data: data) {
                    info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(
                        boundsSize: image.size
                    ) { _ in image }
                }
                DispatchQueue.main.async {
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = info
                }
            }.resume()
        } else {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        }
    }

    // MARK: - Route Picker

    private func showRoutePicker(result: @escaping FlutterResult) {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }),
                  let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
                result(nil)
                return
            }

            let picker = AVRoutePickerView(frame: .zero)
            picker.isHidden = true
            window.addSubview(picker)

            // Déclenche le picker programmatiquement
            for subview in picker.subviews {
                if let button = subview as? UIButton {
                    button.sendActions(for: .touchUpInside)
                    break
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                picker.removeFromSuperview()
                result(nil)
            }
        }
    }
}
