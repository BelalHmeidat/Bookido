//
//  MysteryQuizSheet.swift
//  Bookido
//
//  Created by Belal Hmeidat on 25/11/2026.
//

import SwiftUI

/// Pop-up sheet presenting the mystery quiz to unlock the next checkpoint.
struct MysteryQuizSheet: View {
    let viewModel: NodeViewModel
    var onUnlocked: (() -> Void)? = nil

    @Environment(BookStore.self) private var bookStore: BookStore
    @Environment(\.dismiss) private var dismiss

    @State private var selectedOptionIndex: Int? = nil
    @State private var isAnswered: Bool = false
    @State private var isCorrect: Bool = false
    @State private var showClue: Bool = false

    private var mystery: Mystery {
        viewModel.mystery
    }

    var body: some View {
        NavigationStack {
            ZStack {
                SketchTheme.mainBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        VStack(spacing: 8) {
                            Image(systemName: "magnifyingglass.circle.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(SketchTheme.primaryAccent)

                            Text("Answer the Mystery")
                                .font(.system(.title2, design: .serif, weight: .bold))
                                .foregroundStyle(SketchTheme.primaryAccent)

                            Text(viewModel.title)
                                .font(.system(.subheadline, design: .rounded, weight: .medium))
                                .foregroundStyle(SketchTheme.accentBlue)
                        }
                        .padding(.top, 16)

                        // Question card
                        VStack(alignment: .leading, spacing: 12) {
                            Text(mystery.question)
                                .font(.system(.headline, design: .serif, weight: .bold))
                                .foregroundStyle(SketchTheme.primaryAccent)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            SketchTheme.surfaceCards,
                            in: RoundedRectangle(cornerRadius: 16)
                        )
                        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)

                        // Options
                        VStack(spacing: 12) {
                            ForEach(Array(mystery.options.enumerated()), id: \.offset) { index, option in
                                Button {
                                    handleSelectOption(index)
                                } label: {
                                    HStack(spacing: 12) {
                                        Text(option)
                                            .font(.system(.callout, design: .rounded, weight: .semibold))
                                            .foregroundStyle(optionTextColor(for: index))
                                            .multilineTextAlignment(.leading)
                                            .fixedSize(horizontal: false, vertical: true)

                                        Spacer()

                                        if isAnswered && selectedOptionIndex == index {
                                            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                                .font(.headline)
                                                .foregroundStyle(isCorrect ? .green : .red)
                                        }
                                    }
                                    .padding(14)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        optionBackgroundColor(for: index),
                                        in: RoundedRectangle(cornerRadius: 12)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(optionBorderColor(for: index), lineWidth: 1.5)
                                    )
                                }
                                .buttonStyle(.plain)
                                .disabled(isAnswered && isCorrect)
                            }
                        }

                        // Feedback & Clues
                        if isAnswered {
                            if isCorrect {
                                VStack(spacing: 8) {
                                    Text("🎉 Checkpoint Unlocked!")
                                        .font(.system(.headline, design: .rounded, weight: .bold))
                                        .foregroundStyle(SketchTheme.primaryAccent)

                                    Text("Great job! You solved the mystery.")
                                        .font(.system(.subheadline, design: .rounded))
                                        .foregroundStyle(SketchTheme.secondaryAccent)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    SketchTheme.surfaceCards,
                                    in: RoundedRectangle(cornerRadius: 12)
                                )
                            } else {
                                VStack(spacing: 10) {
                                    Text("Not quite right. Try again!")
                                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                        .foregroundStyle(.red)

                                    if !mystery.clues.isEmpty {
                                        Button {
                                            withAnimation {
                                                showClue.toggle()
                                            }
                                        } label: {
                                            Label(showClue ? "Hide Clue" : "Show Clue", systemImage: "lightbulb.fill")
                                                .font(.system(.caption, design: .rounded, weight: .semibold))
                                                .foregroundStyle(SketchTheme.accentBlue)
                                        }

                                        if showClue, let firstClue = mystery.clues.first {
                                            Text(firstClue)
                                                .font(.system(.footnote, design: .rounded, weight: .regular))
                                                .foregroundStyle(SketchTheme.secondaryAccent)
                                                .multilineTextAlignment(.center)
                                                .padding(.horizontal)
                                        }
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .foregroundStyle(SketchTheme.primaryAccent)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func handleSelectOption(_ index: Int) {
        selectedOptionIndex = index
        let correct = (index == mystery.answerIndex)
        isCorrect = correct
        isAnswered = true

        if correct {
            if let bookId = viewModel.bookId ?? bookStore.selectedBookId {
                try? bookStore.answerMystery(
                    bookId: bookId,
                    checkpointId: viewModel.id,
                    selectedOptionIndex: index
                )
            }
            onUnlocked?()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                dismiss()
            }
        }
    }

    private func optionTextColor(for index: Int) -> Color {
        if isAnswered && selectedOptionIndex == index {
            return isCorrect ? SketchTheme.primaryAccent : .red
        }
        return SketchTheme.primaryAccent
    }

    private func optionBackgroundColor(for index: Int) -> Color {
        if isAnswered && selectedOptionIndex == index {
            return isCorrect ? SketchTheme.surfaceCards : Color.red.opacity(0.1)
        }
        return SketchTheme.surfaceCards
    }

    private func optionBorderColor(for index: Int) -> Color {
        if isAnswered && selectedOptionIndex == index {
            return isCorrect ? SketchTheme.primaryAccent : .red
        }
        return SketchTheme.accentBlue.opacity(0.3)
    }
}
