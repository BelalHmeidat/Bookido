//
//  UnlockedCardsView.swift
//  Bookido
//
//  Created by Stefania Rosciano on 25/11/2026.
//

import SwiftUI

struct UnlockedCardsView: View {
    @Environment(BookStore.self) private var bookStore: BookStore

    @State private var selectedCheckpointID: UUID?
    @State private var showExpandedCarousel: Bool = false

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        let unlockedCheckpoints = bookStore.selectedBook?.unlockedCheckpoints ?? []

        ZStack(alignment: .topLeading) {
            SketchTheme.mainBackground
                .ignoresSafeArea()

            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Unlocked Cards")
                        .font(.system(.largeTitle, design: .serif, weight: .bold))
                        .foregroundStyle(SketchTheme.primaryAccent)

                    Text("\(unlockedCheckpoints.count) collected so far")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(SketchTheme.secondaryAccent)
                }
                .padding(.horizontal, 24)

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(unlockedCheckpoints) { checkpoint in
                            Button {
                                selectedCheckpointID = checkpoint.id
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                    showExpandedCarousel = true
                                }
                            } label: {
                                MiniRewardCardView(checkpoint: checkpoint)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
            }

            if showExpandedCarousel {
                ZStack(alignment: .topLeading) {
                    SketchTheme.accentBlue
                        .ignoresSafeArea()

                    TabView(selection: $selectedCheckpointID) {
                        ForEach(unlockedCheckpoints) { checkpoint in
                            ExpandedRewardCardItemView(checkpoint: checkpoint)
                                .tag(Optional(checkpoint.id))
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))

                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            showExpandedCarousel = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding(12)
                            .background(.ultraThinMaterial, in: Circle())
                            .padding()
                    }
                }
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
    }
}

struct MiniRewardCardView: View {
    let checkpoint: Checkpoint

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                SketchTheme.mainBackground

                Image(systemName: checkpoint.icon)
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundStyle(SketchTheme.primaryAccent)
            }
            .frame(height: 105)
            .frame(maxWidth: .infinity)

            VStack(alignment: .leading, spacing: 6) {
                Text("Event")
                    .font(.system(.caption2, design: .rounded, weight: .semibold))
                    .foregroundStyle(SketchTheme.accentBlue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(SketchTheme.accentBlue.opacity(0.2), in: Capsule())

                Text(checkpoint.title)
                    .font(.system(.subheadline, design: .serif, weight: .bold))
                    .foregroundStyle(SketchTheme.primaryAccent)
                    .lineLimit(2)

                Text(checkpoint.description)
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(SketchTheme.secondaryAccent)
                    .lineLimit(2)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(SketchTheme.surfaceCards)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 3)
    }
}

struct ExpandedRewardCardItemView: View {
    let checkpoint: Checkpoint

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                SketchTheme.mainBackground

                Image(systemName: checkpoint.icon)
                    .font(.system(size: 56, weight: .semibold))
                    .foregroundStyle(SketchTheme.primaryAccent)
            }
            .frame(width: 280, height: 205)

            VStack(alignment: .leading, spacing: 10) {
                Text("Event")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(SketchTheme.accentBlue)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 5)
                    .background(SketchTheme.accentBlue.opacity(0.2), in: Capsule())

                Text(checkpoint.title)
                    .font(.system(.title2, design: .serif, weight: .bold))
                    .foregroundStyle(SketchTheme.primaryAccent)

                Text(checkpoint.description)
                    .font(.system(.subheadline, design: .rounded, weight: .regular))
                    .foregroundStyle(SketchTheme.secondaryAccent)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(22)
            .frame(width: 280, alignment: .leading)
            .background(SketchTheme.surfaceCards)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 6)
    }
}

#Preview {
    let store = BookStore()
    if let firstBook = store.books.first {
        store.selectBook(firstBook)
        for i in store.books[0].checkpoints.indices {
            store.books[0].checkpoints[i].unlockedAt = Date()
        }
    }
    return UnlockedCardsView()
        .environment(store)
}
