//
//  UnlockedCardsView.swift
//  Bookido
//
//  Created by Stefania Rosciano on 25/11/2026.
//

import SwiftUI

enum UnlockableCardFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case event = "Event"
    case location = "Location"

    var id: String { rawValue }
}

struct UnlockableCardItem: Identifiable {
    let id: String
    let category: UnlockableCardFilter
    let title: String
    let description: String
    let icon: String
    let fallbackSymbol: String

    init(checkpoint: Checkpoint) {
        self.id = "event_\(checkpoint.id.uuidString)"
        self.category = .event
        self.title = checkpoint.title
        self.description = checkpoint.description
        self.icon = checkpoint.icon
        self.fallbackSymbol = "checkmark"
    }

    init(location: Location) {
        self.id = "location_\(location.id.uuidString)"
        self.category = .location
        self.title = location.name
        self.description = location.description
        self.icon = location.icon
        self.fallbackSymbol = "map.fill"
    }
}

struct UnlockedCardsView: View {
    @Environment(BookStore.self) private var bookStore: BookStore
    @Environment(\.dismiss) private var dismiss

    @State private var selectedFilter: UnlockableCardFilter
    @State private var selectedCardID: String?
    @State private var showExpandedCarousel: Bool

    init(
        initialFilter: UnlockableCardFilter = .all,
        initialCardID: String? = nil
    ) {
        _selectedFilter = State(initialValue: initialFilter)
        _selectedCardID = State(initialValue: initialCardID)
        _showExpandedCarousel = State(initialValue: initialCardID != nil)
    }

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        let unlockedCheckpoints = bookStore.selectedBook?.unlockedCheckpoints ?? []
        let unlockedLocations = bookStore.selectedBook?.unlockedLocations ?? []

        let allCards: [UnlockableCardItem] =
            unlockedCheckpoints.map { UnlockableCardItem(checkpoint: $0) } +
            unlockedLocations.map { UnlockableCardItem(location: $0) }

        let filteredCards: [UnlockableCardItem] = switch selectedFilter {
        case .all:
            allCards
        case .event:
            allCards.filter { $0.category == .event }
        case .location:
            allCards.filter { $0.category == .location }
        }

        ZStack(alignment: .topLeading) {
            SketchTheme.mainBackground
                .ignoresSafeArea()

            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Unlocked Cards")
                        .font(.system(.largeTitle, design: .serif, weight: .bold))
                        .foregroundStyle(SketchTheme.primaryAccent)

                    Text("\(filteredCards.count) collected so far")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(SketchTheme.secondaryAccent)
                }
                .padding(.top, 56)
                .padding(.horizontal, 24)

