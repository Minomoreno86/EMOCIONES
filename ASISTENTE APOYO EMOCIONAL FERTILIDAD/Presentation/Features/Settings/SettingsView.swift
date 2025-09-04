import SwiftUI

struct SettingsView: View {
	@AppStorage("app_locale") private var appLocale: String = Locale.current.language.languageCode?.identifier ?? "es"
	var body: some View {
		Form {
			Picker("settings_locale", selection: $appLocale) {
				Text("settings_locale_es").tag("es")
				Text("settings_locale_en").tag("en")
			}
		}
		.navigationTitle("settings_title")
	}
}
