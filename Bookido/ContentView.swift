import SwiftUI
import Playgrounds

struct ContentView: View {
    @Environment(\.errorManager) private var errorManager
    @State private var bookStore = BookStore(loadImmediately: false)

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let book = bookStore.selectedBook {
                    Text(book.title)
                        .font(.title)
                        .bold()
                    Text("By \(book.author)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    Text("No Book Loaded")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }

                Button("Load Library") {
                    do {
                        try bookStore.loadBooks()
                    } catch {
                        errorManager.handle(error, defaultTitle: "Failed to Load Books")
                    }
                }
                .buttonStyle(.borderedProminent)

                Button("Trigger Missing File Error (Test)") {
                    do {
                        try bookStore.loadBooks(fileName: "NonExistentFile")
                    } catch {
                        errorManager.handle(error, defaultTitle: "Error Loading Data")
                    }
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .navigationTitle("Bookido")
            .task {
                do {
                    try bookStore.loadBooks()
                } catch {
                    errorManager.handle(error, defaultTitle: "Startup Error")
                }
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
