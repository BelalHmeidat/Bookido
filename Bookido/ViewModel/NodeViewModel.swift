//
//  NodeViewModel.swift
//  Bookido
//
//  Created by Stefania Rosciano on 20/11/2026.
//

import SwiftUI

struct NodeConfig {
    let isRegularNode: Bool
                             
    var width: CGFloat { isRegularNode ? 28 : 52 }
    var height: CGFloat { isRegularNode ? 28 : 52 }
    var iconSize: CGFloat { isRegularNode ? 10 : 18 }
    var iconName: String { isRegularNode ? "checkmark" : "lock.fill" }
    var backgroundColor: Color { isRegularNode ? SketchTheme.surfaceCards : SketchTheme.primaryAccent }
    var borderColor: Color { isRegularNode ? SketchTheme.primaryAccent : SketchTheme.mystery }
    var iconColor: Color { isRegularNode ? SketchTheme.primaryAccent : SketchTheme.mystery }
}
