//
//  Game.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/25/18.
//

import Foundation

struct Game {
	// MARK: - Enums -
	enum Mode {
		case standard
		case open
		case swordless
	}
	enum Shuffle {
		case normal
		case keysanity
	}

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
	var dungeons = Dungeon.allValues.map { DungeonConfiguration(dungeon: $0) }

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

	mutating func toggle(dungeon: Dungeon) {
		dungeons.replaceItem(
			matching: { $0.dungeon == dungeon },
			afterApplying: { $0.isComplete = !$0.isComplete }
		)
	}
}
