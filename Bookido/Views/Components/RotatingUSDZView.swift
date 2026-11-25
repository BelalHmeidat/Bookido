//
//  RotatingUSDZView.swift
//  Bookido
//
//  Created by Belal Hmeidat on 25/11/2026.
//

import SceneKit
import SwiftUI

#if canImport(UIKit)
import UIKit

/// Renders a bundled `.usdz` 3D model on a transparent background, rotating continuously around the Z axis.
struct RotatingUSDZView: UIViewRepresentable {
    let modelName: String
    var duration: TimeInterval = 6.0

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.backgroundColor = .clear
        scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = false
        scnView.isUserInteractionEnabled = false

        if let url = Bundle.main.url(forResource: modelName, withExtension: "usdz"),
           let scene = try? SCNScene(url: url, options: nil) {
            scnView.scene = scene

            let spin = SCNAction.repeatForever(
                SCNAction.rotateBy(x: 0, y: .pi * 2, z: 0, duration: duration)
            )
            scene.rootNode.runAction(spin)
        }

        return scnView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {}
}
#elseif canImport(AppKit)
import AppKit

/// Renders a bundled `.usdz` 3D model on a transparent background, rotating continuously around the Z axis.
struct RotatingUSDZView: NSViewRepresentable {
    let modelName: String
    var duration: TimeInterval = 6.0

    func makeNSView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.backgroundColor = .clear
        scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = false

        if let url = Bundle.main.url(forResource: modelName, withExtension: "usdz"),
           let scene = try? SCNScene(url: url, options: nil) {
            scnView.scene = scene

            let spin = SCNAction.repeatForever(
                SCNAction.rotateBy(x: 0, y: .pi * 2, z: 0, duration: duration)
            )
            scene.rootNode.runAction(spin)
        }

        return scnView
    }

    func updateNSView(_ nsView: SCNView, context: Context) {}
}
#endif
