//
import SwiftUI

struct AddJournalView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: JournalViewModel
    @FocusState private var focusedField: Field?

    private enum Field {
        case title
        case content
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {

                // MARK: - Top Buttons
                HStack {
                    Button {
                        if viewModel.requestClose() {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .glassEffect(.clear, in: Circle())
                    }

                    Spacer()

                    Button {
                        if viewModel.saveDraft() {
                            dismiss()
                        } else {
                            focusedField = .title
                        }
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundStyle(.black)
                            .frame(width: 44, height: 44)
                            .glassEffect(.regular.tint(Color("Primary")), in: Circle())
                    }
                }
                .padding(.bottom, 12)

                // MARK: - Title
                TextField(
                    "",
                    text: $viewModel.draftTitle,
                    prompt: Text("Title")
                        .foregroundColor(.gray.opacity(0.55))
                )
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(.white)
                .tint(Color(red: 0.53, green: 0.49, blue: 1.0))
                .focused($focusedField, equals: .title)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .content
                }

                // MARK: - Date
                Text(viewModel.todayDateText)
                    .font(.system(size: 16))
                    .foregroundStyle(.gray)
                    .padding(.top, 8)

                // MARK: - Journal Content
                ZStack(alignment: .topLeading) {
                    if viewModel.draftContent.isEmpty {
                        Text("Type your Journal...")
                            .font(.system(size: 20))
                            .foregroundStyle(.gray.opacity(0.55))
                            .padding(.top, 8)
                            .padding(.leading, 5)
                    }

                    TextEditor(text: $viewModel.draftContent)
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .scrollContentBackground(.hidden)
                        .tint(Color(red: 0.53, green: 0.49, blue: 1.0))
                        .focused($focusedField, equals: .content)
                }
                .padding(.top, 22)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.11, green: 0.11, blue: 0.12))
            .toolbar(.hidden, for: .navigationBar)
            .alert(
                "Are you sure you want to discard changes on this journal?",
                isPresented: $viewModel.showDiscardConfirmation
            ) {
                Button("Discard Changes", role: .destructive) {
                    viewModel.resetDraft()
                    dismiss()
                }

                Button("Keep Editing", role: .cancel) {
                    // Stay on the journal screen
                }
            }
        }
//        .preferredColorScheme(.dark)
        .task {
            focusedField = .title
        }
    }
}

#Preview {
    AddJournalView(viewModel: JournalViewModel())
}
