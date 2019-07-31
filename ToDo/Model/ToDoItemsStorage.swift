//
//  ContentView.swift
//  ToDo
//
//  Created by rickb on 6/10/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import Combine
import Foundation

class ToDoItemsStorage {
	let url: URL
	let toDoItems: ToDoItems

	init(url: URL) {
		self.url = url
		do {
			let data = try Data(contentsOf: url)
			toDoItems = ToDoItems(items: try JSONDecoder().decode([ToDoItem].self, from: data))
		} catch {
			toDoItems = ToDoItems()
		}
		_ = toDoItems.willChange.sink { [weak self] in
			self?.save()
		}
	}

	func save() {
		try? (try? JSONEncoder().encode(toDoItems.items))?.write(to: url)
	}
}
