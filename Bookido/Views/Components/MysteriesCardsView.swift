//
//  MysteriesCardsView.swift
//  Bookido
//
//  Created by Stefania Rosciano on 23/11/2026.
//

import SwiftUI

struct MysteriesCardsView: View {
    let mystery: Mystery

    private var solvedAnswer: String {
        guard mystery.options.indices.contains(mystery.answerIndex) else { return "" }
        return mystery.options[mystery.answerIndex]
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(mystery.isSolved ? SketchTheme.primaryAccent.opacity(0.12) : SketchTheme.surfaceCards.opacity(0.2))
                    .frame(width: 36, height: 36)

                Image(systemName: mystery.isSolved ? "checkmark" : "magnifyingglass")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(mystery.isSolved ? SketchTheme.primaryAccent : SketchTheme.surfaceCards)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(mystery.isSolved ? mystery.question : "Open Question")
                    .font(.system(mystery.isSolved ? .subheadline : .caption, design: .rounded, weight: .semibold))
                    .foregroundStyle(mystery.isSolved ? SketchTheme.primaryAccent : SketchTheme.surfaceCards)

                Text(mystery.isSolved ? solvedAnswer : mystery.question)
                    .font(.system(mystery.isSolved ? .caption : .headline, design: .serif, weight: mystery.isSolved ? .regular : .bold))
                    .foregroundStyle(mystery.isSolved ? SketchTheme.secondaryAccent : SketchTheme.surfaceCards)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 74, alignment: .leading)
        .background(
            mystery.isSolved ? SketchTheme.surfaceCards : SketchTheme.primaryAccent,
            in: RoundedRectangle(cornerRadius: 16)
        )
        .shadow(color: .black.opacity(mystery.isSolved ? 0.08 : 0.25), radius: 8, x: 0, y: 4)
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
    
   // MysteriesCardsView()
    
    CluesListView()
    
    QuizzesCardView()
    
}
