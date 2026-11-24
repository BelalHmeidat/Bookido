//
//  MysteriesCardsView.swift
//  Bookido
//
//  Created by Stefania Rosciano on 23/11/2026.
//

import SwiftUI

struct MysteriesCardsView : View {
    
    var body : some View {
        
        
        HStack {
            
            ZStack  {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 30, height: 30)
                         
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundStyle(SketchTheme.surfaceCards)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            VStack (alignment : .leading){
                
                Text("Open Question")
                    .font(.system(.caption, design: .rounded, weight: .semibold))
                    .foregroundStyle(SketchTheme.surfaceCards)
                
                Text("Question?")
                    .font(.system(.headline, design: .serif, weight: .bold))
                    .foregroundStyle(SketchTheme.surfaceCards)
                
            }
        
            
        }
        .padding(10)
        .frame(width: 330, height: 70, alignment: .leading)
        .background(
            SketchTheme.primaryAccent, in : RoundedRectangle(cornerRadius: 10)
        )
        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

struct CluesListView : View {
    
    var body : some View {
        
        HStack {
            
            Text("1")
                .font(.system(.footnote, design: .rounded, weight: .bold))
                .foregroundStyle(SketchTheme.primaryAccent)
                .padding(10)
                .background(SketchTheme.surfaceCards, in : Circle())
            Text("Clue description hdfdshfkdhfkjasnfvksdj bvkdsjabvbkjdbkhfkfbskladbdb")
                .font(.system(.footnote, design: .rounded, weight: .semibold))
                .foregroundStyle(SketchTheme.primaryAccent)
                .fixedSize(horizontal: false, vertical: true)
            
            
        }
        .frame(width: 360)
        .padding()
        
    }
    
}

struct QuizzesCardView : View {
    
    let answers: [String] = [
        "a. Answer 1",
        "b. Answer 2",
        "c. Answer 3"
    ]
    
    var body : some View {
        
        VStack(spacing: 12) {
            
            Text("\(Image(systemName: "magnifyingglass")) Answer the Mystery")
                .font(.system(.headline, design: .serif, weight: .bold))
                .foregroundStyle(SketchTheme.primaryAccent)
            
            Divider()
                .frame(width: 300, height: 2)
                .overlay(SketchTheme.primaryAccent)
            
            ForEach(answers, id: \.self) { answer in
                
                Button {
                    //pass
                } label : {
                    
                    Text(answer)
                        .font(.system(.callout, design: .rounded, weight: .semibold))
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundStyle(SketchTheme.accentBlue)
                        .frame(width: 280, height: 30, alignment: .leading)
                        .padding(12)
                        .background(
                            SketchTheme.accentBlue.opacity(0.2),
                            in: RoundedRectangle(cornerRadius: 12)
                        )
                    
                }
                
            }
        }
        .frame(width : 300, height : 250)
        .padding(12)
    }
}

#Preview {
    
    MysteriesCardsView()
    
    CluesListView()
    
    QuizzesCardView()
    
}
