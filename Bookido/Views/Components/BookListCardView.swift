//
//  BookListCardView.swift
//  Bookido
//
//  Created by Belal Hmeidat on 23/11/2026.
//

import SwiftUI

struct BookCardView : View {
    let viewModel: BookCardViewModel

    var body : some View {
        HStack {
            if !viewModel.coverImage.isEmpty, let uiImage = UIImage(named: viewModel.coverImage) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 86)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(SketchTheme.accentBlue.opacity(0.15))
                    .frame(width: 60, height: 86)
                    .overlay {
                        Image(systemName: "book.closed")
                            .font(.title2)
                            .foregroundStyle(SketchTheme.primaryAccent)
                    }
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.title)
                    .font(.system(.title3, design: .serif, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(SketchTheme.primaryAccent)

                Text(viewModel.formattedAuthor)
                    .font(.subheadline)
                    .opacity(0.8)
                    .foregroundStyle(SketchTheme.primaryAccent)

                Text(viewModel.chaptersText)
                    .font(.caption)
                    .opacity(0.75)
                    .foregroundStyle(SketchTheme.primaryAccent)
            }

            Spacer(minLength: 20)

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .opacity(0.7)
                .foregroundStyle(SketchTheme.primaryAccent)
        }
        .padding(16)
        .background(
            SketchTheme.surfaceCards, in: RoundedRectangle(cornerRadius: 20)
        )
    }
}

#Preview {
    BookCardView(
        viewModel: BookCardViewModel(
            book: Book(
                isbn: "978-0156012195",
                title: "The Little Prince",
                author: "Antoine de Saint-Exupéry",
                genre: "Fable",
                numberOfChapters: 27,
                synopsis: "A story about a young prince who visits various planets."
            )
        )
    )
}
