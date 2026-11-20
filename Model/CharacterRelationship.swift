//
//  CharacterRelationship.swift
//  MyApp
//
//  Created by Belal Hmeidat on 19/11/2026.
//

import Foundation

/// Represents a narrative relationship connecting two characters.
public struct CharacterRelationship: Identifiable, Codable, Hashable, Equatable, Sendable {
    /// The target character's UUID.
    public let id: UUID
    /// Description of the relationship.
    public var relation: String

    enum CodingKeys: String, CodingKey {
        case id
        case relation
    }

    public init(id: UUID, relation: String) {
        self.id = id
        self.relation = relation
    }

    public static func == (lhs: CharacterRelationship, rhs: CharacterRelationship) -> Bool {
        lhs.id == rhs.id && lhs.relation == rhs.relation
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(relation)
    }
}
