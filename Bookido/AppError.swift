//
//  AppError.swift
//  Bookido
//
//  Created by Belal Hmeidat on 23/11/2026.
//

import Foundation
import SwiftUI

/// Represents a standardized application error with user-facing title and description.
public struct AppError: Identifiable, Sendable, Equatable {
    public let id: UUID
    public let title: String
    public let message: String

    public init(id: UUID = UUID(), title: String, message: String) {
        self.id = id
        self.title = title
        self.message = message
    }

    /// Convenience initializer from any Swift `Error`.
    public init(error: any Error, defaultTitle: String = "Something went wrong") {
        self.id = UUID()
        if let localized = error as? LocalizedError {
            self.title = localized.errorDescription ?? defaultTitle
            self.message = localized.recoverySuggestion
                ?? localized.failureReason
                ?? error.localizedDescription
        } else {
            self.title = defaultTitle
            self.message = error.localizedDescription
        }
    }
}

/// Central observable manager for triggering error pop-ups across the application.
@Observable
public final class ErrorManager: @unchecked Sendable {
    public static let shared = ErrorManager()

    /// The currently active error to be displayed in an alert/pop-up.
    public var currentError: AppError?

    public init() {}

    /// Presents an error pop-up with a custom title and message.
    public func handle(title: String, message: String) {
        Task { @MainActor in
            self.currentError = AppError(title: title, message: message)
        }
    }

    /// Presents an error pop-up from any Swift `Error`.
    public func handle(_ error: any Error, defaultTitle: String = "Error") {
        Task { @MainActor in
            self.currentError = AppError(error: error, defaultTitle: defaultTitle)
        }
    }

    /// Dismisses the currently displayed error.
    public func dismiss() {
        Task { @MainActor in
            self.currentError = nil
        }
    }
}

// MARK: - SwiftUI View Modifier & Environment Key

private struct ErrorManagerKey: EnvironmentKey {
    static let defaultValue: ErrorManager = .shared
}

extension EnvironmentValues {
    public var errorManager: ErrorManager {
        get { self[ErrorManagerKey.self] }
        set { self[ErrorManagerKey.self] = newValue }
    }
}

/// ViewModifier that presents an alert pop-up whenever `ErrorManager.currentError` is set.
struct ErrorAlertModifier: ViewModifier {
    @Bindable var errorManager: ErrorManager

    func body(content: Content) -> some View {
        content
            .alert(
                errorManager.currentError?.title ?? "Error",
                isPresented: Binding(
                    get: { errorManager.currentError != nil },
                    set: { if !$0 { errorManager.dismiss() } }
                ),
                presenting: errorManager.currentError
            ) { _ in
                Button("OK", role: .cancel) {
                    errorManager.dismiss()
                }
            } message: { appError in
                Text(appError.message)
            }
    }
}

extension View {
    /// Catches and displays error pop-ups managed by the provided `ErrorManager`.
    public func withErrorAlert(manager: ErrorManager = .shared) -> some View {
        self.modifier(ErrorAlertModifier(errorManager: manager))
            .environment(\.errorManager, manager)
    }
}
