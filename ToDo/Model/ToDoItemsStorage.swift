//
//  ContentView.swift
//  ToDo
//
//  Created by rickb on 6/10/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class ToDoItemsStorage {
	let url: URL
	@ObservedObject var toDoItems: ToDoItems {
		didSet {
			save()
		}
	}
	var subscription: AnyCancellable!
	init(url: URL) {
		self.url = url
		do {
			let data = try Data(contentsOf: url)
			toDoItems = ToDoItems(items: try JSONDecoder().decode([ToDoItem].self, from: data))
		} catch {
			toDoItems = ToDoItems()
		}
		self.subscription = toDoItems.objectWillChange.sink { [weak self] in
			self?.save()
		}
	}

	func save() {
		try? (try? JSONEncoder().encode(toDoItems.items))?.write(to: url)
	}
}
