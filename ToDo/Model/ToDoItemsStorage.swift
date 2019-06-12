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
	var listener: Cancellable!

	init(url: URL) {
		self.url = url
		do {
			let data = try Data(contentsOf: url)
			toDoItems = try JSONDecoder().decode(ToDoItems.self, from: data)
		} catch {
			toDoItems = ToDoItems()
		}
		self.listener = toDoItems.didChange.sink { [weak self] in
			self?.save()
		}
	}

	deinit {
		self.listener.cancel()
	}

	func save() {
		try? (try? JSONEncoder().encode(toDoItems))?.write(to: url)
	}
}
