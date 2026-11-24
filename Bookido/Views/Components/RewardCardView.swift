//
//  RewardCardView.swift
//  Bookido
//
//  Created by Stefania Rosciano on 23/11/2026.
//

import SwiftUI

struct RewardCardView : View {
    
    var body : some View {
        
        
        
        ZStack (alignment : .center) {
            
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(SketchTheme.surfaceCards)
                .frame(width : 350, height : 450)
            
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(SketchTheme.mainBackground)
                .frame(width : 350, height : 240)
                .offset(y:-104)
            
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(SketchTheme.darkBackground)
                .frame(width: 150, height: 150)
                .offset(y:-110)
            
            VStack (alignment: .leading) {
                
                Text("Event")
                    .font(.system(.subheadline, design : .rounded, weight: .semibold))
                    .foregroundStyle(SketchTheme.accentBlue)
                    .frame(width : 60, height: 30)
                    .background(SketchTheme.accentBlue.opacity(0.2), in : RoundedRectangle(cornerRadius: 10))
                
                Text("Title Card")
                    .font(.system(.title, design: .serif, weight: .bold))
                    .foregroundStyle(SketchTheme.primaryAccent)
                
                Text("Description card")
                    .font(.system(.subheadline, design: .rounded, weight: .regular))
                    .foregroundStyle(SketchTheme.primaryAccent)
                    
                    
            }
            .frame(width: 300, alignment: .leading)
            .offset(y: 75)
            
            
        }
        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
        
        
                        
        
        
    }
    
    
}

#Preview {
    
    RewardCardView()
    
}
