//
//  ToDoItems.swift
//  ToDo
//
//  Created by rickb on 6/10/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ToDoItem: Codable, ObservableObject, Identifiable {
	let id: UUID
	@Published var title: String { didSet { objectDidChange.send(()) } }
	@Published var isSelected: Bool { didSet { objectDidChange.send(()) } }
	let objectDidChange = PassthroughSubject<Void, Never>()

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decode(UUID.self, forKey: .id)
		title = try values.decode(String.self, forKey: .title)
		isSelected = try values.decode(Bool.self, forKey: .isSelected)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(title, forKey: .title)
		try container.encode(isSelected, forKey: .isSelected)
	}

	init(id: UUID, title: String, isSelected: Bool) {
		self.id = id
		self.title = title
		self.isSelected = isSelected
	}

	enum CodingKeys: String, CodingKey {
		case id, title, isSelected
	}
}

class ToDoItems: ObservableObject {

	@Published private(set) var items: [ToDoItem] = [] {
		didSet {
			subscriptions.forEach { $0.cancel() }
			items.forEach { item in
				subscriptions.append(item.objectDidChange.sink { [weak self] in
					if let self = self {
						self.set(items: self.items)
					}
				})
			}
		}
	}
	var subscriptions = [Cancellable]()
	
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
