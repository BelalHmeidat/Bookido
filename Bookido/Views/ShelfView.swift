//
//  ShelfView.swift
//  Bookido
//
//  Created by Stefania Rosciano on 24/11/2026.
//

import SwiftUI

struct ShelfView: View {
    @Environment(BookStore.self) private var bookStore: BookStore
    @Environment(\.dismiss) private var dismiss

    @State private var showAddBookSheet: Bool = false
    @State private var showScanner: Bool = false
    @State private var showListBooks: Bool = false

    private let columns = [
        GridItem(.flexible(), spacing: 20, alignment: .top),
        GridItem(.flexible(), spacing: 20, alignment: .top)
    ]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                SketchTheme.mainBackground
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 24) {
                    Text("My Books")
                        .font(.system(.largeTitle, design: .serif, weight: .bold))
                        .foregroundStyle(SketchTheme.primaryAccent)
                        .padding(.top, 56)

                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(bookStore.shelfBooks) { book in
                                Button {
                                    bookStore.selectBook(book)
                                    dismiss()
                                } label: {
                                    VStack(alignment: .leading, spacing: 8) {
                                        ShelfBookCoverView(book: book)

                                        HStack(spacing: 8) {
                                            Text(book.title)
                                                .font(.system(.subheadline, design: .serif, weight: .semibold))
                                                .foregroundStyle(SketchTheme.primaryAccent)
                                                .lineLimit(1)

                                            Spacer(minLength: 4)

                                            ShelfProgressCircle(percentage: book.checkpointProgressPercentage)
                                        }
                                        .frame(width: 145)
                                    }
                                }
                                .buttonStyle(.plain)
                            }

                            Button {
                                showAddBookSheet = true
                            } label: {
                                RoundedRectangle(cornerRadius: 14)
                                    .strokeBorder(
                                        SketchTheme.accentBlue,
                                        style: StrokeStyle(lineWidth: 1.5, dash: [6, 6])
                                    )
                                    .frame(width: 145, height: 215)
                                    .overlay {
                                        Image(systemName: "plus.app")
                                            .font(.system(size: 28, weight: .medium))
                                            .foregroundStyle(SketchTheme.accentBlue)
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 24)

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
            .sheet(isPresented: $showAddBookSheet) {
                AddBookSheetView(
                    onScanBook: {
                        showAddBookSheet = false
                        showScanner = true
                    },
                    onOtherBooks: {
                        showAddBookSheet = false
                        showListBooks = true
                    }
                )
                .presentationDetents([.height(200)])
                .presentationDragIndicator(.visible)
                .presentationBackground(.ultraThinMaterial)
            }
            .fullScreenCover(isPresented: $showScanner) {
                ScannerView()
            }
            .fullScreenCover(isPresented: $showListBooks) {
                BookListView()
            }
            .onAppear {
                for id in bookStore.shelfBookIds {
                    bookStore.hydrateDetailsIfNeeded(for: id)
                }
            }
        }
    }
}

struct ShelfProgressCircle: View {
    let percentage: Int

    private var progress: Double {
        min(max(Double(percentage) / 100.0, 0), 1)
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(SketchTheme.secondaryAccent.opacity(0.25), lineWidth: 3)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    SketchTheme.accentBlue,
                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            Text("\(percentage)%")
                .font(.system(size: 8, weight: .bold, design: .rounded))
                .foregroundStyle(SketchTheme.primaryAccent)
        }
        .frame(width: 28, height: 28)
    }
}

struct ShelfBookCoverView: View {
    let book: Book

    var body: some View {
        if !book.coverImage.isEmpty, let uiImage = UIImage(named: book.coverImage) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 145, height: 215)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(SketchTheme.darkBackground)

                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(SketchTheme.surfaceCards.opacity(0.3), lineWidth: 1)
                    .padding(10)

                VStack(spacing: 12) {
                    Circle()
                        .fill(SketchTheme.surfaceCards.opacity(0.15))
                        .frame(width: 56, height: 56)
                        .overlay {
                            Image(systemName: "cube")
                                .font(.title2)
                                .foregroundStyle(SketchTheme.primaryAccent)
                        }

                    Text(book.title.uppercased())
                        .font(.system(.caption, design: .serif, weight: .bold))
                        .foregroundStyle(SketchTheme.surfaceCards)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)

                    Text(book.author)
                        .font(.system(size: 10, design: .serif))
                        .foregroundStyle(SketchTheme.surfaceCards.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)
                }
            }
            .frame(width: 145, height: 215)
            .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
        }
    }
}

struct AddBookSheetView: View {
    @Environment(\.dismiss) private var dismiss
    let onScanBook: () -> Void
    let onOtherBooks: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .padding(10)
                    .background(.ultraThinMaterial, in: Circle())
            }

            Spacer()

            VStack(spacing: 12) {
                Button {
                    onScanBook()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "camera.fill")
                        Text("Scan your book")
                    }
                    .font(.system(.callout, design: .rounded, weight: .semibold))
                    .foregroundStyle(SketchTheme.surfaceCards)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(SketchTheme.accentBlue, in: Capsule())
                }

                Button {
                    onOtherBooks()
                } label: {
                    Text("Other Books")
                        .font(.system(.callout, design: .rounded, weight: .semibold))
                        .foregroundStyle(SketchTheme.surfaceCards)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(SketchTheme.primaryAccent, in: Capsule())
                }
            }
        }
        .padding(20)
    }
}

#Preview {
    let store = BookStore()
    if let firstBook = store.books.first {
        store.selectBook(firstBook)
    }
    return ShelfView()
        .environment(store)
}
