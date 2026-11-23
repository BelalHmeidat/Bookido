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



struct NodeView: View {

    var isRegularNode: Bool = true
                                                             
    private var config: NodeConfig {
        NodeConfig(isRegularNode: isRegularNode)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(config.backgroundColor)
                .frame(width: config.width, height: config.height)
                .overlay(
                    Circle()
                        .stroke(config.borderColor, lineWidth: 2)
                )
                     
            Image(systemName: config.iconName)
                .font(.system(size: config.iconSize, weight: .semibold, design: .rounded))
                .foregroundStyle(config.iconColor)
        }
    }
}

struct BookCardView : View {
    
    var body : some View {
        
        // photo + text
        
        HStack {
            
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3)) //image will be here
                .frame(width: 60, height: 86)
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
    VStack(spacing: 24) {

        CurrentNodeView()

        NodeView(isRegularNode: true)

        NodeView(isRegularNode: false)
        
        BookCardView()
    }
    .padding()
}
