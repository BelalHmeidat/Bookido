//
//  NodeViewModel.swift
//  Bookido
//
//  Created by Stefania Rosciano on 20/11/2026.
//

import SwiftUI

public struct NodeViewModel: Identifiable {
    public let checkpoint: Checkpoint
    public let unlockedCharacters: [Character]
    public let isNextLocked: Bool
    public let isLastUnlocked: Bool
    public let isExpanded: Bool
    public let bookId: UUID?

    public init(
        checkpoint: Checkpoint,
        unlockedCharacters: [Character] = [],
        isNextLocked: Bool = false,
        isLastUnlocked: Bool = false,
        isExpanded: Bool = false,
        bookId: UUID? = nil
    ) {
        self.checkpoint = checkpoint
        self.unlockedCharacters = unlockedCharacters
        self.isNextLocked = isNextLocked
        self.isLastUnlocked = isLastUnlocked
        self.isExpanded = isExpanded
        self.bookId = bookId
    }

    public var id: UUID {
        checkpoint.id
    }

    public var title: String {
        checkpoint.title
    }

    public var description: String {
        checkpoint.description
    }

    public var textDescription: String {
        checkpoint.description
    }

    public var chapter: Int? {
        checkpoint.chapter
    }

    public var chapterText: String? {
        guard let chapter else { return nil }
        return "Chapter \(chapter)"
    }

    public var icon: String {
        checkpoint.icon
    }

    public var isUnlocked: Bool {
        checkpoint.isUnlocked
    }

    public var mystery: Mystery {
        checkpoint.mystery
    }

    public var location: Location? {
        checkpoint.location
    }

    /// True only if this node is locked and is the immediate next checkpoint waiting to be solved.
    public var canOpenMystery: Bool {
        !isUnlocked && isNextLocked
    }

    // MARK: - Visual presentation properties

    public var width: CGFloat {
        if isExpanded {
            return 64
        } else if isUnlocked {
            return 60
        } else if isNextLocked {
            return 56
        } else {
            return 48
        }
    }

    public var height: CGFloat {
        width
    }

    public var iconSize: CGFloat {
        if isExpanded {
            return 24
        } else if isUnlocked {
            return 22
        } else if isNextLocked {
            return 20
        } else {
            return 18
        }
    }

    public var iconName: String {
        if isUnlocked {
            return checkpoint.icon.isEmpty ? "checkmark" : checkpoint.icon
        } else if isNextLocked {
            return "magnifyingglass"
        } else {
            return "lock.fill"
        }
    }

    public var backgroundColor: Color {
        if isUnlocked {
            return SketchTheme.surfaceCards
        } else if isNextLocked {
            return SketchTheme.primaryAccent
        } else {
            return SketchTheme.surfaceCards.opacity(0.35)
        }
    }

    public var borderColor: Color {
        if isUnlocked {
            return SketchTheme.primaryAccent
        } else if isNextLocked {
            return SketchTheme.accentBlue
        } else {
            return SketchTheme.mystery
        }
    }

    public var iconColor: Color {
        if isUnlocked {
            return SketchTheme.primaryAccent
        } else if isNextLocked {
            return SketchTheme.surfaceCards
        } else {
            return SketchTheme.secondaryAccent.opacity(0.6)
        }
    }
}
