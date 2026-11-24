import SwiftUI
import Playgrounds

struct ContentView: View {
    @Environment(\.errorManager) private var errorManager
    @State private var bookStore = BookStore(loadImmediately: true)

    var body: some View {
        Group {
            if bookStore.selectedBook != nil {
                JourneyView()
            } else {
                OnBoardingView()
            }
        }
        .environment(bookStore)
        .task {
            do {
                try bookStore.loadBooks()
            } catch {
                errorManager.handle(error, defaultTitle: "Startup Error")
            }
        }
    }
}

#Preview {
    ContentView()
        .withErrorAlert()
}

#Playground {
    _ = 1 + 2
}
