//
//  BookDataService.swift
//  Bookido
//
//  Created by Belal Hmeidat on 24/11/2026.
//

import Foundation


public typealias BookData = [Book]

/// Service handling JSON catalog loading and local user progress overlay.
public final class BookDataService: Sendable {
    public static let shared = BookDataService()

    private init() {}

    // MARK: - User Progress Persistence (Option B)

    private func progressKey(for bookID: UUID) -> String {
        "book_progress_\(bookID.uuidString)"
    }

    /// Loads the stored user progress for a book from UserDefaults.
    public func loadProgress(for bookID: UUID) -> BookProgress {
        guard let data = UserDefaults.standard.data(forKey: progressKey(for: bookID)),
              let progress = try? JSONDecoder().decode(BookProgress.self, from: data) else {
            return BookProgress()
        }
        return progress
    }

    /// Saves user progress for a specific book to UserDefaults.
    public func saveProgress(_ progress: BookProgress, for bookID: UUID) {
        if let data = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(data, forKey: progressKey(for: bookID))
        }
    }

    /// Records an answer to a checkpoint's mystery and unlocks the checkpoint if solved.
    public func recordMysteryAnswer(
        bookID: UUID,
        checkpointID: UUID,
        selectedOptionIndex: Int,
        isCorrect: Bool
    ) {
        var progress = loadProgress(for: bookID)
        progress.mysteryAnswers[checkpointID] = selectedOptionIndex
        if isCorrect {
            if progress.unlockedCheckpoints[checkpointID] == nil {
                progress.unlockedCheckpoints[checkpointID] = Date()
            }
        }
        saveProgress(progress, for: bookID)
    }

    /// Updates the user's current reading chapter for a book.
    public func updateChapter(bookID: UUID, chapter: Int) {
        var progress = loadProgress(for: bookID)
        progress.currentChapter = chapter
        saveProgress(progress, for: bookID)
    }

    // MARK: - Catalog Loading

    /// Loads the list of books from the JSON array and overlays saved user progress.
    public func loadBooks(
        fileName: String = "BookData",
        bundle: Bundle = .main
    ) throws -> [Book] {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw BookStoreError.fileNotFound(fileName: "\(fileName).json")
        }

        let data = try Data(contentsOf: url)
        var books = try decode(from: data)

        // Overlay saved chapter and checkpoint progress onto each book
        for i in books.indices {
            let progress = loadProgress(for: books[i].id)
            books[i].currentChapter = progress.currentChapter
            for cpIndex in books[i].checkpoints.indices {
                let cpID = books[i].checkpoints[cpIndex].id
                if let unlockDate = progress.unlockedCheckpoints[cpID] {
                    books[i].checkpoints[cpIndex].unlockedAt = unlockDate
                }
                if let answerIndex = progress.mysteryAnswers[cpID] {
                    books[i].checkpoints[cpIndex].mystery.selectedOptionIndex = answerIndex
                }
            }
        }
        return books
    }

    // MARK: - Single Book Loading (Details on demand)

    /// Loads checkpoints and characters only for a single specified book, overlaying saved user progress.
    public func loadDetails(
        for bookID: UUID,
        fileName: String = "BookData",
        bundle: Bundle = .main
    ) throws -> (checkpoints: [Checkpoint], characters: [Character]) {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw BookStoreError.fileNotFound(fileName: "\(fileName).json")
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()

        // Decodes the top-level array of book details (with fallback for legacy dictionary)
        let detailsList: [SingleBookDetails]
        if let array = try? decoder.decode([SingleBookDetails].self, from: data) {
            detailsList = array
        } else if let container = try? decoder.decode(LegacyBookDetailsContainer.self, from: data) {
            detailsList = container.savedBooks
        } else {
            detailsList = try decoder.decode([SingleBookDetails].self, from: data)
        }

        guard let rawDetails = detailsList.first(where: { $0.id == bookID }) else {
            throw BookStoreError.bookNotFound(id: bookID)
        }

        var checkpoints = rawDetails.checkpoints
        let progress = loadProgress(for: bookID)

        // Overlay user progress onto the single book's checkpoints
        for i in checkpoints.indices {
            let cpID = checkpoints[i].id
            if let unlockDate = progress.unlockedCheckpoints[cpID] {
                checkpoints[i].unlockedAt = unlockDate
            }
            if let answerIndex = progress.mysteryAnswers[cpID] {
                checkpoints[i].mystery.selectedOptionIndex = answerIndex
            }
        }

        return (checkpoints, rawDetails.characters)
    }

    /// Loads a single book (e.g. the selected one) fully populated with its checkpoints and characters.
    public func loadSingleBook(
        id bookID: UUID,
        fileName: String = "BookData",
        bundle: Bundle = .main
    ) throws -> Book? {
        let books = try loadBooks(fileName: fileName, bundle: bundle)
        guard var book = books.first(where: { $0.id == bookID }) else { return nil }

        let (checkpoints, characters) = try loadDetails(for: bookID, fileName: fileName, bundle: bundle)
        book.checkpoints = checkpoints
        book.characters = characters
        return book
    }

    /// Retrieves the selected book ID from persistent storage (UserDefaults).
    public func loadSelectedBookID() -> UUID? {
        guard let savedString = UserDefaults.standard.string(forKey: BookStore.selectedBookStorageKey),
              let uuid = UUID(uuidString: savedString) else {
            return nil
        }
        return uuid
    }

    /// Loads the currently selected book with full checkpoints and characters.
    public func loadCurrentBook(
        fileName: String = "BookData",
        bundle: Bundle = .main
    ) throws -> Book? {
        guard let currentID = loadSelectedBookID() else { return nil }
        return try loadSingleBook(id: currentID, fileName: fileName, bundle: bundle)
    }

    // MARK: - Raw Decoders

    /// Decodes an array of books directly from raw JSON Data (supports root array [Book] or legacy dictionary).
    public func decode(from data: Data) throws -> [Book] {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode([Book].self, from: data)
        } catch {
            throw error
        }
    }

    /// Convenience decoder directly from raw JSON string (ideal for previews and unit tests).
    public func decode(from jsonString: String) throws -> [Book] {
        guard let data = jsonString.data(using: .utf8) else {
            throw BookStoreError.invalidEncoding
        }
        return try decode(from: data)
    }

    // MARK: - Saving

    /// Encodes and saves books to disk as a JSON array.
    public func saveBooksData(_ books: [Book], fileName: String = "BookData", bundle: Bundle = .main) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(books)

        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw BookStoreError.fileNotFound(fileName: "\(fileName).json")
        }

        try data.write(to: url)
    }
}

// MARK: - Private Helper for Decoding Single Book Details from Top-Level Array

private struct SingleBookDetails: Decodable {
    let id: UUID
    let checkpoints: [Checkpoint]
    let characters: [Character]

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case checkpoints
        case characters
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.checkpoints = try container.decodeIfPresent([Checkpoint].self, forKey: .checkpoints) ?? []
        self.characters = try container.decodeIfPresent([Character].self, forKey: .characters) ?? []
    }
}

private struct LegacyBookDetailsContainer: Decodable {
    let savedBooks: [SingleBookDetails]
}
