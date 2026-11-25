//
//  NodeView.swift
//  Bookido
//
//  Created by Stefania Rosciano on 20/11/2026.
//

import SwiftUI

/// Start node view consisting of a small circle with a flag icon that says "Start" next to it.
struct StartNodeView: View {
    var size: CGFloat = 28

    var body: some View {
        HStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(SketchTheme.surfaceCards)
                    .frame(width: size, height: size)
                    .overlay(
                        Circle()
                            .stroke(SketchTheme.primaryAccent, lineWidth: 2)
                    )

                Image(systemName: "flag.fill")
                    .font(.system(size: size * 0.4, weight: .semibold, design: .rounded))
                    .foregroundStyle(SketchTheme.primaryAccent)
            }

            Text("Start")
                .font(.system(.callout, design: .rounded, weight: .semibold))
                .foregroundStyle(SketchTheme.primaryAccent)
        }
    }
}

/// Unified NodeView that dynamically returns the expanded unlocked card when expanded,
/// or the shrunk circle with icon and title underneath when shrunk or locked.
struct NodeView: View {
    let viewModel: NodeViewModel
    var onToggleExpand: (() -> Void)? = nil
    var onUnlocked: (() -> Void)? = nil

    @Environment(BookStore.self) private var bookStore: BookStore
    @State private var showMysteryPopup: Bool = false

    var body: some View {
        if viewModel.isUnlocked {
            if viewModel.isExpanded {
                unlockedExpandedCard
            } else {
                shrunkUnlockedView
            }
        } else {
            lockedView
        }
    }

    // MARK: - Unlocked (Expanded Card) View

    private var unlockedExpandedCard: some View {
        Button {
            onToggleExpand?()
        } label: {
            VStack(spacing: 12) {
                Text(viewModel.location?.name ?? "Checkpoint")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(SketchTheme.accentBlue)

                // Title
                Text(viewModel.title)
                    .font(.system(.title3, design: .serif, weight: .bold))
                    .foregroundStyle(SketchTheme.primaryAccent)
                    .multilineTextAlignment(.center)

                // Description
                Text(viewModel.description)
                    .font(.body)
                    .foregroundStyle(SketchTheme.secondaryAccent)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                // Unlocked characters discovered at this checkpoint
                if !viewModel.unlockedCharacters.isEmpty {
                    HStack(spacing: 8) {
                        ForEach(viewModel.unlockedCharacters, id: \.self) { _ in
                            Text("★")
                                .font(.system(.footnote, design: .serif, weight: .bold))
                                .foregroundStyle(SketchTheme.surfaceCards)
                                .frame(width: 28, height: 28)
                                .background(SketchTheme.accentBlue, in: Circle())
                        }
                    }
                    .padding(.top, 4)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 48)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity)
            .background(
                SketchTheme.surfaceCards,
                in: RoundedRectangle(cornerRadius: 20)
            )
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            .overlay(alignment: .top) {
                // Checkpoint icon badge on top of the card
                ZStack {
                    Circle()
                        .fill(viewModel.backgroundColor)
                        .frame(width: 64, height: 64)
                        .overlay(
                            Circle()
                                .stroke(viewModel.borderColor, lineWidth: 3)
                        )

                    Image(systemName: viewModel.iconName)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundStyle(viewModel.iconColor)

                    // Only the last unlocked checkpoint has the dashed outline
                    if viewModel.isLastUnlocked {
                        Circle()
                            .strokeBorder(
                                SketchTheme.accentBlue,
                                style: StrokeStyle(lineWidth: 2.5, dash: [5, 5])
                            )
                            .frame(width: 80, height: 80)
                    }
                }
                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                .offset(y: -40)
            }
            .padding(.horizontal, 24)
            .padding(.top, 40)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Unlocked (Shrunk Circle + Title) View

    private var shrunkUnlockedView: some View {
        Button {
            onToggleExpand?()
        } label: {
            VStack(spacing: 8) {
                ZStack {
                    // Only the last unlocked checkpoint has the dashed outline
                    if viewModel.isLastUnlocked {
                        Circle()
                            .strokeBorder(
                                SketchTheme.accentBlue,
                                style: StrokeStyle(lineWidth: 2.5, dash: [5, 5])
                            )
                            .frame(width: viewModel.width + 16, height: viewModel.height + 16)
                    }

                    Circle()
                        .fill(viewModel.backgroundColor)
                        .frame(width: viewModel.width, height: viewModel.height)
                        .overlay(
                            Circle()
                                .stroke(viewModel.borderColor, lineWidth: 2.5)
                        )

                    Image(systemName: viewModel.iconName)
                        .font(.system(size: viewModel.iconSize, weight: .semibold, design: .rounded))
                        .foregroundStyle(viewModel.iconColor)
                }
                .frame(width: 80, height: 80)
                .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 3)

                Text(viewModel.title)
                    .font(.system(.footnote, design: .rounded, weight: .semibold))
                    .foregroundStyle(SketchTheme.primaryAccent)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(maxWidth: 110)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Locked View

    private var lockedView: some View {
        Button {
            if viewModel.canOpenMystery {
                showMysteryPopup = true
            }
        } label: {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(viewModel.backgroundColor)
                        .frame(width: viewModel.width, height: viewModel.height)
                        .overlay(
                            Circle()
                                .stroke(viewModel.borderColor, lineWidth: 2)
                        )

                    Image(systemName: viewModel.iconName)
                        .font(.system(size: viewModel.iconSize, weight: .semibold, design: .rounded))
                        .foregroundStyle(viewModel.iconColor)
                }
                .frame(width: 72, height: 72)
                .shadow(color: .black.opacity(viewModel.isNextLocked ? 0.18 : 0.06), radius: 6, x: 0, y: 3)

                Text(viewModel.title)
                    .font(.system(.caption, design: .rounded, weight: .medium))
                    .foregroundStyle(viewModel.isNextLocked ? SketchTheme.primaryAccent : SketchTheme.secondaryAccent.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(maxWidth: 100)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
        .disabled(!viewModel.canOpenMystery)
        .sheet(isPresented: $showMysteryPopup) {
            MysteryQuizSheet(viewModel: viewModel) {
                showMysteryPopup = false
                onUnlocked?()
            }
        }
    }
}
