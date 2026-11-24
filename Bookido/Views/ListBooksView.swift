//
//  ListBooksView.swift
//  Bookido
//
//  Created by Stefania Rosciano on 23/11/2026.
//

import SwiftUI

struct ListBooksView: View {
    let isOnboarding: Bool
    @Environment(\.dismiss) private var dismiss
    @Environment(BookStore.self) private var bookStore: BookStore?
    @AppStorage(BookStore.selectedBookStorageKey) private var selectedBookIdString: String = ""
    @State private var fallbackBooks: [Book] = []

    private var availableBooks: [Book] {
        if let storeBooks = bookStore?.books, !storeBooks.isEmpty {
            return storeBooks
        }
        return fallbackBooks
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            SketchTheme.mainBackground
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                Text("Pick a Book to start with")
                    .font(.system(.largeTitle, design: .serif, weight: .bold))
                    .foregroundStyle(SketchTheme.primaryAccent)
                    .padding(.top, 60)
                    .padding(.horizontal, 24)

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(availableBooks) { book in
                            Button {
                                select(book: book)
                            } label: {
                                BookCardView(viewModel: BookCardViewModel(book: book))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }

            if isOnboarding {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .foregroundStyle(SketchTheme.primaryAccent)
                        .padding(12)
                        .background(.ultraThinMaterial, in: Circle())
                        .padding()
                }
            }
        }
        .task {
            if availableBooks.isEmpty {
                fallbackBooks = (try? BookStore.loadFromJSON()) ?? []
            }
        }
    }

    private func select(book: Book) {
        bookStore?.selectBook(book)
        selectedBookIdString = book.id.uuidString
        dismiss()
    }
}

#Preview {
    ListBooksView(
        isOnboarding: true
    )
}
