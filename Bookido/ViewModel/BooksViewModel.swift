//
//  BooksViewModel.swift
//  Bookido
//
//  Created by Stefania Rosciano on 23/11/2026.
//

import Foundation
import SwiftUI

@Observable
class BooksViewModel {
    var books: [Book] = []

    init() {
        loadBooks()
    }

    func loadBooks() {
        do {
            books = try BookDataService.shared.loadBooks()
        } catch {
            print("Failed to load books: \(error.localizedDescription)")
        }
    }
}
