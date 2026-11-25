//
//  CharactersView.swift
//  Bookido
//
//  Created by Stefania Rosciano on 23/11/2026.
//

import SwiftUI


struct CharactersView : View {
    
    @Environment(BookStore.self) private var bookStore: BookStore
    
    @State private var showCharacterDescription: Bool = false
    
    var body : some View {
        
        let currentBook = bookStore.selectedBook
        
        let totalCharacters : Int = currentBook?.characters.count ?? 0
        
        let unlockedCharacters : [Character] = currentBook?.unlockedCharacters ?? []
        
        let lockedCount: Int = max(0, totalCharacters - unlockedCharacters.count)
        
        let columns = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ]
    
        
        ZStack {

            SketchTheme.mainBackground
                .ignoresSafeArea()
            
            ScrollView {
                
                VStack(spacing: 16) {
                    
                    Text("Characters")
                        .font(.system(.title, design : .serif, weight : .bold))
                        .foregroundStyle(SketchTheme.primaryAccent)
                    
                    Text("\(unlockedCharacters.count) met so far - more appear as you read")
                        .font(.system(.callout, design: .rounded, weight: .regular))
                        .foregroundStyle(SketchTheme.primaryAccent)
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        
                        ForEach (unlockedCharacters) { character in
                            
                            NavigationLink {
                                CharacterDescriptionView(character: character)
                            } label: {
                                CharacterCardGridView(character: character)
                            }
                            .buttonStyle(.plain)
                            
                            
                            
                        }
                        
                        ForEach (0..<lockedCount, id : \.self) {
                            
                            locked in LockedCharacterCard()
                            
                            
                            
                        }

                        
                        
                        
                    }
                    .padding(.top, 8)
                    
                    
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 32)
                
                
            }
            
        
            
        }
        
        
        
    }
    
}

#Preview {
    let store = BookStore()
    if let firstBook = store.books.first {
        store.selectBook(firstBook)
    }
    return NavigationStack {
        CharactersView()
            .environment(store)
    }
}
