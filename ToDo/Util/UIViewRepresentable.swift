//
//  UIViewRepresentable.swift
//  ToDo
//
//  Created by rickb on 6/10/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import SwiftUI
import ExtraKit

/// Needed this because of bug(?) with Button when inside a list row
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

/// Bug in TextField commit now in beta 2
struct UITextFieldView: UIViewRepresentable {

	let textField: UITextField

	init(_ inputText: Binding<String>, configure: ((UITextField) -> Void)? = nil, commit: @escaping () -> Void) {
		textField = UITextField()
		textField.on(.editingChanged) { (textField: UITextField) in
			inputText.value = textField.text ?? ""
		}
		textField.on(.editingDidEndOnExit) { _ in
			commit()
		}
		configure?(textField)
	}

    func makeUIView(context: Context) -> UITextField {
		return textField
	}

	func updateUIView(_ uiView: UITextField, context: Context) {
	}
}

/// idea for generic UIViewRepresentable wrapper
struct UIKitView<T: UIView>: UIViewRepresentable {
	let view: T

    func makeUIView(context: Context) -> T {
		return view
	}

	func updateUIView(_ uiView: T, context: Context) {
	}
}

