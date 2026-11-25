//
//  JourneyView.swift
//  Bookido
//
//  Created by Stefania Rosciano on 23/11/2026.
//

import SwiftUI

/// Animatable curved path segment connecting the previous checkpoint to the current checkpoint.
struct JourneyPathSegment: Shape {
    var fromX: CGFloat
    var toX: CGFloat

    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(fromX, toX) }
        set {
            fromX = newValue.first
            toX = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let startPoint = CGPoint(x: fromX, y: 0)
        let endPoint = CGPoint(x: toX, y: rect.height)
        let control1 = CGPoint(x: fromX, y: rect.height * 0.5)
        let control2 = CGPoint(x: toX, y: rect.height * 0.5)

        path.move(to: startPoint)
        path.addCurve(to: endPoint, control1: control1, control2: control2)
        return path
    }
}

/// Animatable curved path from the Start node to the first checkpoint.
struct StartToNodePath: Shape {
    var startX: CGFloat
    var startY: CGFloat
    var toX: CGFloat

    var animatableData: CGFloat {
        get { toX }
        set { toX = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let startPoint = CGPoint(x: startX, y: startY)
        let endPoint = CGPoint(x: toX, y: rect.height)
        let control1 = CGPoint(x: startX, y: rect.height * 0.6)
        let control2 = CGPoint(x: toX, y: rect.height * 0.4)

        path.move(to: startPoint)
        path.addCurve(to: endPoint, control1: control1, control2: control2)
        return path
    }
}

struct JourneyView: View {
    @Environment(BookStore.self) private var bookStore: BookStore

    @State private var showBooksList: Bool = false
    @State private var showCharacters: Bool = false
    @State private var showLocations: Bool = false
    @State private var showMysteries: Bool = false
    @State private var expandedCheckpointId: UUID? = nil

    private func isNodeExpanded(_ checkpoint: Checkpoint) -> Bool {
        expandedCheckpointId == checkpoint.id
    }

    private func nodeX(for index: Int, checkpoint: Checkpoint, screenWidth: CGFloat) -> CGFloat {
        let centerX = screenWidth * 0.5
        if isNodeExpanded(checkpoint) {
            return centerX
        } else {
            let isRight = (index % 2 == 0)
            let sideOffset = screenWidth * 0.26
            return isRight ? (centerX + sideOffset) : (centerX - sideOffset)
        }
    }

    private func nodeOffset(for index: Int, checkpoint: Checkpoint, screenWidth: CGFloat) -> CGFloat {
        if isNodeExpanded(checkpoint) {
            return 0
        } else {
            let isRight = (index % 2 == 0)
            let sideOffset = screenWidth * 0.26
            return isRight ? sideOffset : -sideOffset
        }
    }

    private func scrollToCurrentCheckpoint(
        using scrollProxy: ScrollViewProxy,
        checkpoints: [Checkpoint],
        animated: Bool = true
    ) {
        guard let targetId = checkpoints.last(where: { $0.isUnlocked })?.id ?? checkpoints.first?.id else {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            if animated {
                withAnimation(.easeInOut(duration: 0.7)) {
                    scrollProxy.scrollTo(targetId, anchor: .center)
                }
            } else {
                scrollProxy.scrollTo(targetId, anchor: .center)
            }
        }
    }

