import Foundation
struct JournalEntry: Identifiable {
    let id = UUID()
    var title: String
    var date: Date
    var content: String
    var isBookmarked: Bool
}
