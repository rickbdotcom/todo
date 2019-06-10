//
//  ContentView.swift
//  ToDo
//
//  Created by rickb on 6/10/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import SwiftUI

struct ContentView : View {
	let toDoItems: [ToDoItem]

	var body: some View {
		List(toDoItems) {
			ToDoItemRow(toDoItem: $0)
		}
	}
}

struct ToDoItemRow: View {
	let toDoItem: ToDoItem

	var body: some View {
		HStack {
			if toDoItem.selected {
				Image(systemName: "star.fill")
			} else {
				Image(systemName: "star")
			}
			Text(toDoItem.title)
		}
	}
}

class ToDoItem: Encodable, Identifiable {
	let id: UUID
	let title: String
	var selected: Bool

	init(id: UUID, title: String, selected: Bool) {
		self.id = id
		self.title = title
		self.selected = selected
	}
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
	static var previews: some View {
		ContentView(toDoItems: [
			ToDoItem(id: UUID(), title: "Hello", selected: true)
		])
	}
}
#endif
