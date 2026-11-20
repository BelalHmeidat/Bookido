//
//  BookStore.swift
//  MyApp
//
//  Created by Belal Hmeidat on 17/11/2026.
//

import Foundation
import SwiftUI

/// Observable local data store managing books loaded from bundled JSON.
@Observable
public final class BookStore: @unchecked Sendable {
    public var books: [Book] = []
    public var selectedBookId: UUID?
    public var loadError: String?

    public init(loadImmediately: Bool = true) {
        if loadImmediately {
            loadBooks()
        }
    }

    /// Primary book currently selected in the user interface.
    public var selectedBook: Book? {
        get {
            guard let selectedBookId else { return books.first }
            return books.first { $0.id == selectedBookId }
        }
        set {
            selectedBookId = newValue?.id
        }
    }

    /// Loads the books from `BookData.json` bundled with the application.
    public func loadBooks(fileName: String = "BookData") {
        do {
            let loadedBooks = try Self.loadFromJSON(fileName: fileName)
            self.books = loadedBooks
            if selectedBookId == nil {
                self.selectedBookId = loadedBooks.first?.id
            }
            self.loadError = nil
        } catch {
            self.loadError = "Failed to load \(fileName).json: \(error.localizedDescription)"
            self.books = []
        }
    }

    /// Static helper to decode an array of books from a given bundled JSON resource.
    public static func loadFromJSON(
        fileName: String = "BookData",
        bundle: Bundle = .main
    ) throws -> [Book] {
        guard let fileURL = bundle.url(forResource: fileName, withExtension: "json") else {
            throw BookStoreError.fileNotFound(fileName: "\(fileName).json")
        }

        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        return try decoder.decode([Book].self, from: data)
    }

    /// Convenience decoder directly from raw JSON string (ideal for previews and unit tests).
    public static func decode(from jsonString: String) throws -> [Book] {
        guard let data = jsonString.data(using: .utf8) else {
            throw BookStoreError.invalidEncoding
        }
        let decoder = JSONDecoder()
        return try decoder.decode([Book].self, from: data)
    }

    // MARK: - Reader Interaction Methods

    /// Submits a reader's answer for a specific checkpoint's mystery quiz.
    public func answerMystery(
        bookId: UUID,
        checkpointId: UUID,
        selectedOptionIndex: Int
    ) {
        guard let bookIndex = books.firstIndex(where: { $0.id == bookId }),
              let cpIndex = books[bookIndex].checkpoints.firstIndex(where: { $0.id == checkpointId })
        else { return }

        // Record reader selection
        books[bookIndex].checkpoints[cpIndex].mystery.selectedOptionIndex = selectedOptionIndex

        // If answered correctly, unlock the checkpoint
        if books[bookIndex].checkpoints[cpIndex].mystery.isSolved {
            if books[bookIndex].checkpoints[cpIndex].unlockedAt == nil {
                books[bookIndex].checkpoints[cpIndex].unlockedAt = Date()
            }

            // Unlock any associated characters
            let unlockedCharIds = Set(books[bookIndex].checkpoints[cpIndex].unlockedCharacters)
            for charIndex in books[bookIndex].characters.indices {
                if unlockedCharIds.contains(books[bookIndex].characters[charIndex].id) {
                    books[bookIndex].characters[charIndex].isUnlocked = true
                }
            }
        }
    }
}

// MARK: - Errors

public enum BookStoreError: LocalizedError {
    case fileNotFound(fileName: String)
    case invalidEncoding

    public var errorDescription: String? {
        switch self {
        case .fileNotFound(let fileName):
            return "Could not find resource file: \(fileName)"
        case .invalidEncoding:
            return "Unable to decode UTF-8 string data."
        }
    }
}
