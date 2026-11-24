//
//  CharacterDescriptionView.swift
//  Bookido
//
//  Created by Stefania Rosciano on 24/11/2026.
//

import SwiftUI

struct CharacterDescriptionView: View {
    let character: Character
    @Environment(\.dismiss) private var dismiss

    private let columns = [
        GridItem(.adaptive(minimum: 130), spacing: 8)
    ]

    var body: some View {
        ZStack(alignment: .topLeading) {
            SketchTheme.mainBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(spacing: 16) {
                        Text(String(character.name.prefix(1)))
                            .font(.system(.largeTitle, design: .serif, weight: .bold))
                            .foregroundStyle(SketchTheme.surfaceCards)
                            .frame(width: 96, height: 96)
                            .background(SketchTheme.primaryAccent, in: Circle())

                        Text(character.name)
                            .font(.system(.largeTitle, design: .serif, weight: .bold))
                            .foregroundStyle(SketchTheme.primaryAccent)
                            .multilineTextAlignment(.center)

                        VStack(spacing: 12) {
                            HStack(spacing: 32) {
                                VStack(spacing: 4) {
                                    Text("Affiliation")
                                        .font(.system(.caption, design: .rounded))
                                        .foregroundStyle(SketchTheme.secondaryAccent)

                                    Text(character.role)
                                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                        .foregroundStyle(SketchTheme.primaryAccent)
                                }

                                VStack(spacing: 4) {
                                    Text("First appears")
                                        .font(.system(.caption, design: .rounded))
                                        .foregroundStyle(SketchTheme.secondaryAccent)

                                    Text(character.firstAppearance)
                                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                        .foregroundStyle(SketchTheme.primaryAccent)
                                }
                            }

                            if !character.quote.isEmpty {
                                VStack(spacing: 4) {
                                    Text("Quote")
                                        .font(.system(.caption, design: .rounded))
                                        .foregroundStyle(SketchTheme.secondaryAccent)

                                    Text(character.quote)
                                        .font(.system(.subheadline, design: .serif))
                                        .italic()
                                        .foregroundStyle(SketchTheme.primaryAccent)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 48)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Biography")
                            .font(.system(.title2, design: .serif, weight: .bold))
                            .foregroundStyle(SketchTheme.primaryAccent)

                        Text(character.biography)
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(SketchTheme.secondaryAccent)
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(SketchTheme.surfaceCards, in: RoundedRectangle(cornerRadius: 12))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Personality")
                            .font(.system(.title2, design: .serif, weight: .bold))
                            .foregroundStyle(SketchTheme.primaryAccent)

                        Text(character.personality)
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(SketchTheme.secondaryAccent)
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(SketchTheme.surfaceCards, in: RoundedRectangle(cornerRadius: 12))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Relationships")
                            .font(.system(.title2, design: .serif, weight: .bold))
                            .foregroundStyle(SketchTheme.primaryAccent)

                        LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
                            ForEach(character.relationships) { relationship in
                                Text(relationship.relation)
                                    .font(.system(.footnote, design: .rounded, weight: .medium))
                                    .foregroundStyle(SketchTheme.primaryAccent)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(SketchTheme.surfaceCards, in: Capsule())
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }

            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .foregroundStyle(SketchTheme.primaryAccent)
                    .padding(12)
                    .background(.ultraThinMaterial, in: Circle())
                    .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// #Preview {
//     CharacterDescriptionView()
//}
