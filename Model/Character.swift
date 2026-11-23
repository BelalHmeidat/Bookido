//
//  BookCharacter.swift
//  MyApp
//
//  Created by Belal Hmeidat on 17/11/2026.
//

import Foundation

/// Represents a character in the story that can be unlocked and inspected in their own view.
public struct Character: Identifiable, Codable, Hashable, Equatable, Sendable {
    public let id: UUID
    public var name: String
    public var firstAppearance: String
    public var role: String
    public var biography: String
    public var personality: String
    public var relationships: [CharacterRelationship]
    public var quote: String
    public var picture: String

    /// Dynamic unlock state within the app reader experience.

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case firstAppearance
        case role
        case biography
        case personality
        case relationships
        case quote
        case picture
    }

    public init(
        id: UUID = UUID(),
        name: String,
        firstAppearance: String,
        role: String,
        biography: String,
        personality: String = "",
        relationships: [CharacterRelationship] = [],
        quote: String = "",
        picture: String = "",
    ) {
        self.id = id
        self.name = name
        self.firstAppearance = firstAppearance
        self.role = role
        self.biography = biography
        self.personality = personality
        self.relationships = relationships
        self.quote = quote
        self.picture = picture
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.firstAppearance = try container.decode(String.self, forKey: .firstAppearance)
        self.role = try container.decode(String.self, forKey: .role)
        self.biography = try container.decode(String.self, forKey: .biography)
        self.personality = try container.decodeIfPresent(String.self, forKey: .personality) ?? ""
        self.relationships = try container.decodeIfPresent([CharacterRelationship].self, forKey: .relationships) ?? []
        self.quote = try container.decodeIfPresent(String.self, forKey: .quote) ?? ""
        self.picture = try container.decodeIfPresent(String.self, forKey: .picture) ?? ""
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(firstAppearance, forKey: .firstAppearance)
        try container.encode(role, forKey: .role)
        try container.encode(biography, forKey: .biography)
        try container.encode(personality, forKey: .personality)
        try container.encode(relationships, forKey: .relationships)
        try container.encode(quote, forKey: .quote)
        try container.encode(picture, forKey: .picture)
    }

    public static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