                if filteredCards.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: selectedFilter == .location ? "map" : "sparkles")
                            .font(.system(size: 44))
                            .foregroundStyle(SketchTheme.secondaryAccent.opacity(0.5))

                        Text("Unlock checkpoints to collect cards")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(SketchTheme.secondaryAccent)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 24)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(filteredCards) { card in
                                Button {
                                    selectedCardID = card.id
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                        showExpandedCarousel = true
                                    }
                                } label: {
                                    MiniRewardCardView(card: card)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                    }
                }
            }

            if showExpandedCarousel {
                ZStack(alignment: .topLeading) {
                    SketchTheme.accentBlue
                        .ignoresSafeArea()

                    VStack(spacing: 0) {
                        TabView(selection: $selectedCardID) {
                            ForEach(filteredCards) { card in
                                ExpandedRewardCardItemView(card: card)
                                    .tag(Optional(card.id))
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .always))

                        if let activeCard = filteredCards.first(where: { $0.id == selectedCardID }) ?? filteredCards.first {
                            ShareCardButton(card: activeCard)
                                .padding(.horizontal, 40)
                                .padding(.bottom, 28)
                        }
                    }

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
            } else {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundStyle(SketchTheme.primaryAccent)
                            .padding(12)
                            .background(.ultraThinMaterial, in: Circle())
                    }

                    Spacer()

                    Menu {
                        ForEach(UnlockableCardFilter.allCases) { filter in
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedFilter = filter
                                }
                            } label: {
                                if selectedFilter == filter {
                                    Label(filter.rawValue, systemImage: "checkmark")
                                } else {
                                    Text(filter.rawValue)
                                }
                            }
                        }
                    } label: {
                        Image(systemName: selectedFilter == .all
                              ? "line.3.horizontal.decrease.circle"
                              : "line.3.horizontal.decrease.circle.fill")
                            .font(.headline)
                            .foregroundStyle(selectedFilter == .all ? SketchTheme.primaryAccent : SketchTheme.accentBlue)
                            .padding(12)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct MiniRewardCardView: View {
    let card: UnlockableCardItem

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                SketchTheme.mainBackground

                CheckpointIconView(
                    name: card.icon,
                    preferredVariant: .medium,
                    assetSize: 88,
                    symbolSize: 32,
                    symbolColor: SketchTheme.primaryAccent,
                    fallbackSymbol: card.fallbackSymbol
                )
            }
            .frame(height: 105)
            .frame(maxWidth: .infinity)

            VStack(alignment: .leading, spacing: 6) {
                Text(card.category.rawValue)
                    .font(.system(.caption2, design: .rounded, weight: .semibold))
                    .foregroundStyle(SketchTheme.accentBlue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(SketchTheme.accentBlue.opacity(0.2), in: Capsule())

                Text(card.title)
                    .font(.system(.subheadline, design: .serif, weight: .bold))
                    .foregroundStyle(SketchTheme.primaryAccent)
                    .lineLimit(2)

                Text(card.description)
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
    let card: UnlockableCardItem

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                SketchTheme.mainBackground

                CheckpointIconView(
                    name: card.icon,
                    preferredVariant: .large,
                    assetSize: 180,
                    symbolSize: 56,
                    symbolColor: SketchTheme.primaryAccent,
                    fallbackSymbol: card.fallbackSymbol
                )
            }
            .frame(width: 280, height: 205)

            VStack(alignment: .leading, spacing: 10) {
                Text(card.category.rawValue)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(SketchTheme.accentBlue)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 5)
                    .background(SketchTheme.accentBlue.opacity(0.2), in: Capsule())

                Text(card.title)
                    .font(.system(.title2, design: .serif, weight: .bold))
                    .foregroundStyle(SketchTheme.primaryAccent)

                Text(card.description)
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

struct ShareCardButton: View {
    let card: UnlockableCardItem
    @State private var renderedImage: Image?

    var body: some View {
        Group {
            if let renderedImage {
                ShareLink(
                    item: renderedImage,
                    preview: SharePreview(card.title, image: renderedImage)
                ) {
                    shareLabel
                }
            } else {
                shareLabel
                    .opacity(0.6)
            }
        }
        .task(id: card.id) {
            renderedImage = renderImage()
        }
    }

    private var shareLabel: some View {
        Label("Share", systemImage: "square.and.arrow.up")
            .font(.system(.body, design: .rounded, weight: .semibold))
            .foregroundStyle(SketchTheme.accentBlue)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(SketchTheme.mainBackground, in: Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(.white.opacity(0.5), lineWidth: 1)
            )
    }

    @MainActor
    private func renderImage() -> Image? {
        let snapshot = ExpandedRewardCardItemView(card: card)
            .padding(24)
            .background(SketchTheme.accentBlue)
        let renderer = ImageRenderer(content: snapshot)
        renderer.scale = 3.0
        #if canImport(UIKit)
        if let uiImage = renderer.uiImage {
            return Image(uiImage: uiImage)
        }
        #elseif canImport(AppKit)
        if let nsImage = renderer.nsImage {
            return Image(nsImage: nsImage)
        }
        #endif
        return nil
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
