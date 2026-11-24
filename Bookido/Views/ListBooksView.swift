//
//  ListBooksView.swift
//  Bookido
//
//  Created by Stefania Rosciano on 23/11/2026.
//

import SwiftUI

struct ListBooksView: View {
    // let isOnboarding: Bool NOT NEEDED - We check whether there is a bookStore.selectedBook
    @Environment(\.dismiss) private var dismiss
    @Environment(BookStore.self) private var bookStore: BookStore?
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
                Text(bookStore?.selectedBook == nil ? "Pick a Book to start with" : "Our Books")
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
        .task {
            if availableBooks.isEmpty {
                fallbackBooks = (try? BookDataService.shared.loadBooks()) ?? []
            }
        }
    }

    private func select(book: Book) {
        bookStore?.selectBook(book)
        dismiss()
    }
}

#Preview {
    ListBooksView(
    )
}
