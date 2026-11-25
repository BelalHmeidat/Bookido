//
//  Location.swift
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
        icon: String = "map.fill",
        description: String = ""
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.description = description
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.icon = try container.decodeIfPresent(String.self, forKey: .icon) ?? "map.fill"
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(icon, forKey: .icon)
        try container.encode(description, forKey: .description)
    }

    public static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
