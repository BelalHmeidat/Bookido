//
//  Book.swift
//  MyApp
//
//  Created by Belal Hmeidat on 17/11/2026.
//

import Foundation

/// Represents a book with checkpoints, mysteries, and characters to unlock as the reader progresses.
public struct Book: Identifiable, Codable, Hashable, Sendable {
    public let id: UUID
    public var isbn: String
    public var title: String
    public var author: String
    public var year: Int?
    public var genre: String
    public var numberOfChapters: Int
    public var synopsis: String
    public var currentChapter: Int
    public var coverImage: String
    public var checkpoints: [Checkpoint]
    public var characters: [Character]

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case isbn
        case title
        case name
        case author
        case year
        case genre
        case numberOfChapters
        case synopsis
        case description
        case currentChapter
        case coverImage
        case checkpoints
        case characters
    }

    public init(
        id: UUID = UUID(),
        isbn: String,
        title: String,
        author: String,
        year: Int? = nil,
        genre: String,
        numberOfChapters: Int,
        synopsis: String,
        currentChapter: Int = 1,
        coverImage: String = "",
        checkpoints: [Checkpoint]? = [],
        characters: [Character]? = []
    ) {
        self.id = id
        self.isbn = isbn
        self.title = title
        self.author = author
        self.year = year
        self.genre = genre
        self.numberOfChapters = numberOfChapters
        self.synopsis = synopsis
        self.currentChapter = currentChapter
        self.coverImage = coverImage
        self.checkpoints = checkpoints ?? []
        self.characters = characters ?? []
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.isbn = try container.decode(String.self, forKey: .isbn)

        // Supports both "title" and "name" keys from BookData.json
        if let decodedTitle = try container.decodeIfPresent(String.self, forKey: .title) {
            self.title = decodedTitle
        } else if let decodedName = try container.decodeIfPresent(String.self, forKey: .name) {
            self.title = decodedName
        } else {
            self.title = ""
        }

        self.author = try container.decode(String.self, forKey: .author)
        self.year = try container.decodeIfPresent(Int.self, forKey: .year)
        self.genre = try container.decode(String.self, forKey: .genre)
        self.numberOfChapters = try container.decode(Int.self, forKey: .numberOfChapters)

        // Supports both "synopsis" and "description" keys from BookData.json
        if let decodedSynopsis = try container.decodeIfPresent(String.self, forKey: .synopsis) {
            self.synopsis = decodedSynopsis
        } else if let decodedDesc = try container.decodeIfPresent(String.self, forKey: .description) {
            self.synopsis = decodedDesc
        } else {
            self.synopsis = ""
        }

        self.currentChapter = try container.decode(Int.self, forKey: .currentChapter)
        self.coverImage = try container.decodeIfPresent(String.self, forKey: .coverImage) ?? ""

        let shouldLoadDetails = (decoder.userInfo[.includeCheckpointsAndCharacters] as? Bool) ?? false
        if shouldLoadDetails {
            self.checkpoints = try container.decodeIfPresent([Checkpoint].self, forKey: .checkpoints) ?? []
            self.characters = try container.decodeIfPresent([Character].self, forKey: .characters) ?? []
        } else {
            self.checkpoints = []
            self.characters = []
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(isbn, forKey: .isbn)
        try container.encode(title, forKey: .title)
        try container.encode(author, forKey: .author)
        try container.encode(year, forKey: .year)
        try container.encode(genre, forKey: .genre)
        try container.encode(numberOfChapters, forKey: .numberOfChapters)
        try container.encode(synopsis, forKey: .synopsis)
        try container.encode(currentChapter, forKey: .currentChapter)
        try container.encode(coverImage, forKey: .coverImage)
        try container.encode(checkpoints, forKey: .checkpoints)
        try container.encode(characters, forKey: .characters)
    }

    /// Checkpoints that have been successfully unlocked.
    public var unlockedCheckpoints: [Checkpoint] {
        checkpoints.filter { $0.isUnlocked }
    }

    /// The next locked checkpoint waiting to be reached and solved.
    public var nextLockedCheckpoint: Checkpoint? {
        checkpoints.first { !$0.isUnlocked }
    }

    /// A set of all character IDs unlocked across all currently unlocked checkpoints
    public var unlockedCharacterIDs: Set<UUID> {
       Set(checkpoints.filter { $0.isUnlocked }.flatMap { $0.unlockedCharacters })
    }

    /// Characters that have been discovered/unlocked.
    public var unlockedCharacters: [Character] {
       characters.filter { unlockedCharacterIDs.contains($0.id) }
    }

    /// Check if a specific character is unlocked
    public func isCharacterUnlocked(_ character: Character) -> Bool {
       unlockedCharacterIDs.contains(character.id)
    }
    
    /// A set of all location IDs unlocked across all currently unlocked checkpoints
    public var unlockedLocationIDs: Set<UUID> {
        Set(checkpoints.filter { $0.isUnlocked }.compactMap { $0.location?.id })
    }

    /// All the locations unlocked so far
    public var unlockedLocations: [Location] {
        checkpoints.filter { $0.isUnlocked }.compactMap { $0.location }
    }

    /// Checkpoint unlock progress ratio from 0 - 100
    public var checkpointProgressPercentage: Int {
        guard !checkpoints.isEmpty else { return 0 }
        return Int(Double(unlockedCheckpoints.count) / Double(checkpoints.count) * 100)
    }
}

// MARK: - Decoding Configuration

extension CodingUserInfoKey {
    /// Flag to control whether checkpoints and characters are decoded. Defaults to false (skips heavy details for lists).
    public static let includeCheckpointsAndCharacters = CodingUserInfoKey(rawValue: "includeCheckpointsAndCharacters")!
}
