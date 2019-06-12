//
//  SceneDelegate.swift
//  ToDo
//
//  Created by rickb on 6/10/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		let window = UIWindow(frame: UIScreen.main.bounds)
		window.rootViewController = ToDoItemsListView.controller(toDoItems: toDoItemsStorage.toDoItems)
		self.window = window
		window.makeKeyAndVisible()
	}
}
