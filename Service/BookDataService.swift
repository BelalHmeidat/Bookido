//
//  BookDataService.swift
//  Bookido
//
//  Created by Belal Hmeidat on 24/11/2026.
//

import Foundation

/// Represents the root payload structure of `BookData.json`.
public struct BookDataPayload: Codable, Sendable {
    public var currentBookID: UUID?
    public var savedBooks: [Book]

    enum CodingKeys: String, CodingKey {
        case currentBookID
        case savedBooks
    }

    public init(currentBookID: UUID? = nil, savedBooks: [Book] = []) {
        self.currentBookID = currentBookID
        self.savedBooks = savedBooks
    }
}

public typealias BookData = BookDataPayload

/// Service handling JSON disk loading, decoding, and persistence.
public final class BookDataService: Sendable {
    public static let shared = BookDataService()

    private init() {}

    // MARK: - Loading & Decoding

    /// Loads the root BookData payload from a bundled JSON file.
    /// - Parameters:
    ///   - fileName: Resource name (default "BookData").
    ///   - bundle: Bundle containing the resource (default `.main`).
    ///   - includeDetails: When false (default), checkpoints and characters are skipped for fast list loading.
    public func loadBooksData(
        fileName: String = "BookData",
        bundle: Bundle = .main,
        includeDetails: Bool = false
    ) throws -> BookDataPayload {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw BookStoreError.fileNotFound(fileName: "\(fileName).json")
        }

        let data = try Data(contentsOf: url)
        return try decodePayload(from: data, includeDetails: includeDetails)
    }

    /// Loads the lightweight list of books without heavy checkpoints and characters.
    public func loadBooks(
        fileName: String = "BookData",
        bundle: Bundle = .main
    ) throws -> [Book] {
        let bookData = try loadBooksData(fileName: fileName, bundle: bundle, includeDetails: false)
        return bookData.savedBooks
    }

    /// Loads the full checkpoints and characters on demand for a specific book.
    public func loadDetails(
        for bookID: UUID,
        fileName: String = "BookData",
        bundle: Bundle = .main
    ) throws -> (checkpoints: [Checkpoint], characters: [Character]) {
        let fullData = try loadBooksData(fileName: fileName, bundle: bundle, includeDetails: true)
        guard let book = fullData.savedBooks.first(where: { $0.id == bookID }) else {
            throw BookStoreError.bookNotFound(id: bookID)
        }
        return (book.checkpoints, book.characters)
    }

    /// Loads the persisted current book ID from the bundled JSON payload.
    public func loadCurrentBookID(
        fileName: String = "BookData",
        bundle: Bundle = .main
    ) throws -> UUID? {
        let bookData = try loadBooksData(fileName: fileName, bundle: bundle, includeDetails: false)
        return bookData.currentBookID
    }

    /// Loads the current book with full checkpoints and characters.
    public func loadCurrentBook(
        fileName: String = "BookData",
        bundle: Bundle = .main
    ) throws -> Book? {
        guard let currentID = try loadCurrentBookID(fileName: fileName, bundle: bundle) else { return nil }
        let fullData = try loadBooksData(fileName: fileName, bundle: bundle, includeDetails: true)
        return fullData.savedBooks.first(where: { $0.id == currentID })
    }

    /// Convenience decoder directly from raw JSON string (ideal for previews and unit tests).
    public func decode(from jsonString: String, includeDetails: Bool = false) throws -> [Book] {
        guard let data = jsonString.data(using: .utf8) else {
            throw BookStoreError.invalidEncoding
        }
        let payload = try decodePayload(from: data, includeDetails: includeDetails)
        return payload.savedBooks
    }

    /// Decodes either a `BookDataPayload` dictionary or a raw `[Book]` array from Data.
    public func decodePayload(from data: Data, includeDetails: Bool = false) throws -> BookDataPayload {
        let decoder = JSONDecoder()
        decoder.userInfo[.includeCheckpointsAndCharacters] = includeDetails
        do {
            return try decoder.decode(BookDataPayload.self, from: data)
        } catch let payloadError {
            // Fallback: If not formatted as a payload dictionary, attempt decoding as a raw [Book] array
            if let books = try? decoder.decode([Book].self, from: data) {
                return BookDataPayload(currentBookID: nil, savedBooks: books)
            }
            throw payloadError
        }
    }

    // MARK: - Mutating & Persistence

    /// Unlocks a checkpoint for a given book and persists the change.
    public func unlockCheckpoint(for bookID: UUID, checkpointID: UUID) throws {
        var bookData = try loadBooksData(includeDetails: true)
        guard let bookIndex = bookData.savedBooks.firstIndex(where: { $0.id == bookID }) else {
            throw BookStoreError.bookNotFound(id: bookID)
        }

        if let checkpointIndex = bookData.savedBooks[bookIndex].checkpoints.firstIndex(where: { $0.id == checkpointID }) {
            bookData.savedBooks[bookIndex].checkpoints[checkpointIndex].unlockedAt = Date()
            try saveBooksData(bookData)
        } else {
            throw BookStoreError.checkpointNotFound(id: checkpointID)
        }
    }

    public func saveBooksData(_ bookData: BookDataPayload) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(bookData)

        guard let url = Bundle.main.url(forResource: "BookData", withExtension: "json") else {
            throw BookStoreError.fileNotFound(fileName: "BookData.json")
        }

        try data.write(to: url)
    }
}
