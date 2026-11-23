//
//  BookCardViewModel.swift
//  This view model is for both Views: List Card View and Grid Card View
//  Bookido
//
//  Created by Belal Hmeidat on 23/11/2026.
//

import Foundation
import SwiftUI

/// View model representing the presentation data for a book card in lists or shelves.
@Observable
public final class BookCardViewModel: Identifiable {
    public let book: Book

    public init(book: Book) {
        self.book = book
    }

    public var id: UUID {
        book.id
    }

    public var title: String {
        book.title
    }

    public var author: String {
        book.author
    }

    public var formattedAuthor: String {
        "By \(book.author)"
    }

    public var coverImage: String {
        book.coverImage
    }

    public var chaptersText: String {
        "\(book.numberOfChapters) Chapters"
    }

    public var currentProgressText: String {
        "Chapter \(book.currentChapter) of \(book.numberOfChapters)"
    }

    public var progressPercentage: Int {
        book.checkpointProgressPercentage
    }

    public var progressPercentageText: String {
        "\(book.checkpointProgressPercentage)%"
    }

    public var checkpointsText: String {
        "\(book.unlockedCheckpoints.count)/\(book.checkpoints.count) Checkpoints"
    }

    public var hasCoverImage: Bool {
        !book.coverImage.isEmpty
    }
}

