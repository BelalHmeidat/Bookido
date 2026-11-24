//
//  ScannerOnBoarding.swift
//  Bookido
//
//  Created by Stefania Rosciano on 22/11/2026.
//

import SwiftUI

struct ScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(BookStore.self) private var bookStore: BookStore?
    @AppStorage(BookStore.selectedBookStorageKey) private var selectedBookIdString: String = ""

    var body: some View {
        ZStack(alignment: .topLeading) {
            SketchTheme.darkBackground
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 80))
                    .foregroundStyle(SketchTheme.accentBlue)

                Text("Point your camera at a book cover or barcode")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(SketchTheme.surfaceCards)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                if bookStore?.selectedBook == nil {
                    Button {
                        // Simulate scanning the starter book
                        if let firstBook = bookStore?.books.first {
                            bookStore?.selectBook(firstBook)
                            selectedBookIdString = firstBook.id.uuidString
                        }
                        dismiss()
                    } label: {
                        Text("Simulate Scan (Demo)")
                            .font(.system(.callout, design: .rounded, weight: .semibold))
                            .foregroundStyle(SketchTheme.darkBackground)
                            .frame(width: 220, height: 46)
                            .background(
                                SketchTheme.accentBlue,
                                in: RoundedRectangle(cornerRadius: 10)
                            )
                    }
                }

                Spacer()
            }
            .frame(maxWidth: .infinity)

            if bookStore?.selectedBook != nil {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(SketchTheme.surfaceCards)
                        .font(.headline)
                        .padding(12)
                        .background(.ultraThinMaterial, in: Circle())
                }
                .padding()
            }
        }
    }
}

#Preview {
    ScannerView()
}
