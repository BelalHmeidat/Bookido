//
//  CharactersView.swift
//  Bookido
//
//  Created by Stefania Rosciano on 23/11/2026.
//

import SwiftUI


struct CharactersView : View {
    
    @Environment(BookStore.self) private var bookStore: BookStore
    
    var body : some View {
        
        let currentBook = bookStore.selectedBook
        
        let totalCharacters : Int = currentBook?.characters.count ?? 0
        
        let unlockedCharacters : [Character] = currentBook?.unlockedCharacters ?? []
        
        
        ZStack {

            SketchTheme.mainBackground
                .ignoresSafeArea()
            
            ScrollView {
                
                ForEach (unlockedCharacters) { character in
                    
                    Button {
                        
                        // character View
                        
                    } label : {
                        CharacterCardGridView(character: character)
                    }
                    
                    
                    
                }

                
                
            }
            
        
            
        }
        
        
        
    }
    
}

#Preview {
    
    CharactersView()
        .environment(BookStore())
    
}
