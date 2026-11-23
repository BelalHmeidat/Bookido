//
//  ListBooksView.swift
//  Bookido
//
//  Created by Stefania Rosciano on 23/11/2026.
//

import SwiftUI

struct ListBooksView: View {
    let isOnboarding: Bool
    @Binding var hasCompletedOnboarding: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .topLeading) {
            SketchTheme.mainBackground
                .ignoresSafeArea()

            VStack {
                
                Text("Pick a Book to start with")
                    .font(.system(.largeTitle, design: .serif, weight: .bold))
                    .foregroundStyle(SketchTheme.primaryAccent)
                    .frame(alignment: .topLeading)
                    .padding(60)
                    
                
            }

            if isOnboarding {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .foregroundStyle(SketchTheme.primaryAccent)
                        .padding(12)
                        .background(.ultraThinMaterial, in: Circle())
                        .padding()
                }
            }
        }
    }
}

#Preview {
    ListBooksView(
        isOnboarding: true,
        hasCompletedOnboarding: .constant(false)
    )
}
