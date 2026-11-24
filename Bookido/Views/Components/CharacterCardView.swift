//
//  CharacterCardView.swift
//  Bookido
//
//  Created by Stefania Rosciano on 23/11/2026.
//

import SwiftUI

struct CharacterCardGridView : View {
    
    let character : Character
    
    
    var body : some View {
        
        HStack {
            
            Text(character.name.prefix(1))
                .font(.system(.subheadline, design: .serif, weight: .bold))
                .foregroundStyle(SketchTheme.surfaceCards)
                .padding(15)
                .background(SketchTheme.accentBlue, in: Circle())
            
            VStack {
                
                Text(character.name)
                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                    .foregroundStyle(SketchTheme.primaryAccent)
                
                Text(character.quote)
                    .font(.system(.caption, design: .rounded, weight: .regular))
                    .foregroundStyle(SketchTheme.primaryAccent)
                
                
            }
            
            Spacer(minLength: 20)
            
            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .opacity(0.7)
            
            
        }
        .padding(12)
        .frame(width: 200, height: 70)
        .background(SketchTheme.surfaceCards, in: RoundedRectangle(cornerRadius: 10))
        
        
    }
    
    
    
}

struct LockedCharacterCard : View {
    
    var body : some View {
        
        HStack {
            
            Image(systemName : "person.fill")
                .resizable()
                .frame(width: 20, height:20)
                .foregroundStyle(SketchTheme.secondaryAccent.opacity(0.3))
                .frame(width: 32, height: 32)
                .background(
                    SketchTheme.secondaryAccent.opacity(0.4), in : Circle()
                )
            
            Capsule()
                .frame(width:80, height : 10)
                .foregroundStyle(SketchTheme.secondaryAccent.opacity(0.3))
                .padding()
            
            
        }
        .padding(12)
        .frame(maxWidth: 200, minHeight: 70, alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    SketchTheme.secondaryAccent.opacity(0.35),
                    style: StrokeStyle(lineWidth: 1.5, dash: [4, 4])
                )
        )
    }
    
    
}

struct CharacterDescriptionCardView : View {
    
    var body : some View {
        
        
        HStack {
            
            VStack (alignment : .leading, spacing: 2) {
                
                Text("Jason GTA")
                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                    .foregroundStyle(SketchTheme.primaryAccent)
                
                Text("Role + met in ch. 1")
                    .font(.system(.footnote, design: .rounded, weight: .regular))
                    .foregroundStyle(SketchTheme.primaryAccent)
                Button {
                    // connect to the characters view
                } label : {
                    
                    Text("See more \(Image(systemName: "chevron.right"))")
                        .font(.system(.caption, design : .rounded, weight: .medium))
                        .foregroundStyle(SketchTheme.accentBlue)
                    
                }
                
                
            }
            
            Spacer(minLength: 20)
            
            
        }
        .padding(12)
        .frame(width: 200, height: 70)
        .background(SketchTheme.surfaceCards, in: RoundedRectangle(cornerRadius: 10))
        
        
        
        
    }
    
}

#Preview {
    LockedCharacterCard()
}
