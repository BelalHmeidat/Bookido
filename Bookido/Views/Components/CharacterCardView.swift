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
        HStack(spacing: 10) {
            Text(character.name.prefix(1))
                .font(.system(.subheadline, design: .serif, weight: .bold))
                .foregroundStyle(SketchTheme.surfaceCards)
                .frame(width: 36, height: 36)
                .background(SketchTheme.accentBlue, in: Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(character.name)
                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                    .foregroundStyle(SketchTheme.primaryAccent)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(character.role)
                    .font(.system(.caption, design: .rounded, weight: .regular))
                    .foregroundStyle(SketchTheme.secondaryAccent)
                    .lineLimit(1)
            }

            Spacer(minLength: 4)

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(SketchTheme.secondaryAccent)
                .opacity(0.7)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, minHeight: 74, alignment: .leading)
        .background(SketchTheme.surfaceCards, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}

struct LockedCharacterCard : View {
    var body : some View {
        HStack(spacing: 10) {
            Image(systemName : "person.fill")
                .font(.system(size: 15))
                .foregroundStyle(SketchTheme.secondaryAccent.opacity(0.45))
                .frame(width: 36, height: 36)
                .background(
                    SketchTheme.secondaryAccent.opacity(0.2), in: Circle()
                )

            Capsule()
                .frame(width: 72, height: 10)
                .foregroundStyle(SketchTheme.secondaryAccent.opacity(0.25))

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, minHeight: 74, alignment: .leading)
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
