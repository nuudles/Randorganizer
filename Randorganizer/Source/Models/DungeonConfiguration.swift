//
//  DungeonConfiguration.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/26/18.
//

import Foundation

struct DungeonConfiguration {
	enum Reward {
		case greenPendant
		case otherPendant
		case crystal
		case redCrystal

		static let allValues: [Reward] = [
			.greenPendant,
			.otherPendant,
			.crystal,
			.redCrystal
		]
	}

	let dungeon: Dungeon
	var isComplete = false
	var openedChests = 0
	var totalChests: Int
	var foundKeys = 0
	var totalKeys = 0
	var hasBigKey = false
	var reward: Reward?
	var requiredMedallion: Item?
	var remainingChests: Int {
		return totalChests - openedChests
	}

	init(dungeon: Dungeon, totalChests: Int) {
		self.dungeon = dungeon
		self.totalChests = totalChests
	}
}

extension DungeonConfiguration: Equatable {
	static func == (lhs: DungeonConfiguration, rhs: DungeonConfiguration) -> Bool {
		return lhs.dungeon == rhs.dungeon &&
			lhs.isComplete == rhs.isComplete &&
			lhs.openedChests == rhs.openedChests &&
			lhs.totalChests == rhs.totalChests &&
			lhs.foundKeys == rhs.foundKeys &&
			lhs.totalKeys == rhs.totalKeys &&
			lhs.hasBigKey == rhs.hasBigKey &&
			lhs.reward == rhs.reward &&
			lhs.requiredMedallion == rhs.requiredMedallion
	}
}
