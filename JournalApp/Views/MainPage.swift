//
import SwiftUI

struct MainPage: View {

    @StateObject private var viewModel = JournalViewModel()

    // UI-only state (presentation of the sheet)
    @State private var showAddJournal = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // MARK: - Header
                HStack {
                    Text("Journal")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)

                    Spacer()

                    HStack(spacing: 20) {

                        // Sort and Filter Menu

                        // Sort Menu
                        Menu {

                            // Sort bookmarked journals first
                            Button {
                                viewModel.sortByBookmark()
                            } label: {
                                Text("Sort by Bookmark")
                            }

                            Divider()

                            // Sort journals by entry date
                            Button {
                                viewModel.sortByDate()
                            } label: {
                                Text("Sort by Entry Date")
                            }

                        } label: {
                            Image(systemName: "line.3.horizontal.decrease")
                                .font(.title3)
                                .foregroundStyle(.white)
                        }
                        Button {
                            viewModel.resetDraft()
                            showAddJournal = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundStyle(.white)
                        }

                    }
                    .padding(.horizontal, 18)
                    .frame(width: 104, height: 48)
                    .glassEffect(.clear, in: Capsule())
                }
                .padding(.horizontal, 20)
                .padding(.top, 15)
                .padding(.bottom, 20)

                // MARK: - Journal Content
                if viewModel.entries.isEmpty {
                    EmptyStateView()
                } else if viewModel.filteredEntries.isEmpty {
                    Spacer()
                    Text("No journals found")
                        .foregroundStyle(.gray)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 14) {
                            ForEach(viewModel.filteredEntries) { entry in
                                JournalCard(
                                    entry: entry,
                                    dateText: viewModel.dateText(for: entry.date),
                                    onBookmarkTap: {
                                        viewModel.toggleBookmark(for: entry)
                                    }
                                )
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        viewModel.confirmDelete(entry)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 15)
                    }
                    .scrollDismissesKeyboard(.interactively)
                }

                Spacer(minLength: 0)

                // MARK: - Search Bar
                SearchBar(searchText: $viewModel.searchText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
            }
            .background(Color.black.ignoresSafeArea())

            // MARK: - Delete Confirmation
            .alert(
                "Delete Journal?",
                isPresented: $viewModel.showDeleteConfirmation
            ) {
                Button("Cancel", role: .cancel) {
                    viewModel.cancelDelete()
                }

                Button("Delete", role: .destructive) {
                    viewModel.deleteEntry()
                }
            } message: {
                Text("Are you sure you want to delete this journal?")
            }

            // MARK: - Add Journal Screen
            .sheet(isPresented: $showAddJournal) {
                AddJournalView(viewModel: viewModel)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

// MARK: - Empty State

struct EmptyStateView: View {

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image("Journal")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 120)

            VStack(spacing: 10) {
                Text("Begin Your Journal")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("Text"))

                Text("Craft your personal diary, tap the plus icon to begin")
                    .font(.body)
                    .foregroundStyle(Color("PrimaryText"))
                    .multilineTextAlignment(.center)
                    .frame(width: 250)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Journal Card

struct JournalCard: View {

    let entry: JournalEntry
    let dateText: String
    let onBookmarkTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Title and Bookmark
            HStack {
                Text(entry.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("Text"))

                Spacer()

                Button(action: onBookmarkTap) {
                    Image(systemName: entry.isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.title3)
                        .foregroundStyle(Color("Text"))
                }
                .buttonStyle(.plain)
            }

            // Date
            Text(dateText)
                .font(.caption)
                .foregroundStyle(.gray)

            // Journal Content
            Text(entry.content)
                .font(.body)
                .foregroundStyle(.white)
                .lineLimit(5)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(Color(red: 0.12, green: 0.12, blue: 0.14))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

// MARK: - Search Bar

struct SearchBar: View {

    @Binding var searchText: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.white.opacity(0.8))
            TextField(
                "",
                text: $searchText,
                prompt: Text("Search").foregroundColor(.gray)
            )
                .foregroundStyle(.white)
                .tint(Color("Text"))

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.white)
                }
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 48)
        .glassEffect(.clear, in: Capsule())
    }
}

#Preview {
    MainPage()
}
