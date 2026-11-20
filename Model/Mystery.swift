//
//  Mystery.swift
//  MyApp
//
//  Created by Belal Hmeidat on 17/11/2026.
//

import Foundation

/// Represents a mini-quiz challenge presented to verify reader progress and unlock a checkpoint.
public struct Mystery: Identifiable, Codable, Hashable, Equatable, Sendable {
    public let id: UUID
    public var question: String
    public var options: [String]
    public var answerIndex: Int
    public var clues: [String]

    /// Reader's selected option index (transient state for the quiz).
    public var selectedOptionIndex: Int?

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case question
        case options
        case answerIndex
        case clues
    }

    public init(
        id: UUID = UUID(),
        question: String,
        options: [String],
        answerIndex: Int,
        clues: [String] = [],
        selectedOptionIndex: Int? = nil
    ) {
        self.id = id
        self.question = question
        self.options = options
        self.answerIndex = answerIndex
        self.clues = clues
        self.selectedOptionIndex = selectedOptionIndex
    }

    /// True if the user's selected option matches the answer index.
    public var isSolved: Bool {
        guard let selectedOptionIndex else { return false }
        return selectedOptionIndex == answerIndex
    }

    public static func == (lhs: Mystery, rhs: Mystery) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
