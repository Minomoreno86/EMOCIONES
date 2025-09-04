import SwiftUI
import Charts

struct InsightsView: View {
	var body: some View {
		VStack {
			Text("insights_title")
			Chart {
				BarMark(x: .value("x", 1), y: .value("y", 1))
			}
		}
		.navigationTitle("insights_nav")
	}
}
