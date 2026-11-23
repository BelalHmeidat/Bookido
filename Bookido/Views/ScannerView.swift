//
//  ScannerOnBoarding.swift
//  Bookido
//
//  Created by Stefania Rosciano on 22/11/2026.
//

import SwiftUI

struct ScannerView: View {

    let isOnboarding: Bool
    @Binding var hasCompletedOnboarding: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .topLeading) {
            
            SketchTheme.darkBackground
                .ignoresSafeArea()
            
            // Camera

            if isOnboarding {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(SketchTheme.surfaceCards)
                        .font(.headline)
                        .padding(12)
                        .background(.ultraThinMaterial, in: Circle())
                }
                .padding()
            }
        }
    }
}
