import SwiftUI

@main
struct PlanetsApp: App {
	
	@StateObject var model = AppModel()
	
    var body: some Scene {
        WindowGroup {
			ContentView(model: model)
        }
    }
}
