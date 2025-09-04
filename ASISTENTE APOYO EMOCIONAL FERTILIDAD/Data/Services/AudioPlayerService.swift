import Foundation
import AVFoundation

public final class AudioPlayerService: NSObject, ObservableObject {
	private var player: AVAudioPlayer?
	@Published public private(set) var isPlaying: Bool = false
	public func play(asset: String) {
		guard let url = Bundle.main.url(forResource: asset, withExtension: nil) else { return }
		player = try? AVAudioPlayer(contentsOf: url)
		player?.prepareToPlay()
		player?.play(); isPlaying = true
	}
	public func stop() { player?.stop(); isPlaying = false }
}
