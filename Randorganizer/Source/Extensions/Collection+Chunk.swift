//
//  Collection+Chunk.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/25/18.
//

import Foundation

// This code is borrowed from: https://stackoverflow.com/questions/26395766/swift-what-is-the-right-way-to-split-up-a-string-resulting-in-a-string-wi/38156873#38156873
extension Collection {
	func chunked(by distance: IndexDistance) -> [[Element]] {
		precondition(distance > 0, "distance must be greater than 0") // prevents infinite loop

		var index = startIndex
		let iterator: AnyIterator<Array<Element>> = AnyIterator({
			let newIndex = self.index(index, offsetBy: distance, limitedBy: self.endIndex) ?? self.endIndex
			defer { index = newIndex }
			let range = index ..< newIndex
			return index != self.endIndex ? Array(self[range]) : nil
		})

		return Array(iterator)
	}
}
