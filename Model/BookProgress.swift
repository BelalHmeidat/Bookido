//
//  BookProgress.swift
//  Bookido
//
//  Created by Belal Hmeidat on 24/11/2026.
//

import Foundation

/// Persistent user reading progress and unlock state for a specific book.
public struct BookProgress: Codable, Hashable, Sendable {
    public var currentChapter: Int
    /// Checkpoint ID -> Unlock Timestamp
    public var unlockedCheckpoints: [UUID: Date]
    /// Checkpoint ID -> Selected option index for mystery
    public var mysteryAnswers: [UUID: Int]

    public init(
        currentChapter: Int = 1,
        unlockedCheckpoints: [UUID: Date] = [:],
        mysteryAnswers: [UUID: Int] = [:]
    ) {
        self.currentChapter = currentChapter
        self.unlockedCheckpoints = unlockedCheckpoints
        self.mysteryAnswers = mysteryAnswers
    }
}
