//
//  ReusableView.swift
//  Bookido
//
//  Created by Stefania Rosciano on 20/11/2026.
//

// Resuable ui components (nodes, characters nodes)

import SwiftUI

struct CurrentNodeView: View {
    
    var body: some View {
        
        ZStack{
            
            Image(systemName: "star")
                .font(.system(size: 25, weight: .semibold, design: .rounded))
                .foregroundStyle(
                    SketchTheme.primaryAccent
                )
                .background(
                    Circle()
                        .fill(SketchTheme.surfaceCards)
                        .frame(width: 64, height: 64, alignment: .center)
                        .overlay(
                            Circle()
                                .stroke(SketchTheme.primaryAccent, lineWidth: 3)
                        )
                )
            
            Circle()
                .strokeBorder(
                    SketchTheme.accentBlue, style: StrokeStyle(
                        lineWidth: 2,
                        dash: [5, 5]
                    ))
                .frame(width : 80, height: 80, alignment: .center)
        }
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}


struct CurrentNodeCardView : View {
    
    var body : some View {
        
        VStack () {
            
                
            Text("Event")
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(SketchTheme.accentBlue)
            
            // title
            
            Text("Event Title")
                .font(.system(.title, design: .serif, weight: .bold))
                .foregroundStyle(SketchTheme.primaryAccent)
            
            Text("very long description fhkjdshflkdshflksadhflkajdhflkadhfklahjsdfkjlahdsflkjahdfkljhadklfhadslhfdkljshfkldjshfkjhdsfkjldhsfjklhasdf")
                .font(.body)
                .foregroundStyle(SketchTheme.secondaryAccent)
                .fixedSize(horizontal: false, vertical: true)
            
            // vertical : true makes it grow as the text grows
             
            Text("J")
                .font(.system(.footnote, design: .serif, weight: .bold))
                .foregroundStyle(SketchTheme.surfaceCards)
                .padding(10)
                .background(SketchTheme.accentBlue, in: Circle())
            
        }
        .padding(.horizontal)
        .padding(.top, 48)
        .padding(.bottom, 20)
        .background(
            SketchTheme.surfaceCards,
            in : RoundedRectangle(cornerRadius: 20)
        )
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .overlay(alignment: .top) {
            CurrentNodeView()
                .offset(y:-40)
        }
        .padding(.horizontal)
        
    }
        
    
}

#Preview {
    
    CurrentNodeCardView()
    
}
