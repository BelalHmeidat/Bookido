//
//  RewardCardView.swift
//  Bookido
//
//  Created by Stefania Rosciano on 23/11/2026.
//

import SwiftUI

struct RewardCardView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .topLeading) {
            SketchTheme.accentBlue
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Text("Chapter 2 unlocked")
                    .font(.system(.largeTitle, design: .serif, weight: .bold))
                    .foregroundStyle(SketchTheme.mainBackground)
                    .padding(.top, 70)

                HStack {
                    Image(systemName: "sparkle")
                        .font(.system(size: 28))
                        .foregroundStyle(SketchTheme.mainBackground.opacity(0.8))
                        .offset(y: 12)

                    Spacer()

                    Image(systemName: "sparkle")
                        .font(.system(size: 22))
                        .foregroundStyle(SketchTheme.mainBackground.opacity(0.8))
                        .offset(y: -8)
                }
                .padding(.horizontal, 60)
                .padding(.bottom, 6)

                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(SketchTheme.darkBackground)
                        .frame(width: 280, height: 390)
                        .rotationEffect(.degrees(-6))
                        .offset(x: -18, y: 8)

                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .foregroundStyle(SketchTheme.surfaceCards)
                            .frame(width: 280, height: 390)

                        UnevenRoundedRectangle(
                            topLeadingRadius: 24,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 24
                        )
                        .foregroundStyle(SketchTheme.mainBackground)
                        .frame(width: 280, height: 205)
                        .offset(y: -92.5)

                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(SketchTheme.darkBackground)
                            .frame(width: 135, height: 135)
                            .offset(y: -95)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Event")
                                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                .foregroundStyle(SketchTheme.accentBlue)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 5)
                                .background(SketchTheme.accentBlue.opacity(0.2), in: Capsule())

                            Text("Welcome to the castle")
                                .font(.system(.title2, design: .serif, weight: .bold))
                                .foregroundStyle(SketchTheme.primaryAccent)

                            Text("The Count welcomes Jonathan himself. Next morning, the shaving mirror shows no one standing behind him.")
                                .font(.system(.subheadline, design: .rounded, weight: .regular))
                                .foregroundStyle(SketchTheme.secondaryAccent)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(width: 240, alignment: .leading)
                        .offset(y: 95)
                    }
                    .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 6)
                }

                HStack {
                    Circle()
                        .fill(SketchTheme.mainBackground.opacity(0.75))
                        .frame(width: 6, height: 6)

                    Spacer()

                    Image(systemName: "sparkle")
                        .font(.system(size: 22))
                        .foregroundStyle(SketchTheme.mainBackground.opacity(0.8))
                }
                .padding(.horizontal, 75)
                .padding(.top, 16)

                Spacer()

                Button {
                    // Share logic
                } label: {
                    Text("Share")
                        .font(.system(.body, design: .rounded, weight: .semibold))
                        .foregroundStyle(SketchTheme.accentBlue)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(SketchTheme.mainBackground, in: Capsule())
                        .overlay(
                            Capsule()
                                .strokeBorder(.white.opacity(0.5), lineWidth: 1)
                        )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 28)
            }

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(12)
                    .background(.ultraThinMaterial, in: Circle())
                    .padding()
            }
        }
    }
}

#Preview {
    RewardCardView()
}
