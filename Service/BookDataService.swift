public final class BookDataService {
    public static let shared = BookDataService()

    private init() {}

    public 

    public func loadBooksData() throws -> BookData {
        guard let url = Bundle.main.url(forResource: "BookData", withExtension: "json") else {
            throw NSError(domain: "BookDataService", code: 1, userInfo: [NSLocalizedDescriptionKey: "BookData.json not found in bundle."])
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode(BookData.self, from: data)
    }

    public func loadBooks() throws -> [Book] {
        let bookData = try loadBooksData()
        return bookData.savedBooks
    }

    public func loadCurrentBookID() throws -> UUID? {
        let bookData = try loadBooksData()
        return bookData.currentBookID
    }

    public func loadCurrentBook() throws -> Book? {
        
    }

    public func unlockCheckpoint(for bookID: UUID, checkpointID: UUID) throws {
        var bookData = try loadBooksData()
        guard let bookIndex = bookData.savedBooks.firstIndex(where: { $0.id == bookID }) else {
            throw NSError(domain: "BookDataService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Book with ID \(bookID) not found."])
        }

        var book = bookData.savedBooks[bookIndex]
        if !book.unlockedCheckpoints.contains(checkpointID) {
            // unlock the checkpoint by updating the unlockedAt property
            if let checkpointIndex = book.checkpoints.firstIndex(where: { $0.id == checkpointID }) {
                book.checkpoints[checkpointIndex].unlockedAt = Date()
                book.unlockedCheckpoints.append(checkpointID)
                bookData.savedBooks[bookIndex] = book
                try saveBooksData(bookData)
            } else {
                throw NSError(domain: "BookDataService", code: 3, userInfo: [NSLocalizedDescriptionKey: "Checkpoint with ID \(checkpointID) not found in book \(bookID)."])
            }
        }
    }

    private func saveBooksData(_ bookData: BookData) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(bookData)

        guard let url = Bundle.main.url(forResource: "BookData", withExtension: "json") else {
            throw NSError(domain: "BookDataService", code: 4, userInfo: [NSLocalizedDescriptionKey: "BookData.json not found in bundle."])
        }

        try data.write(to: url)
    }


}