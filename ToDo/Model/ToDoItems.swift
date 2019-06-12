//
//  ToDoItems.swift
//  ToDo
//
//  Created by rickb on 6/10/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import Foundation
import Combine

class ToDoItem: Codable {
	let id: UUID
	var title: String { didSet { didChange.send(()) } }
	var isSelected: Bool { didSet { didChange.send(()) } }
	let didChange = PassthroughSubject<Void, Never>()

	init(id: UUID, title: String, isSelected: Bool) {
		self.id = id
		self.title = title
		self.isSelected = isSelected
	}

	enum CodingKeys: String, CodingKey {
		case id, title, isSelected
	}
}

class ToDoItems {

	private(set) var items: [ToDoItem] = [] {
		didSet {
			didChange.send(())
			listeners.forEach { $0.cancel() }
			items.forEach { item in
				listeners.append(item.didChange.sink { [unowned self] in
					self.set(items: self.items)
				})
			}
		}
	}
	var listeners = [Cancellable]()
	let didChange = PassthroughSubject<Void, Never>()
	
	init(items: [ToDoItem] = []) {
		set(items: items)
	}

	func insert(_ item: ToDoItem) {
		set(items: items + [item])
	}

	func remove(_ item: ToDoItem) {
		items.removeAll { item === $0 }
	}

	private func set(items: [ToDoItem]) {
		self.items = items.stableSorted { a, b in
			if a.isSelected == b.isSelected { return false }
			return (a.isSelected && !b.isSelected)
		}
	}
}
