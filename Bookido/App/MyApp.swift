import SwiftUI

@main
struct MyApp: App {
    @State private var errorManager = ErrorManager.shared
    @State private var bookStore: BookStore

    init() {

        UserDefaults.standard.removeObject(forKey: BookStore.selectedBookStorageKey)

        _bookStore = State(initialValue: BookStore())
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(bookStore)
                .withErrorAlert(manager: errorManager)
        }
    }
}
