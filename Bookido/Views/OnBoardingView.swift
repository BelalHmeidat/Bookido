//
//  OnBoarding.swift
//  Bookido
//
//  Created by Stefania Rosciano on 20/11/2026.
//

import SwiftUI

struct OnBoardingView: View {
    @State private var showScanner: Bool = false
    @State private var showListBooks: Bool = false

    var body: some View {
        ZStack {
            SketchTheme.mainBackground
                .ignoresSafeArea()

            VStack {
                Image("onBoardingGraph")
                    .resizable()
                    .frame(width: 350, height: 300)

                Text("Every Book Hides a few mysteries.")
                    .font(.system(.largeTitle, design: .serif, weight: .bold))
                    .foregroundStyle(SketchTheme.primaryAccent)
                    .frame(alignment: .center)

                Text("Scan your book, read at your pace, and uncover the story one event at a time.")
                    .font(.system(.callout, design: .rounded, weight: .regular))
                    .foregroundStyle(SketchTheme.primaryAccent)
                    .frame(width: 300, alignment: .center)
                    .padding()

                Button {
                    showScanner = true
                } label: {
                    Text("\(Image(systemName: "camera.fill")) Scan your book")
                        .font(.system(.callout, design: .rounded, weight: .semibold))
                        .foregroundStyle(SketchTheme.mainBackground)
                        .frame(width: 250, height: 50)
                        .background(
                            SketchTheme.accentBlue,
                            in: RoundedRectangle(cornerRadius: 10)
                        )
                }

                Button {
                    showListBooks = true
                } label: {
                    Text("Choose a starter book")
                        .font(.system(.callout, design: .rounded, weight: .semibold))
                        .foregroundStyle(SketchTheme.mainBackground)
                        .frame(width: 250, height: 50)
                        .background(
                            SketchTheme.primaryAccent,
                            in: RoundedRectangle(cornerRadius: 10)
                        )
                }
            }
            .padding()
        }
        .fullScreenCover(isPresented: $showScanner) {
            ScannerView(isOnboarding: true)
        }
        .fullScreenCover(isPresented: $showListBooks) {
            ListBooksView(isOnboarding: true)
        }
    }
}

#Preview {
    OnBoardingView()
}
