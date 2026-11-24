//
//  BookLocation.swift
//  MyApp
//
//  Created by Belal Hmeidat on 19/11/2026.
//

import Foundation

/// Represents the in-universe physical or symbolic location where a checkpoint takes place.
public struct Location: Identifiable, Codable, Hashable, Equatable, Sendable {
    public let id: UUID
    public var name: String
    public var icon: String
    public var description: String

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case icon
        case description
    }

    public init(
        id: UUID = UUID(),
        name: String,
        icon: String,
        description: String
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.description = description
    }

    public static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
