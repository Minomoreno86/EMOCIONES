import Foundation
import Security

public final class KeychainService {
	public init() {}
	public func set(value: Data, for key: String) -> Bool {
		let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
									kSecAttrAccount as String: key,
									kSecValueData as String: value]
		SecItemDelete(query as CFDictionary)
		let status = SecItemAdd(query as CFDictionary, nil)
		return status == errSecSuccess
	}
	public func get(for key: String) -> Data? {
		let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
									kSecAttrAccount as String: key,
									kSecReturnData as String: true]
		var result: AnyObject?
		let status = SecItemCopyMatching(query as CFDictionary, &result)
		guard status == errSecSuccess else { return nil }
		return result as? Data
	}
}
