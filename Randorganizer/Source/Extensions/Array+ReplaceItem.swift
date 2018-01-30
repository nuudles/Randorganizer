//
//  Array+ReplaceItem.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/29/18.
//

import Foundation

extension Array {
	mutating func replaceItem(matching: (Element) -> Bool, afterApplying closure: (inout Element) -> Void) {
		for (index, var item) in enumerated() {
			guard matching(item) else { continue }

			closure(&item)
			self[index] = item
			return
		}
	}
}
