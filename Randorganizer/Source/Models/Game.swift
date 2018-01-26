//
//  Game.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/25/18.
//

import Foundation

struct Game {
	// MARK: - Constants -
	private static let progressives: [Item: [Item]] = [
		.sword: [.fightersSword, .masterSword, .temperedSword, .goldSword],
		.shield: [.fightersShield, .fireShield, .mirrorShield],
		.tunic: [.blueTunic, .redTunic],
		.bowAndArrow: [.bow, .silverArrows, .bowAndSilverArrows],
		.glove: [.powerGlove, .titansMitts],
		.magic: [.halfMagic, .quarterMagic],
		.boomerang: [.blueBoomerang, .redBoomerang, .blueAndRedBoomerangs]
	]

	// MARK: - Properties -
	var selectedItems = Set<Item>()

	// MARK: - Internal Functions -
	mutating func toggle(item: Item) {
		guard let progressive = Game.progressives[item] else {
			selectedItems.formSymmetricDifference([item])
			return
		}

		for (index, item) in progressive.enumerated() {
			if selectedItems.contains(item) {
				selectedItems.remove(item)
				if index + 1 < progressive.count {
					selectedItems.insert(progressive[index + 1])
				}
				return
			}
		}

		selectedItems.insert(progressive[0])
	}
}
