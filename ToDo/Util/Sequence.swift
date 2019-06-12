//
//  Sequence.swift
//  ToDo
//
//  Created by rickb on 6/10/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import Foundation

extension Sequence {

	func stableSorted( by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> [Element] {
		return try enumerated().sorted { a, b -> Bool in
			try areInIncreasingOrder(a.element, b.element) || (a.offset < b.offset && !areInIncreasingOrder(b.element, a.element))
		}.map { $0.element }
	}
}
