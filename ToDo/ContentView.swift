//
//  ContentView.swift
//  ToDo
//
//  Created by rickb on 6/10/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView : View {
	@ObjectBinding var toDoItems: ToDoItems

	var body: some View {
		List(toDoItems.items) {
			ToDoItemRow(toDoItem: $0)
		}
	}
}

struct ToDoItemRow: View {
	@State var toDoItem: ToDoItem

	var body: some View {
		Button(action: {
			self.toDoItem.isSelected.toggle()
		}) {
			HStack {
				if toDoItem.isSelected {
					Image(systemName: "star.fill")
				} else {
					Image(systemName: "star")
				}
				Text(toDoItem.title)
			}
		}
	}
}

class ToDoItem: Identifiable, BindableObject {
	let id: UUID
	let title: String
	var isSelected: Bool {
		didSet {
			didChange.send(())
		}
	}
	let didChange = PassthroughSubject<Void, Never>()

	init(id: UUID, title: String, isSelected: Bool) {
		self.id = id
		self.title = title
		self.isSelected = isSelected
	}
}

class ToDoItems: BindableObject {

	var items: [ToDoItem] = [] {
		didSet {
			didChange.send(())
			items.forEach { item in
				listeners.append(item.didChange.sink { [weak self] in
					self?.reorderItems()
				})
			}
		}
	}
	private var listeners = [Cancellable]()

	let didChange = PassthroughSubject<Void, Never>()

	private func reorderItems() {
		self.items = items.stableSorted { a, b in
			if a.isSelected == b.isSelected { return false }
			return (a.isSelected && !b.isSelected)
		}
	}
}

extension Sequence {
	func stableSorted( by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> [Element] {
		return try enumerated().sorted { a, b -> Bool in
			try areInIncreasingOrder(a.element, b.element) || (a.offset < b.offset && !areInIncreasingOrder(b.element, a.element))
		}.map { $0.element }
	}
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
	static var previews: some View {
		let items = [
			ToDoItem(id: UUID(), title: "Hello", isSelected: false),
			ToDoItem(id: UUID(), title: "Goodbye", isSelected: false)
		]
		let toDoItems = ToDoItems()
		toDoItems.items = items
		return ContentView(toDoItems: toDoItems)
	}
}
#endif
