# 📖 Journali

*A simple space to capture your thoughts and memories.*

---

## 📝 About

Journali is a personal journaling app designed to make capturing and organizing everyday thoughts and memories simple and enjoyable.

Users can create journal entries, search for specific moments, and bookmark important entries to easily revisit them whenever they want.

## ✨ Features

- **Create Entries:** Write new journal entries to capture your thoughts and experiences.
- **Delete Entries:** Remove entries you no longer need.
- **Search:** Find specific words or phrases within your entries.
- **Sort & Filter:** Organize entries by bookmark or entry date.

## 🏗️ App Structure (MVVM)

Journali follows the **Model-View-ViewModel (MVVM)** architecture to keep the code organized and separate the user interface from the app's logic.

```text
Journali/
│
├── Models/
│   └── JournalEntry.swift
│
├── ViewModels/
│   └── JournalViewModel.swift
│
├── Views/
│   ├── SplashScreen.swift
│   ├── MainPage.swift
│   └── AddJournalView.swift
│
└── MyApp.swift
```

### How MVVM Works in Journali

| Component | Responsibility |
|---|---|
| **Model** | Represents journal entry data. |
| **View** | Displays the app interface and allows users to interact with it. |
| **ViewModel** | Handles app logic, manages journal entries, and updates the View when data changes. |

## 🛠️ Technologies Used

- **Swift:** Programming language.
- **SwiftUI:** Framework used to build the user interface.
- **Xcode:** Development environment.

## 🚀 How to Run

1. Clone this repository.
2. Open the `.xcodeproj` file in Xcode.
3. Select an iOS Simulator or connect your iPhone.
4. Press the **Run (▶)** button to launch the app.
