//
//  QuizQuestion.swift
//  MyApp
//
//  Created by Belal Hmeidat on 17/11/2026.
//

import Foundation

/// A multiple choice question within a mystery quiz.
public struct QuizQuestion: Identifiable, Codable, Hashable, Sendable {
    public let id: UUID
    public var prompt: String
    public var options: [String]
    public var correctOptionIndex: Int
    public var explanation: String?
    public var selectedOptionIndex: Int?

    public init(
        id: UUID = UUID(),
        prompt: String,
        options: [String],
        correctOptionIndex: Int,
        explanation: String? = nil,
        selectedOptionIndex: Int? = nil
    ) {
        self.id = id
        self.prompt = prompt
        self.options = options
        self.correctOptionIndex = correctOptionIndex
        self.explanation = explanation
        self.selectedOptionIndex = selectedOptionIndex
    }

    /// True if the user's selected option matches the correct answer.
    public var isAnsweredCorrectly: Bool {
        guard let selectedOptionIndex else { return false }
        return selectedOptionIndex == correctOptionIndex
    }
}
