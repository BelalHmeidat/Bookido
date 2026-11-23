//
//  CardView.swift
//  Bookido
//
//  Created by Belal Hmeidat on 23/11/2026.
//

import SwiftUI

struct BookCardView : View {
    
    let viewModel: BookCardViewModel
    
    var body : some View {
        
        // photo + text
        
        HStack {
            
            Image(viewModel.coverImage)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 86)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Tiltle")
                    .font(.system(.title3, design: .serif, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(SketchTheme.primaryAccent)
                
                Text("author")
                    .font(.subheadline)
                    .opacity(0.8)
                    .foregroundStyle(SketchTheme.primaryAccent)
                
                Text("chapters")
                    .font(.caption)
                    .opacity(0.75)
                    .foregroundStyle(SketchTheme.primaryAccent)
            }
            
            Spacer(minLength: 20)
            
            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .opacity(0.7) 
            
            
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
