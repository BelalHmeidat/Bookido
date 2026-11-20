//
//  BookLocation.swift
//  MyApp
//
//  Created by Belal Hmeidat on 19/11/2026.
//

import Foundation

/// Represents the in-universe physical or symbolic location where a checkpoint takes place.
public struct BookLocation: Identifiable, Codable, Hashable, Equatable, Sendable {
    public let id: UUID
    public var name: String
    public var icon: String

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case icon
    }

    public init(
        id: UUID = UUID(),
        name: String,
        icon: String
    ) {
        self.id = id
        self.name = name
        self.icon = icon
    }

    public static func == (lhs: BookLocation, rhs: BookLocation) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
