import SwiftUI

@main struct MyApp: App {
    @State private var errorManager = ErrorManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .withErrorAlert(manager: errorManager)
        }
    }
}
