//
//  NodeView.swift
//  Bookido
//
//  Created by Stefania Rosciano on 20/11/2026.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// Renders a checkpoint's custom image asset (resolving `_S`/`_M`/`_L` variants when available)
/// or falls back to an SF Symbol when no matching asset image exists.
struct CheckpointIconView: View {
    enum Variant {
        case small
        case medium
        case large

        var suffix: String {
            switch self {
            case .small: "_S"
            case .medium: "_M"
            case .large: "_L"
            }
        }
    }

    let name: String
    var preferredVariant: Variant = .small
    var assetSize: CGFloat
    var symbolSize: CGFloat
    var symbolColor: Color
    var fallbackSymbol: String = "checkmark"

    private var resolvedAssetName: String? {
        guard !name.isEmpty else { return nil }
        if name.hasSuffix("_S") || name.hasSuffix("_M") || name.hasSuffix("_L") {
            let base = String(name.dropLast(2))
            let preferred = base + preferredVariant.suffix
            if Self.assetExists(named: preferred) {
                return preferred
            }
        }
        return Self.assetExists(named: name) ? name : nil
    }

    var body: some View {
        if let assetName = resolvedAssetName {
            Image(assetName)
                .resizable()
                .scaledToFit()
                .frame(width: assetSize, height: assetSize)
        } else {
            Image(systemName: name.isEmpty ? fallbackSymbol : name)
                .font(.system(size: symbolSize, weight: .semibold, design: .rounded))
                .foregroundStyle(symbolColor)
        }
    }

    private static func assetExists(named name: String) -> Bool {
        #if canImport(UIKit)
        UIImage(named: name) != nil
        #elseif canImport(AppKit)
        NSImage(named: name) != nil
        #else
        false
        #endif
    }
}

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

/// End node view consisting of a small circle with a checkmark icon that says "Finished" next to it.
struct EndNodeView: View {
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

                Image(systemName: "checkmark")
                    .font(.system(size: size * 0.4, weight: .bold, design: .rounded))
                    .foregroundStyle(SketchTheme.primaryAccent)
            }

            Text("Finished")
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
    var onSelectLocation: ((Location) -> Void)? = nil
    var onSelectCharacter: ((Character) -> Void)? = nil

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
                    ForEach(viewModel.unlockedCharacters) { character in
                        Button {
                            onSelectCharacter?(character)
                        } label: {
                            Text(character.name.prefix(1))
                                .font(.system(.footnote, design: .serif, weight: .bold))
                                .foregroundStyle(SketchTheme.surfaceCards)
                                .frame(width: 28, height: 28)
                                .background(SketchTheme.accentBlue, in: Circle())
                        }
                        .buttonStyle(.plain)
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
        .contentShape(RoundedRectangle(cornerRadius: 20))
        .onTapGesture {
            onToggleExpand?()
        }
        .overlay(alignment: .topLeading) {
            // Checkpoint chapter badge in the top-left corner of the card
            if let chapterText = viewModel.chapterText {
                Text(chapterText)
                    .font(.system(.caption, design: .rounded, weight: .semibold))
                    .foregroundStyle(SketchTheme.accentBlue)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        SketchTheme.accentBlue.opacity(0.12),
                        in: Capsule()
                    )
                    .padding(.top, 14)
                    .padding(.leading, 14)
                    .allowsHitTesting(false)
            }
        }
        .overlay(alignment: .topTrailing) {
            // Smaller location map icon in the top-right corner of the expanded card
            if let location = viewModel.location, !location.icon.isEmpty {
                Button {
                    onSelectLocation?(location)
                } label: {
                    CheckpointIconView(
                        name: location.icon,
                        assetSize: 48,
                        symbolSize: 20,
                        symbolColor: SketchTheme.accentBlue,
                        fallbackSymbol: "map.fill"
                    )
                }
                .buttonStyle(.plain)
                .padding(.top, 10)
                .padding(.trailing, 14)
            }
        }
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

                CheckpointIconView(
                    name: viewModel.iconName,
                    assetSize: viewModel.width * 0.8,
                    symbolSize: 24,
                    symbolColor: viewModel.iconColor
                )

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
            .allowsHitTesting(false)
        }
        .padding(.horizontal, 24)
        .padding(.top, 40)
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

                    CheckpointIconView(
                        name: viewModel.iconName,
                        assetSize: viewModel.width * 0.8,
                        symbolSize: viewModel.iconSize,
                        symbolColor: viewModel.iconColor
                    )
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

                    CheckpointIconView(
                        name: viewModel.iconName,
                        assetSize: viewModel.width * 0.8,
                        symbolSize: viewModel.iconSize,
                        symbolColor: viewModel.iconColor
                    )
                }
                .frame(width: 72, height: 72)
                .shadow(color: .black.opacity(viewModel.isNextLocked ? 0.18 : 0.06), radius: 6, x: 0, y: 3)

                Text(viewModel.title)
                    .font(.system(.caption, design: .rounded, weight: .medium))
                    .foregroundStyle(viewModel.isNextLocked ? SketchTheme.primaryAccent : SketchTheme.secondaryAccent.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(maxWidth: 100)

                if let chapter = viewModel.chapter {
                    Text("Unlocks in Ch. \(chapter)")
                        .font(.system(.caption2, design: .rounded, weight: .semibold))
                        .foregroundStyle(viewModel.isNextLocked ? SketchTheme.accentBlue : SketchTheme.secondaryAccent.opacity(0.7))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            (viewModel.isNextLocked ? SketchTheme.accentBlue : SketchTheme.secondaryAccent).opacity(0.12),
                            in: Capsule()
                        )
                }
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
