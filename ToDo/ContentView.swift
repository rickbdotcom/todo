//
//  ContentView.swift
//  ToDo
//
//  Created by rickb on 6/10/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import UIKit
import SwiftUI
import Combine
import ExtraKit

struct ContentView : View {
	@ObjectBinding var toDoItems: ToDoItems
	@State var showingInput: Bool = false
	@State var inputText: String = ""

	var body: some View {
		NavigationView {
			ZStack {
				List(toDoItems.items) { item in
					HStack {
						ToDoItemRow(toDoItem: item)
						Spacer()
						UIButtonView(action: {
							self.toDoItems.items.removeAll { $0 === item }
						}) {
							$0.setTitle(NSLocalizedString("Delete", comment: ""), for: .normal)
							$0.setTitleColor(.red, for: .normal)
					   }
					}
				}
				.navigationBarTitle(Text("Items"), displayMode: .inline)
				.navigationBarItems(trailing: Button(action: {
					self.showingInput.toggle()
				}) { Text("Add") })

				if showingInput {
					TextField($inputText) {
						let newItem = ToDoItem(id: UUID(), title: self.inputText, isSelected: true)
						self.toDoItems.items.append(newItem)
						self.toDoItems.reorderItems()
						self.showingInput = false
						self.inputText = ""
					}.textFieldStyle(.roundedBorder)
				}
			}
		}
	}
}

struct UIButtonView: UIViewRepresentable {

	let button = UIButton()

	init(action: @escaping () -> Void, label: (UIButton) -> Void) {
		button.on(.touchUpInside) { _ in
			action()
		}
		label(button)
	}

    func makeUIView(context: Context) -> UIButton {
		return button
	}

	func updateUIView(_ uiView: UIButton, context: Context) {
	}
}

struct UIKitView<T: UIView>: UIViewRepresentable {
	let view: T

    func makeUIView(context: Context) -> T {
		return view
	}

	func updateUIView(_ uiView: T, context: Context) {
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

class ToDoItem: Identifiable, BindableObject, Codable {
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

	enum CodingKeys: String, CodingKey {
		case id, title, isSelected
	}
}

class ToDoItems: BindableObject, Codable {

	enum CodingKeys: String, CodingKey {
		case items
	}

	var items: [ToDoItem] = [] {
		didSet {
			didChange.send(())
			listeners.forEach { $0.cancel() }
			items.forEach { item in
				listeners.append(item.didChange.sink { [weak self] in
					self?.reorderItems()
				})
			}
		}
	}
	var listeners = [Cancellable]()
	let didChange = PassthroughSubject<Void, Never>()

	func reorderItems() {
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