    var body: some View {
        let currentBook = bookStore.selectedBook
        let checkpoints = currentBook?.checkpoints ?? []
        let nextLockedId = currentBook?.nextLockedCheckpoint?.id
        let lastUnlockedId = currentBook?.unlockedCheckpoints.last?.id

        NavigationStack {
            ZStack {
                SketchTheme.mainBackground
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Top Navigation Header
                    HStack(alignment: .center) {
                        Button {
                            showBooksList = true
                        } label: {
                            Text("\(Image(systemName: "books.vertical"))")
                                .font(.system(.headline, design: .rounded, weight: .semibold))
                                .foregroundStyle(SketchTheme.primaryAccent)
                                .frame(width: 44, height: 44)
                                .background(.ultraThinMaterial, in: Circle())
                                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                        }

                        Spacer()

                        VStack {
                            Text(currentBook?.title ?? "Journey")
                                .font(.system(.title, design: .serif, weight: .bold))
                                .foregroundStyle(SketchTheme.primaryAccent)
                                .multilineTextAlignment(.center)

                            Text(currentBook != nil ? "\(currentBook?.checkpointProgressPercentage ?? 0)% completed" : "Select a book")
                                .font(.system(.footnote, design: .rounded, weight: .regular))
                                .foregroundStyle(SketchTheme.primaryAccent)
                        }

                        Spacer()

                        Menu {
                            Button {
                                showMysteries = true
                            } label: {
                                Label("Mysteries", systemImage: "magnifyingglass")
                                    .font(.system(.headline))
                            }

                            Button {
                                showCharacters = true
                            } label: {
                                Label("Characters", systemImage: "person.2")
                            }

                            Button {
                                showLocations = true
                            } label: {
                                Label("Locations", systemImage: "map")
                            }
                        } label: {
                            Text("\(Image(systemName: "line.3.horizontal"))")
                                .font(.system(.headline, design: .rounded, weight: .semibold))
                                .foregroundStyle(SketchTheme.primaryAccent)
                                .frame(width: 44, height: 44)
                                .background(.ultraThinMaterial, in: Circle())
                                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    .padding(.bottom, 8)

                    GeometryReader { proxy in
                        let screenWidth = max(proxy.size.width, 320)

                        ScrollViewReader { scrollProxy in
                            ScrollView {
                                VStack(spacing: 0) {
                                    // Start Section
                                    ZStack(alignment: .topLeading) {
                                        if !checkpoints.isEmpty {
                                            StartToNodePath(
                                                startX: 44,
                                                startY: 28,
                                                toX: nodeX(for: 0, checkpoint: checkpoints[0], screenWidth: screenWidth)
                                            )
                                            .stroke(
                                                SketchTheme.primaryAccent,
                                                style: StrokeStyle(lineWidth: 1.5, dash: [4, 4])
                                            )
                                        }

                                        HStack {
                                            StartNodeView()
                                                .padding(.leading, 30)

                                            Spacer()

                                            Circle()
                                                .frame(width: 100, height: 80)
                                                .foregroundStyle(SketchTheme.darkBackground)
                                                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 4)
                                                .padding(.trailing, 24)
                                        }
                                    }
                                    .frame(width: screenWidth, height: 160)
                                    .padding(.top, 20)

                                    // Checkpoints Flow
                                    ForEach(Array(checkpoints.enumerated()), id: \.element.id) { index, checkpoint in
                                        VStack(spacing: 0) {
                                            if index > 0 {
                                                JourneyPathSegment(
                                                    fromX: nodeX(for: index - 1, checkpoint: checkpoints[index - 1], screenWidth: screenWidth),
                                                    toX: nodeX(for: index, checkpoint: checkpoint, screenWidth: screenWidth)
                                                )
                                                .stroke(
                                                    SketchTheme.primaryAccent,
                                                    style: StrokeStyle(lineWidth: 1.5, dash: [4, 4])
                                                )
                                                .frame(width: screenWidth, height: 60)
                                            }

                                            let viewModel = NodeViewModel(
                                                checkpoint: checkpoint,
                                                isNextLocked: checkpoint.id == nextLockedId,
                                                isLastUnlocked: checkpoint.id == lastUnlockedId,
                                                isExpanded: isNodeExpanded(checkpoint),
                                                bookId: currentBook?.id
                                            )

                                            NodeView(
                                                viewModel: viewModel,
                                                onToggleExpand: {
                                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.78)) {
                                                        if expandedCheckpointId == checkpoint.id {
                                                            expandedCheckpointId = nil
                                                        } else {
                                                            expandedCheckpointId = checkpoint.id
                                                            scrollProxy.scrollTo(checkpoint.id, anchor: .center)
                                                        }
                                                    }
                                                },
                                                onUnlocked: {
                                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.78)) {
                                                        expandedCheckpointId = checkpoint.id
                                                        scrollProxy.scrollTo(checkpoint.id, anchor: .center)
                                                    }
                                                }
                                            )
                                            .frame(maxWidth: .infinity)
                                            .offset(x: nodeOffset(for: index, checkpoint: checkpoint, screenWidth: screenWidth))
                                            .id(checkpoint.id)
                                        }
                                    }
                                }
                                .frame(width: screenWidth)
                                .padding(.bottom, 60)
                            }
                            .frame(width: proxy.size.width, height: proxy.size.height)
                            .onAppear {
                                scrollToCurrentCheckpoint(using: scrollProxy, checkpoints: checkpoints, animated: true)
                            }
                            .onChange(of: currentBook?.id) { _, _ in
                                scrollToCurrentCheckpoint(using: scrollProxy, checkpoints: checkpoints, animated: true)
                            }
                            .onChange(of: currentBook?.unlockedCheckpoints.count) { _, _ in
                                scrollToCurrentCheckpoint(using: scrollProxy, checkpoints: checkpoints, animated: true)
                            }
                            .onChange(of: showBooksList) { _, isPresented in
                                if !isPresented {
                                    scrollToCurrentCheckpoint(using: scrollProxy, checkpoints: checkpoints, animated: true)
                                }
                            }
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showBooksList) {
                ShelfView()
            }
            .navigationDestination(isPresented: $showCharacters) {
                CharactersView()
            }
            .navigationDestination(isPresented: $showLocations) {
                LocationsView()
            }
            .navigationDestination(isPresented: $showMysteries) {
                MysteriesView()
            }
            .onAppear {
                if let bookId = bookStore.selectedBookId {
                    bookStore.hydrateDetailsIfNeeded(for: bookId)
                }
                if expandedCheckpointId == nil {
                    expandedCheckpointId = currentBook?.unlockedCheckpoints.last?.id
                }
            }
            .onChange(of: currentBook?.id) { _, newId in
                if let newId {
                    bookStore.hydrateDetailsIfNeeded(for: newId)
                    expandedCheckpointId = bookStore.selectedBook?.unlockedCheckpoints.last?.id
                }
            }
            .onChange(of: currentBook?.unlockedCheckpoints.count) { _, _ in
                expandedCheckpointId = currentBook?.unlockedCheckpoints.last?.id
            }
        }
    }
}

#Preview {
    let store = BookStore()
    if let firstBook = store.books.first {
        store.selectBook(firstBook)
    }
    return JourneyView()
        .environment(store)
}
