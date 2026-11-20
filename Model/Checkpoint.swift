//
//  Checkpoint.swift
//  MyApp
//
//  Created by Belal Hmeidat on 17/11/2026.
//

import Foundation

/// Represents a main story event and milestone checkpoint in the book.
public struct Checkpoint: Identifiable, Codable, Hashable, Equatable, Sendable {
    public let id: UUID
    public var title: String
    public var icon: String
    public var description: String

    /// Optional timestamp when unlocked; nil if locked.
    public var unlockedAt: Date?

    /// In-universe location where this event occurs.
    public var location: BookLocation?

    /// The mystery/mini-quiz that unlocks this checkpoint.
    public var mystery: Mystery

    /// UUIDs of characters discovered or unlocked at this checkpoint.
    public var unlockedCharacters: [UUID]

    /// Computed flag indicating if this checkpoint has been unlocked.
    public var isUnlocked: Bool {
        unlockedAt != nil
    }

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case title
        case icon
        case description
        case isUnlocked
        case location
        case mystery
        case unlockedCharacters
    }

    public init(
        id: UUID = UUID(),
        title: String,
        icon: String = "bookmark.fill",
        description: String,
        unlockedAt: Date? = nil,
        location: BookLocation? = nil,
        mystery: Mystery,
        unlockedCharacters: [UUID] = []
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.description = description
        self.unlockedAt = unlockedAt
        self.location = location
        self.mystery = mystery
        self.unlockedCharacters = unlockedCharacters
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.icon = try container.decodeIfPresent(String.self, forKey: .icon) ?? "bookmark.fill"
        self.description = try container.decode(String.self, forKey: .description)
        self.location = try container.decodeIfPresent(BookLocation.self, forKey: .location)
        self.mystery = try container.decode(Mystery.self, forKey: .mystery)
        self.unlockedCharacters = try container.decodeIfPresent([UUID].self, forKey: .unlockedCharacters) ?? []

        // In JSON, `isUnlocked` can be an ISO8601 date string or null.
        if let dateString = try container.decodeIfPresent(String.self, forKey: .isUnlocked) {
            let formatter = ISO8601DateFormatter()
            self.unlockedAt = formatter.date(from: dateString)
        } else {
            self.unlockedAt = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(icon, forKey: .icon)
        try container.encode(description, forKey: .description)
        try container.encode(location, forKey: .location)
        try container.encode(mystery, forKey: .mystery)
        try container.encode(unlockedCharacters, forKey: .unlockedCharacters)

        if let unlockedAt {
            let formatter = ISO8601DateFormatter()
            try container.encode(formatter.string(from: unlockedAt), forKey: .isUnlocked)
        } else {
            try container.encodeNil(forKey: .isUnlocked)
        }
    }

    public static func == (lhs: Checkpoint, rhs: Checkpoint) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
