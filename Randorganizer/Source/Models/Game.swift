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
	var shuffleMode = Shuffle.normal
	var selectedItems = Set<Item>()
	var dungeons = Dungeon.allValues.map {
		DungeonConfiguration(dungeon: $0, totalChests: $0.totalChestCount(for: .normal))
	}

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

	mutating func toggleChests(for dungeon: Dungeon) {
		dungeons.replaceItem(
			matching: { $0.dungeon == dungeon },
			afterApplying: {
				$0.openedChests += 1
				if $0.openedChests > $0.totalChests {
					$0.openedChests = 0
				}
			}
		)
	}

	mutating func toggleReward(for dungeon: Dungeon) {
		dungeons.replaceItem(
			matching: { $0.dungeon == dungeon },
			afterApplying: {
				$0.reward = Game.toggle(item: $0.reward, in: DungeonConfiguration.Reward.allValues)
			}
		)
	}

	mutating func toggleMedallion(for dungeon: Dungeon) {
		dungeons.replaceItem(
			matching: { $0.dungeon == dungeon },
			afterApplying: {
				$0.requiredMedallion = Game.toggle(item: $0.requiredMedallion, in: Item.medallions)
			}
		)
	}

	// MARK: - Private Functions -
	private static func toggle<T: Equatable>(item: T?, in array: [T]) -> T? {
		guard let item = item,
			let index = array.index(of: item)
			else {
				return array.first
			}

		if index < array.count - 1 {
			return array[index + 1]
		} else {
			return nil
		}
	}
}

private extension Dungeon {
	func totalChestCount(for shuffle: Game.Shuffle) -> Int {
		switch (self, shuffle) {
		case (.castleTower, .normal): return 0
		case (.castleTower, .keysanity): return 2
		case (.easternPalace, .normal): return 3
		case (.easternPalace, .keysanity): return 6
		case (.desertPalace, .normal): return 2
		case (.desertPalace, .keysanity): return 6
		case (.towerOfHera, .normal): return 2
		case (.towerOfHera, .keysanity): return 6
		case (.palaceOfDarkness, .normal): return 5
		case (.palaceOfDarkness, .keysanity): return 14
		case (.swampPalace, .normal): return 6
		case (.swampPalace, .keysanity): return 10
		case (.skullWoods, .normal): return 2
		case (.skullWoods, .keysanity): return 8
		case (.thievesTown, .normal): return 4
		case (.thievesTown, .keysanity): return 8
		case (.icePalace, .normal): return 3
		case (.icePalace, .keysanity): return 8
		case (.miseryMire, .normal): return 2
		case (.miseryMire, .keysanity): return 8
		case (.turtleRock, .normal): return 5
		case (.turtleRock, .keysanity): return 12
		case (.ganonsTower, .normal): return 0
		case (.ganonsTower, .keysanity): return 27
		}
	}
}
