import SwiftUI
import Combine

enum JournalSortOption {
    case bookmark
    case date
}

class JournalViewModel: ObservableObject {

    // MARK: - Entries

    @Published var entries: [JournalEntry] = []

    // MARK: - Search & Sort

    @Published var searchText = ""
    @Published var sortOption: JournalSortOption = .date

    // MARK: - Delete Confirmation

    @Published var showDeleteConfirmation = false
    @Published var selectedEntryID: UUID?

    // MARK: - Add Journal Draft (used by AddJournalView)

    @Published var draftTitle = ""
    @Published var draftContent = ""
    @Published var showDiscardConfirmation = false

    // MARK: - Filter and Sort

    var filteredEntries: [JournalEntry] {
        var result = entries

        // Search journals
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.content.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Show only bookmarked journals
        if sortOption == .bookmark {
            result = result.filter { $0.isBookmarked }
        }

        // Sort by date when selected
        if sortOption == .date {
            result.sort { $0.date > $1.date }
        }

        return result
    }

    // MARK: - Sort Actions

    func showBookmarked() {
        sortOption = .bookmark
    }

    func sortByDate() {
        sortOption = .date
    }

    // MARK: - Date Formatting

    /// Date shown on the Add Journal screen (today's date)
    var todayDateText: String {
        Date.now.formatted(
            .dateTime
                .day(.twoDigits)
                .month(.twoDigits)
                .year()
        )
    }

    /// Date shown on each journal card
    func dateText(for date: Date) -> String {
        date.formatted(date: .numeric, time: .omitted)
    }

    // MARK: - Bookmark

    func toggleBookmark(for entry: JournalEntry) {
        guard let index = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[index].isBookmarked.toggle()
    }

    // MARK: - Delete

    func confirmDelete(_ entry: JournalEntry) {
        selectedEntryID = entry.id
        showDeleteConfirmation = true
    }

    func cancelDelete() {
        selectedEntryID = nil
    }

    func deleteEntry() {
        guard let id = selectedEntryID else { return }
        entries.removeAll { $0.id == id }
        selectedEntryID = nil
    }

    // MARK: - Add Journal

    func addEntry(title: String, content: String) {
        let newEntry = JournalEntry(
            title: title,
            date: Date(),
            content: content,
            isBookmarked: false
        )
        entries.insert(newEntry, at: 0)
    }

    // MARK: - Draft Logic

    /// Call before presenting the Add Journal screen
    func resetDraft() {
        draftTitle = ""
        draftContent = ""
        showDiscardConfirmation = false
    }

    var hasUnsavedChanges: Bool {
        !draftTitle.isEmpty || !draftContent.isEmpty
    }

    /// Returns true if the screen can be dismissed right away.
    /// Otherwise it asks for discard confirmation and returns false.
    func requestClose() -> Bool {
        if hasUnsavedChanges {
            showDiscardConfirmation = true
            return false
        }
        return true
    }

    /// Validates and saves the draft. Returns true if saved successfully.
    func saveDraft() -> Bool {
        let trimmedTitle = draftTitle.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else { return false }

        addEntry(title: trimmedTitle, content: draftContent)
        resetDraft()
        return true
    }
}
