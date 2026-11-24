//
//  BookStore.swift
//  MyApp
//
//  Created by Belal Hmeidat on 17/11/2026.
//

import Foundation
import SwiftUI

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

/// Observable local data store managing books loaded from bundled JSON.
@Observable
public final class BookStore: @unchecked Sendable {
    public static let selectedBookStorageKey = "selectedBookId"
    public static let onboardingCompletedStorageKey = "hasCompletedOnboarding"

    public var books: [Book] = []
    public var selectedBookId: UUID?
    public var loadError: String?

    public init(loadImmediately: Bool = true) {
        if loadImmediately {
            _ = try? loadBooks()
        }
    }

    /// Alias for selectedBookId matching BookData.json's `currentBookID` key.
    public var currentBookID: UUID? {
        get { selectedBookId }
        set { selectedBookId = newValue }
    }

    /// Primary book currently selected in the user interface.
    public var selectedBook: Book? {
        get {
            guard let selectedBookId else { return nil }
            return books.first { $0.id == selectedBookId }
        }
        set {
            selectedBookId = newValue?.id
            if let id = newValue?.id {
                UserDefaults.standard.set(id.uuidString, forKey: Self.selectedBookStorageKey)
            } else {
                UserDefaults.standard.removeObject(forKey: Self.selectedBookStorageKey)
            }
        }
    }

    /// Selects a book and persists the choice to UserDefaults.
    public func selectBook(_ book: Book) {
        self.selectedBook = book
    }

    /// Selects a book by its UUID and persists the choice to UserDefaults.
    public func selectBook(id: UUID) {
        self.selectedBookId = id
        UserDefaults.standard.set(id.uuidString, forKey: Self.selectedBookStorageKey)
    }

    /// Clears the selected book and removes the persisted key.
    public func clearSelection() {
        self.selectedBookId = nil
        UserDefaults.standard.removeObject(forKey: Self.selectedBookStorageKey)
    }

    /// Loads the books and restores the user's selected book from persistence if available.
    @discardableResult
    public func loadBooks(fileName: String = "BookData", bundle: Bundle = .main) throws -> [Book] {
        do {
            let (loadedBooks, _) = try Self.loadPayloadFromJSON(fileName: fileName, bundle: bundle)
            self.books = loadedBooks
            // Restore user selection from persistence if valid
            if let savedIDString = UserDefaults.standard.string(forKey: Self.selectedBookStorageKey),
               let savedUUID = UUID(uuidString: savedIDString),
               loadedBooks.contains(where: { $0.id == savedUUID }) {
                self.selectedBookId = savedUUID
            } else {
                self.selectedBookId = nil
            }
            self.loadError = nil
            return loadedBooks
        } catch {
            self.loadError = error.localizedDescription
            self.books = []
            throw error
        }
    }

    /// Static helper to decode an array of books from a given bundled JSON resource.
    /// Supports both root payload dictionaries (`{"currentBookID": ..., "savedBooks": [...]}`) and raw arrays (`[Book]`).
    public static func loadFromJSON(
        fileName: String = "BookData",
        bundle: Bundle = .main
    ) throws -> [Book] {
        let (books, _) = try loadPayloadFromJSON(fileName: fileName, bundle: bundle)
        return books
    }

    /// Loads the books and the currently selected book ID from a bundled JSON resource.
    public static func loadPayloadFromJSON(
        fileName: String = "BookData",
        bundle: Bundle = .main
    ) throws -> (books: [Book], currentBookID: UUID?) {
        guard let fileURL = bundle.url(forResource: fileName, withExtension: "json") else {
            throw BookStoreError.fileNotFound(fileName: "\(fileName).json")
        }

        let data = try Data(contentsOf: fileURL)
        return try decodePayload(from: data)
    }

    /// Convenience decoder directly from raw JSON string (ideal for previews and unit tests).
    public static func decode(from jsonString: String) throws -> [Book] {
        guard let data = jsonString.data(using: .utf8) else {
            throw BookStoreError.invalidEncoding
        }
        let (books, _) = try decodePayload(from: data)
        return books
    }

    /// Decodes either a `BookDataPayload` dictionary or a raw `[Book]` array from Data.
    public static func decodePayload(from data: Data) throws -> (books: [Book], currentBookID: UUID?) {
        let decoder = JSONDecoder()
        do {
            let payload = try decoder.decode(BookDataPayload.self, from: data)
            return (payload.savedBooks, payload.currentBookID)
        } catch let payloadError {
            // Fallback: If not formatted as a payload dictionary, attempt decoding as a raw [Book] array
            if let books = try? decoder.decode([Book].self, from: data) {
                return (books, nil)
            }
            throw payloadError
        }
    }

    // MARK: - Reader Interaction Methods

    /// Submits a reader's answer for a specific checkpoint's mystery quiz.
    public func answerMystery(
        bookId: UUID,
        checkpointId: UUID,
        selectedOptionIndex: Int
    ) throws {
        guard let bookIndex = books.firstIndex(where: { $0.id == bookId }) else {
            throw BookStoreError.bookNotFound(id: bookId)
        }
        guard let cpIndex = books[bookIndex].checkpoints.firstIndex(where: { $0.id == checkpointId }) else {
            throw BookStoreError.checkpointNotFound(id: checkpointId)
        }

        // Record reader selection
        books[bookIndex].checkpoints[cpIndex].mystery.selectedOptionIndex = selectedOptionIndex

        // If answered correctly, unlock the checkpoint
        if books[bookIndex].checkpoints[cpIndex].mystery.isSolved {
            if books[bookIndex].checkpoints[cpIndex].unlockedAt == nil {
                books[bookIndex].checkpoints[cpIndex].unlockedAt = Date()
            }
            // Note: Associated characters and locations are dynamically unlocked via checkpoints.
        }
    }
}

// MARK: - Errors

public enum BookStoreError: LocalizedError {
    case fileNotFound(fileName: String)
    case invalidEncoding
    case bookNotFound(id: UUID)
    case checkpointNotFound(id: UUID)

    public var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "File Not Found"
        case .invalidEncoding:
            return "Encoding Error"
        case .bookNotFound:
            return "Book Not Found"
        case .checkpointNotFound:
            return "Checkpoint Not Found"
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .fileNotFound(let fileName):
            return "Could not find resource file: \(fileName) in the app bundle."
        case .invalidEncoding:
            return "Unable to decode UTF-8 string data."
        case .bookNotFound(let id):
            return "No book matching ID \(id) was found in your library."
        case .checkpointNotFound(let id):
            return "No checkpoint matching ID \(id) was found for this book."
        }
    }
}
