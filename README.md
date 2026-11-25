# Bookido

**Bookido** is an interactive SwiftUI reading companion app that turns reading into a progressive story journey. As you read a book, you unlock story checkpoints by solving spoiler-safe mystery quizzes, discovering characters, collecting event & location cards, and tracking your progress across your personal bookshelf.

---

## Features

* **Onboarding & Starter Library** (`OnBoardingView`, `BookListView`, `ScannerView`)
  * Launches into onboarding on first open or whenever no book is selected.
  * Resumes directly into the active book's journey on subsequent launches.
* **Interactive Reading Journey** (`JourneyView`, `NodeView`, `RotatingUSDZView`)
  * Winding node-by-node progression path with custom 3D-rendered checkpoint medallions (`Assets.xcassets`) and a rotating 3D `gramophone.usdz` model in SceneKit.
  * Locked checkpoints display the chapter where they unlock; solved checkpoints expand to reveal story summaries, unlocked characters, and location icons.
  * Displays an end node (`Finished`) once all checkpoints in a book are unlocked.
* **Mystery Quizzes & Clues** (`MysteryQuizSheet`, `MysteriesView`)
  * Each checkpoint is guarded by a mystery question with optional clues.
  * Answering correctly unlocks the checkpoint, its location, and associated characters.
* **Unlocked Cards (Events & Locations)** (`UnlockedCardsView`)
  * Unified collectible card gallery with a top-right filter menu (**All**, **Event**, **Location**).
  * Full-screen swipeable card carousel with **Share** support (`ImageRenderer` + `ShareLink`) to export any unlocked card as an image.
* **Characters & Relationships** (`CharactersView`, `CharacterDescriptionView`)
  * Grid of met characters alongside locked silhouettes for undiscovered characters.
  * Detailed character profiles with role, first appearance, quote, biography, personality, and relationships.
* **Bookshelf** (`ShelfView`)
  * Grid of books on your shelf with circular progress indicators next to each book title and quick switching between books.

---

## Bundled Catalog (`DataSource/BookData.json`)

The bundled JSON catalog includes three starter books:

1. **The Little Prince** — *Antoine de Saint-Exupéry*
2. **Dracula** — *Bram Stoker*
3. **The Apology of Socrates** — *Plato*

---

## Architecture & Project Structure

```text
Bookido/
├── Bookido/
│   ├── App/
│   │   ├── MyApp.swift                # App entry point
│   │   ├── ContentView.swift          # Root router (Onboarding vs. JourneyView)
│   │   └── AppError.swift             # Centralized error alert handling
│   ├── Views/
│   │   ├── OnBoardingView.swift       # First-launch onboarding
│   │   ├── BookListView.swift         # Starter book picker
│   │   ├── ScannerView.swift          # Book scanner view
│   │   ├── JourneyView.swift          # Main checkpoint progression path
│   │   ├── ShelfView.swift            # My Books shelf with progress circles
│   │   ├── MysteriesView.swift        # Open & solved mysteries
│   │   ├── UnlockedCardsView.swift    # Event & Location cards + filter + Share
│   │   ├── CharactersView.swift       # Character discovery grid
│   │   ├── CharacterDescriptionView.swift
│   │   └── Components/                # Reusable UI cards, nodes, 3D USDZ view, quiz sheet
│   ├── ViewModel/                     # NodeViewModel, BookCardViewModel, BooksViewModel
│   ├── Themes/
│   │   └── SketchTheme.swift          # Colors and theme tokens
│   └── gramophone.usdz                # 3D SceneKit asset
├── Model/
│   ├── Book.swift
│   ├── BookProgress.swift             # Per-book reading progress & unlock timestamps
│   ├── Checkpoint.swift
│   ├── Mystery.swift
│   ├── Location.swift
│   ├── Character.swift
│   └── CharacterRelationship.swift
├── Service/
│   ├── BookDataService.swift          # JSON decoding & UserDefaults progress overlay
│   └── BookStore.swift                # @Observable UI state & reader actions
├── DataSource/
│   └── BookData.json                  # Read-only book catalog
└── Assets.xcassets                    # Checkpoint (_S/_M/_L) & location (_map) artwork
```

---

## Data & Progress Persistence

* **Lightweight Catalog Loading**: `BookDataService.loadBooks()` decodes book metadata from `DataSource/BookData.json` without parsing nested checkpoints or characters.
* **On-Demand Hydration**: Full checkpoints and characters are decoded only for a selected or shelf book via `BookDataService.loadDetails(for:)`.
* **Separated User Progress**: User state (`selectedBookId`, `shelfBookIds`, and per-book `BookProgress` containing `currentChapter`, `unlockedCheckpoints`, and `mysteryAnswers`) is persisted in `UserDefaults` and overlaid onto the JSON catalog at runtime so catalog updates never overwrite reader progress.

---

## Getting Started

1. Open `Bookido.xcodeproj` in **Xcode**.
2. Select the **Bookido** scheme and an iOS Simulator or connected device.
3. Build and run (`Cmd + R`).
