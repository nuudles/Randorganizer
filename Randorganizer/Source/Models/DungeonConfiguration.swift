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
	}

	let dungeon: Dungeon
	var isComplete = false
	var openedTreasures = 0
	var keyCount = 0
	var hasBigKey = false
	var reward: Reward?

	init(dungeon: Dungeon) {
		self.dungeon = dungeon
	}
}

extension DungeonConfiguration: Equatable {
	static func == (lhs: DungeonConfiguration, rhs: DungeonConfiguration) -> Bool {
		return lhs.dungeon == rhs.dungeon &&
			lhs.isComplete == rhs.isComplete &&
			lhs.openedTreasures == rhs.openedTreasures &&
			lhs.keyCount == rhs.keyCount &&
			lhs.hasBigKey == rhs.hasBigKey &&
			lhs.reward == rhs.reward
	}
}
