import SwiftUI

struct ContentView: View {
	@ObservedObject var model: AppModel
	
	var body: some View {
		NavigationView {
			List{
				ForEach(model.planets, id: \.id) {
					Text($0.name)
				}
			}
		}.navigationTitle("Planets")
	}
}
