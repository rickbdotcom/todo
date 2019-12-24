//
//  ToDoItemsListView.swift
//  ToDo
//
//  Created by rickb on 6/10/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import SwiftUI
import UIKit

struct ToDoItemsListView : View {

	static func controller(toDoItems: ToDoItems) -> UIViewController {
		return UIHostingController(rootView: ToDoItemsListView(toDoItems: toDoItems))
	}

	@ObservedObject var toDoItems: ToDoItems
	@State var showingInput: Bool = false
	@State var editingItem: ToDoItem?
	@State var inputText: String = ""

	var body: some View {
		ZStack(alignment: .top) {
			NavigationView {
				List(toDoItems.items) { item in
					HStack {
						ToDoItemRow(toDoItem: item)
						Spacer()
// There's a bug(?) where all the actions of Button in a list view row are called when tapping on row, so we make the delete button a regular UIButton
						UIButtonView(action: {
							self.toDoItems.remove(item)
						}) {
							$0.setTitle(NSLocalizedString("Delete", comment: ""), for: .normal)
							$0.setTitleColor(.red, for: .normal)
					   }
					   .fixedSize()
					}
					.onTapGesture(count: 2) {
						self.editingItem = item
						self.inputText = item.title
						self.showingInput = true
					}
				}
				.navigationBarTitle(Text("Items"), displayMode: .inline)
				.navigationBarItems(trailing: Button(action: {
					self.showingInput.toggle()
				}) { Text("Add") })
			}
			if showingInput {
// Doesn't currently appear to be anyway to make first responder, would need to switch this to a UITextField
//				TextField($inputText) {
				UITextFieldView($inputText, configure: {
					$0.becomeFirstResponder()
				}) {
					if self.inputText.isEmpty == false {
						if let editingItem = self.editingItem {
							editingItem.title = self.inputText
						} else {
							let newItem = ToDoItem(id: UUID(), title: self.inputText, isSelected: true)
							self.toDoItems.insert(newItem)
						}
					}
					self.showingInput = false
					self.inputText = ""
					self.editingItem = nil
				}
				.frame(height: 44.0)
				.background(Rectangle().foregroundColor(.gray))
				.textFieldStyle(RoundedBorderTextFieldStyle())
			}
		}
	}
}

struct ToDoItemRow: View {
	@ObservedObject var toDoItem: ToDoItem

	var body: some View {
		Button(action: {
			self.toDoItem.isSelected.toggle()
		}) {
			HStack {
				Image(systemName: toDoItem.isSelected ? "star.fill" : "star")
				Text(toDoItem.title)
			}
		}
	}
}

#if DEBUG
struct ToDoItemsListView_Previews : PreviewProvider {
	static var previews: some View {
		ToDoItemsListView(toDoItems: ToDoItems(items: [
			ToDoItem(id: UUID(), title: "Hello", isSelected: false),
			ToDoItem(id: UUID(), title: "Goodbye", isSelected: true)
		]))
	}
}
#endif
