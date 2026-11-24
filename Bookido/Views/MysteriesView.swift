//
//  MysteriesView.swift
//  Bookido
//
//  Created by Stefania Rosciano on 24/11/2026.
//

import SwiftUI

struct MysteriesView: View {
    @Environment(BookStore.self) private var bookStore: BookStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        let currentBook = bookStore.selectedBook
        let openMystery = currentBook?.nextLockedCheckpoint?.mystery
        let solvedMysteries = currentBook?.unlockedCheckpoints.map { $0.mystery } ?? []

        ZStack(alignment: .topLeading) {
            SketchTheme.mainBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Mysteries")
                            .font(.system(.largeTitle, design: .serif, weight: .bold))
                            .foregroundStyle(SketchTheme.primaryAccent)

                    }
                    .padding(.top, 56)

                    if let openMystery {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Open")
                                .font(.system(.title3, design: .serif, weight: .bold))
                                .foregroundStyle(SketchTheme.primaryAccent)

                            MysteriesCardsView(mystery: openMystery)
                        }
                    }

                    Text("More questions open as you read")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(SketchTheme.secondaryAccent)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(
                                    SketchTheme.secondaryAccent.opacity(0.4),
                                    style: StrokeStyle(lineWidth: 1.5, dash: [4, 4])
                                )
                        )

                    if !solvedMysteries.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Solved")
                                .font(.system(.title3, design: .serif, weight: .bold))
                                .foregroundStyle(SketchTheme.primaryAccent)

                            ForEach(solvedMysteries) { mystery in
                                MysteriesCardsView(mystery: mystery)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }

            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .foregroundStyle(SketchTheme.primaryAccent)
                    .padding(12)
                    .background(.ultraThinMaterial, in: Circle())
                    .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let store = BookStore()
    if let firstBook = store.books.first {
        store.selectBook(firstBook)
    }
    return NavigationStack {
        MysteriesView()
            .environment(store)
    }
}
