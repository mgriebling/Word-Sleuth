//
//  StringList.swift
//  Word Hunt
//
//  Created by Michael Griebling on 23.06.2026.
//

import SwiftUI

struct ListItem: Identifiable, Hashable {
	let id: UUID
	var title: String
	
	init(_ title: String) {
		self.id = UUID()
		self.title = title
	}
}

struct StringList: View {
	let title: String
	@Binding var strings: [String]
	
	// MARK: Data (Function) In
	@Environment(\.dismiss) var dismiss
	
	@State private var lstrings = [ListItem]()
	@State private var selectedItems = Set<UUID>()
	@State private var showConfirmation: Bool = false
	#if !os(macOS)
	@State private var editMode: EditMode = .inactive
	#endif
	
	var body: some View {
		NavigationStack {
			List(selection: $selectedItems) {
				ForEach($lstrings) { $item in
					PersistentTextField("Edit Word", text: $item.title)
						.textEditorStyle(.plain)
						.showClearButton($item.title)
						.autocorrectionDisabled(true)
						.onChange(of: item.title) { _, newValue in
							let s = newValue.filter { $0.isLetter }
							if s != newValue {
								item.title = s.capitalized
							}
						}
						.padding()
						.frame(minWidth: 200)
						.textFieldStyle(.plain)
						.background(Color(.systemGray4), in: RoundedRectangle(cornerRadius: 12))
				}
				.listRowInsets(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
				.listRowBackground(
					RoundedRectangle(cornerRadius: 12, style: .continuous)
						.fill(.clear)
				)
				.flexibleSystemFont(maximum: 20)
			}
			.onAppear {
				lstrings = strings.sorted().map { ListItem($0) }
			}
			.navigationTitle("\(title) Words")
			.listStyle(.plain)
			#if !os(macOS)
			.navigationBarTitleDisplayMode(.inline)
			.environment(\.editMode, $editMode)
			.toolbar {
				editButton
				addDelButton
			}
			#endif
		}
	}
	
#if os(iOS)
	private var editButton: some ToolbarContent {
		ToolbarItemGroup(placement: .topBarLeading) {
			Button(action: { dismiss() }) {
				Image(systemName: "xmark")
			}
			.tint(Color(.systemGreen))
			Button(action: {
				self.editMode.toggle()
				self.selectedItems = Set<UUID>()
			}) {
				Text(self.editMode.title)
					.foregroundStyle(Color.accentColor)
			}
		}
	}

	@ToolbarContentBuilder
	private var addDelButton: some ToolbarContent {
		if editMode == .inactive {
			ToolbarItemGroup(placement: .topBarTrailing) {
				Button(action: addItem) {
					Image(systemName: "plus")
				}
				.tint(.accentColor)
				Button(action: done) {
					Image(systemName: "checkmark")
				}
				.tint(Color(.systemRed))
			}
	
		} else {
			ToolbarItemGroup(placement: .topBarTrailing) {
				Button {
					showConfirmation = true
				} label: {
					Image(systemName: "trash")
				}
				.tint(.red)
				.disabled(selectedItems.isEmpty)
				.confirmationDialog("Delete Words", isPresented: $showConfirmation) {
					Button("Delete Words", role: .destructive) {
						deleteItems()
					}
				} message: {
					Text("The words will be permanently deleted.")
				}
			}
		}
	}
#endif
	
	private func deleteItems() {
		for id in selectedItems {
			if let index = lstrings.lastIndex(where: { $0.id == id }) {
				// underscore silences a warning about ignoring return value
				_ = withAnimation {
					lstrings.remove(at: index)
				}
				strings.remove(at: index)
			}
		}
		selectedItems = Set<UUID>()
	}
		
	fileprivate func addItem() {
		let itemName = "untitled"
		withAnimation {
			lstrings.insert(ListItem(itemName), at: 0)
		}
		strings.insert(itemName, at: 0)
	}
	
	func done() {
		strings = lstrings.map(\.title.capitalized).sorted()
		dismiss()
	}
}

#if !os(macOS)
extension EditMode {
	var title: String {
		self == .active ? "Done" : "Edit"
	}

	mutating func toggle() {
		self = self == .active ? .inactive : .active
	}
}
#endif

#Preview {
	@Previewable @State var strings = SampleWordLists.all[0].words
	StringList(title: SampleWordLists.all[0].name, strings: $strings)
}
