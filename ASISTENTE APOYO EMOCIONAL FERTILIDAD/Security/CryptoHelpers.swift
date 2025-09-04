import Foundation
import CryptoKit

public enum CryptoHelpers {
	public static func sha256Hex(_ string: String) -> String {
		let data = Data(string.utf8)
		let digest = SHA256.hash(data: data)
		return digest.compactMap { String(format: "%02x", $0) }.joined()
	}
}
