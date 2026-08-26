//
//  WordList.swift
//  Word Hunt
//
//  Created by Michael Griebling on 23.06.2026.
//

import SwiftUI

struct WordListView: View {
	// MARK: Data Shared with Me
	@Binding var selection: WordList?
	
	@Environment(DataContainer.self) private var dataContainer
	
	@State private var wordListToEdit: WordList? = WordList()
	@State private var showWordListEditor: Bool = false
	
	var body: some View {
		let colors = [Color.red.opacity(0.5), Color.red.opacity(0.2)]
		
		List(selection: $selection) {
			ForEach(dataContainer.wordLists, id: \.self) { wordList in
				NavigationLink(value: wordList) {
					WordListSummary(wordList: wordList)
						.tag(wordList)
				}
				.selectionDisabled(true)
				.foregroundStyle(Color.primary)
				.listRowBackground(
					RoundedRectangle(cornerRadius: 20)
						.fill(
							selection == wordList ? LinearGradient(colors: colors, startPoint: .bottom, endPoint: .top) : LinearGradient(colors: [.clear, .clear], startPoint: .bottom, endPoint: .top)
						)
				)
			}
			.onDelete { indexSet in
				indexSet.forEach { index in
					dataContainer.wordLists.remove(at: index)
				}
			}
			.onMove { offsets, destination in
				dataContainer.wordLists.move(fromOffsets: offsets, toOffset: destination)
			}
		}
		.listStyle(.sidebar)
		.toolbar {
			addButton
		}
	}
		
	func editButton(for wordList: WordList) -> some View {
		Button("Edit", systemImage: "pencil") {
			if let selection {
				wordListToEdit = selection.copy()
				showWordListEditor.toggle()
			}
		}
	}
	
	func deleteButton(for wordList: WordList) -> some View {
		Button("Delete", systemImage: "minus.circle", role: .destructive) {
			withAnimation {
				dataContainer.wordLists.removeAll { $0 == wordList }
			}
		}
	}
	
	func uniqueName(for name: String) -> String {
		var number = 0
		while number < 100 {
			let name = name + (number > 0 ? " \(number)" : "")
			if !dataContainer.wordLists.contains(where: { $0.name == name }) {
				return name
			} else {
				// increment number and try again
				number += 1
			}
		}
		return ""
	}
	
	var addButton: some View {
		Button("Add Word List", systemImage: "plus") {
			let name = uniqueName(for: "Random")
			wordListToEdit = WordList(name: name, wordRange: 3...7, totalWords: 60)
			showWordListEditor = true
		}
		.sheet(isPresented: $showWordListEditor) {
			WordsEditor(words: $wordListToEdit) {
				if let index = dataContainer.wordLists.firstIndex(of: wordListToEdit!) {
					// word list already exists
					dataContainer.wordLists[index] = wordListToEdit!
				} else {
					// add new word list
					dataContainer.wordLists.insert(wordListToEdit!, at: 0)
				}
			}
		}
	}
}

#Preview {
	@Previewable @State var selection: WordList? = nil
	NavigationStack {
		WordListView(selection: $selection)
			.environment(DataContainer())
	}
}
