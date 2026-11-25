//
//  BookStore.swift
//  Bookido
//
//  Created by Belal Hmeidat on 17/11/2026.
//

import Foundation
import SwiftUI

/// Observable local UI store managing book state and reader interactions.
@Observable
public final class BookStore: @unchecked Sendable {
    public static let selectedBookStorageKey = "selectedBookId"
    public static let shelfBooksStorageKey = "shelfBookIds"

    public var books: [Book] = []
    public var selectedBookId: UUID?
    public var shelfBookIds: [UUID] = []
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
            if let newBook = newValue {
                selectBook(id: newBook.id)
            } else {
                clearSelection()
            }
        }
    }

    /// All books currently added to the user's shelf, preserving addition order.
    public var shelfBooks: [Book] {
        shelfBookIds.compactMap { id in books.first { $0.id == id } }
    }

    // MARK: - Book Selection

    /// Adds a book to the user's shelf if not already present and persists the shelf.
    public func addToShelf(_ book: Book) {
        addToShelf(id: book.id)
    }

    /// Adds a book by its UUID to the user's shelf if not already present and persists the shelf.
    public func addToShelf(id: UUID) {
        if !shelfBookIds.contains(id) {
            shelfBookIds.append(id)
            UserDefaults.standard.set(shelfBookIds.map(\.uuidString), forKey: Self.shelfBooksStorageKey)
        }
        hydrateDetailsIfNeeded(for: id)
    }

    /// Selects a book and persists the choice to UserDefaults.
    public func selectBook(_ book: Book) {
        selectBook(id: book.id)
    }

    /// Selects a book by its UUID, adds it to the shelf if needed, persists the choice, and hydrates its checkpoints on demand.
    public func selectBook(id: UUID) {
        self.selectedBookId = id
        UserDefaults.standard.set(id.uuidString, forKey: Self.selectedBookStorageKey)
        addToShelf(id: id)
    }

    /// Clears the selected book and removes the persisted key.
    public func clearSelection() {
        self.selectedBookId = nil
        UserDefaults.standard.removeObject(forKey: Self.selectedBookStorageKey)
    }

    /// Hydrates checkpoints and characters on demand for a specific book if not yet loaded.
    public func hydrateDetailsIfNeeded(for bookId: UUID) {
        if books.isEmpty {
            _ = try? loadBooks()
        }
        guard let index = books.firstIndex(where: { $0.id == bookId }) else { return }
        guard books[index].checkpoints.isEmpty else { return }
        do {
            let details = try BookDataService.shared.loadDetails(for: bookId)
            books[index].checkpoints = details.checkpoints
            books[index].characters = details.characters
        } catch {
            print("Failed to load details for book \(bookId): \(error)")
        }
    }

    // MARK: - Library Loading

    /// Loads the lightweight book list and restores the user's selected book with details.
    @discardableResult
    public func loadBooks() throws -> [Book] {
        do {
            let loadedBooks = try BookDataService.shared.loadBooks()
            self.books = loadedBooks

            // Restore user shelf from persistence
            let validBookIDs = Set(loadedBooks.map(\.id))
            let savedShelfStrings = UserDefaults.standard.stringArray(forKey: Self.shelfBooksStorageKey) ?? []
            var restoredShelfIDs: [UUID] = []
            for uuidString in savedShelfStrings {
                if let uuid = UUID(uuidString: uuidString),
                   validBookIDs.contains(uuid),
                   !restoredShelfIDs.contains(uuid) {
                    restoredShelfIDs.append(uuid)
                }
            }
            self.shelfBookIds = restoredShelfIDs

            // Restore user selection from persistence if valid
            if let savedIDString = UserDefaults.standard.string(forKey: Self.selectedBookStorageKey),
               let savedUUID = UUID(uuidString: savedIDString),
               validBookIDs.contains(savedUUID) {
                self.selectedBookId = savedUUID
                addToShelf(id: savedUUID)
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

        // Record reader selection in-memory
        books[bookIndex].checkpoints[cpIndex].mystery.selectedOptionIndex = selectedOptionIndex

        let isCorrect = books[bookIndex].checkpoints[cpIndex].mystery.isSolved
        if isCorrect && books[bookIndex].checkpoints[cpIndex].unlockedAt == nil {
            books[bookIndex].checkpoints[cpIndex].unlockedAt = Date()
        }

        // Persist to user progress (Option B)
        BookDataService.shared.recordMysteryAnswer(
            bookID: bookId,
            checkpointID: checkpointId,
            selectedOptionIndex: selectedOptionIndex,
            isCorrect: isCorrect
        )
    }

    /// Updates the reader's current chapter and persists the progress.
    public func updateChapter(bookId: UUID, chapter: Int) {
        guard let bookIndex = books.firstIndex(where: { $0.id == bookId }) else { return }
        books[bookIndex].currentChapter = chapter
        BookDataService.shared.updateChapter(bookID: bookId, chapter: chapter)
    }

    // MARK: - Character Lookup

    /// Returns the character matching the given UUID in the specified book (or the selected book if nil).
    public func getCharacter(id: UUID, in bookId: UUID? = nil) -> Character? {
        let targetBook = bookId.flatMap { targetId in books.first { $0.id == targetId } } ?? selectedBook
        if let character = targetBook?.characters.first(where: { $0.id == id }) {
            return character
        }
        return books.lazy.flatMap(\.characters).first { $0.id == id }
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
