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
    }
}
