//
//  SceneDelegate.swift
//  ToDo
//
//  Created by rickb on 6/10/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		let window = UIWindow(frame: UIScreen.main.bounds)

		let items = [
			ToDoItem(id: UUID(), title: "Hello", isSelected: false),
			ToDoItem(id: UUID(), title: "Goodbye", isSelected: false)
		]
		let toDoItems = ToDoItems()
		toDoItems.items = items

		window.rootViewController = UIHostingController(rootView: ContentView(toDoItems: toDoItems))
		self.window = window
		window.makeKeyAndVisible()
	}
}
