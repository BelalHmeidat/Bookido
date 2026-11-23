//
//  CardView.swift
//  Bookido
//
//  Created by Belal Hmeidat on 23/11/2026.
//

import SwiftUI

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
