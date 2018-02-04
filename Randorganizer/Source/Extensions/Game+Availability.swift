//
//  Game+Availability.swift
//  Randorganizer
//
//  Created by Christopher Luu on 2/2/18.
//

import Foundation

extension Game {
	func availability(for location: Location) -> Availability {
		guard !selectedLocations.contains(location) else { return .completed }

		switch location {
		case .kingsTomb:
			return hasItem(.boots) &&
				(hasItem(.titansMitts) || hasItem(.mirror) && canReachOutcast)
				? .available : .unavailable
		case .lightWorldSwamp:
			return .available
		case .linksHouse:
			return .available
		case .spiralCave:
			return eastDeathMountainAvailability
		case .mimicCave:
			let turtleRockAvailability = availability(for: .turtleRock)
			guard turtleRockAvailability != .unavailable && hasItem(.mirror) && hasItem(.hammer) else { return .unavailable }

			if !hasItem(.fireRod) {
				return .possible
			}

			return deathMountainAvailability
		case .tavern:
			return .available
		case .chickenHouse:
			return hasItem(.bomb) ? .available : .unavailable
		case .aginahsCave:
			return hasItem(.bomb) ? .available : .unavailable
		case .sahasrahlasHut:
			return .available
		case .kakarikoWell:
			return hasItem(.bomb) ? .available : .possible
		case .blindsHut:
			return hasItem(.bomb) ? .available : .possible
		case .paradoxCave:
			let eastDeathMountainAccess = eastDeathMountainAvailability
			guard eastDeathMountainAccess != .unavailable else { return .unavailable }

			let hasLogicalWay = deathMountainAvailability == .available
			if hasItem(.bomb) {
				return hasLogicalWay ? .available : .glitches
			}

			return hasLogicalWay ? .possible : .glitches
		case .bonkRocks:
			return hasItem(.boots) ? .available : .unavailable
		case .miniMoldormCave:
			return hasItem(.bomb) ? .available : .unavailable
		case .iceRodCave:
			return hasItem(.bomb) ? .available : .unavailable
		case .bottleVendor:
			return .available
		case .sahasrahlasReward:
			return dungeons.filter { $0.reward == .greenPendant }
				.first?
				.isComplete == true ? .available : .unavailable
		case .sickKid:
			return hasItem(.bottle) ? .available : .unavailable
		case .bridgeHideout:
			return hasItem(.flippers) ? .available : .glitches
		case .etherTablet:
			let tabletAvailability = self.tabletAvailability
			guard tabletAvailability != .unavailable,
				availability(for: .towerOfHera) != .unavailable
				else { return .unavailable }
			return tabletAvailability
		case .bombosTablet:
			let tabletAvailability = self.tabletAvailability
			let mirrorCaveAccess = availability(for: .mirrorCave)
			guard tabletAvailability != .unavailable else { return .unavailable }

			if mirrorCaveAccess != .available {
				return mirrorCaveAccess
			}
			return tabletAvailability
		case .kingZora:
			return hasItem(.flippers) || hasItem(.glove) ? .available : .glitches
		case .lostOldMan:
			return deathMountainAvailability
		case .potionShop:
			return hasItem(.mushroom) ? .available : .unavailable
		case .forestHideout:
			return .available
		case .lumberjackTree:
			return dungeonIsComplete(.castleTower) && hasItem(.boots) ? .available : .unavailable
		case .spectacleRockCave:
			return deathMountainAvailability
		case .mirrorCave:
			guard hasItem(.mirror),
				canReachOutcast || hasSouthDarkWorldFromPyramidAccess
				else { return .unavailable }
			return .available
		case .graveyardCliffCave:
			return canReachOutcast && hasItem(.mirror) ? .available : .unavailable
		case .checkerboardCave:
			return hasItem(.flute) && hasItem(.mirror) && hasItem(.titansMitts) ? .available : .unavailable
		case .library:
			return hasItem(.boots) ? .available : .visible
		case .mushroom:
			return .available
		case .spectacleRock:
			let deathMountainAccess = deathMountainAvailability
			guard deathMountainAccess != .unavailable else { return .unavailable }

			if hasItem(.mirror) {
				return deathMountainAccess
			}
			return deathMountainAccess == .available ? .visible : .glitchesVisible
		case .floatingIsland:
			let deathMountainAccess = deathMountainAvailability
			guard deathMountainAccess != .unavailable,
				hasItem(.hookshot) || (hasItem(.hammer) && hasItem(.mirror))
				else { return .unavailable }

			if hasItem(.mirror) && hasItem(.moonPearl) && hasItem(.titansMitts) {
				return deathMountainAccess
			}

			return deathMountainAccess == .available ? .visible : .glitchesVisible
		case .raceMinigame:
			if hasItem(.bomb) || hasItem(.boots) {
				return .available
			}
			return canReachOutcast && hasItem(.mirror) ? .available : .unavailable
		case .desertWestLedge:
			return hasItem(.book) ||
				(hasItem(.flute) && hasItem(.mirror) && hasItem(.titansMitts))
				? .available : .visible
		case .lakeHyliaIsland:
			guard hasItem(.moonPearl),
				hasItem(.mirror)
				else { return .visible }

			let canAccessDarkWorldIsland = hasItem(.titansMitts) || (hasItem(.powerGlove) && hasItem(.hammer))

			guard hasItem(.flippers) else {
				return canAccessDarkWorldIsland && hasItem(.boots) ? .glitches : .visible
			}

			return dungeonIsComplete(.castleTower) || canAccessDarkWorldIsland ? .available : .visible
		case .zoraLedge:
			if hasItem(.flippers) {
				return .available
			}
			if hasItem(.boots) {
				return .glitches
			}
			return hasItem(.glove) ? .visible : .glitchesVisible
		case .buriedItem:
			return hasItem(.shovel) ? .available : .unavailable
		case .sewerEscapeSideRoom:
			guard hasItem(.bomb) || hasItem(.boots) else {
				return .unavailable
			}
			if hasItem(.glove) {
				return .available
			}
			return hasItem(.lantern) ? .possible : .glitches
		case .castleSecretEntrance:
			return .available
		case .castleDungeon:
			return .available
		case .sanctuary:
			return .available
		case .madBatter:
			guard hasItem(.hammer) || (hasItem(.titansMitts) && hasItem(.mirror) && hasItem(.moonPearl)) else {
				return .unavailable
			}
			if hasItem(.powder) {
				return .available
			}
			return hasItem(.mushroom) ? .glitches : .unavailable
		case .dwarfEscort:
			return hasItem(.moonPearl) && hasItem(.titansMitts) ? .available : .unavailable
		case .masterSwordPedestal:
			let completedPendants = dungeons
				.filter { ($0.reward == .greenPendant || $0.reward == .otherPendant) && $0.isComplete }
				.count
			if completedPendants == 3 {
				return .available
			}
			return hasItem(.book) ? .visible : .unavailable
		case .sewerEscapeDarkRoom:
			return hasItem(.lantern) ? .available : .glitches
		case .waterfallOfWishing:
			if hasItem(.flippers) {
				return .available
			}
			return hasItem(.moonPearl) ? .glitches : .unavailable
		case .bombableHut:
			return canReachOutcast && hasItem(.bomb) ? .available : .unavailable
		case .cShapedHouse:
			return canReachOutcast ? .available : .unavailable
		case .mireHut:
			return darkMireAvailability
		case .superBunnyCave:
			let deathMountainAccess = deathMountainAvailability
			guard deathMountainAccess != .unavailable,
				hasItem(.titansMitts),
				hasItem(.hookshot) || (hasItem(.mirror) && hasItem(.hammer))
				else { return .unavailable }
			return hasItem(.moonPearl) ? deathMountainAccess : .glitches
		case .spikeCave:
			guard hasItem(.glove),
				hasItem(.hammer),
				hasItem(.moonPearl)
				else { return .unavailable }
			if hasItem(.byrna) || hasItem(.cape) {
				return deathMountainAvailability
			}
			if hasItem(.bottle) {
				return .possible
			}
			return .unavailable
		case .hypeCave:
			guard hasItem(.bomb) else { return .unavailable }
			return canReachOutcast || hasSouthDarkWorldFromPyramidAccess ? .available : .unavailable
		case .hookshotCaveBottom:
			guard hasItem(.moonPearl),
				hasItem(.titansMitts),
				hasItem(.hookshot) || (hasItem(.mirror) && hasItem(.hammer) && hasItem(.boots))
				else { return .unavailable }
			return deathMountainAvailability
		case .hookshotCaveTop:
			guard hasItem(.moonPearl),
				hasItem(.titansMitts)
				else { return .unavailable }
			if hasItem(.hookshot) {
				return deathMountainAvailability
			}
			if hasItem(.mirror) && hasItem(.hammer) && hasItem(.boots) {
				return .glitches
			}
			return .unavailable
		case .treasureChestMinigame:
			return canReachOutcast ? .available : .unavailable
		case .purpleChest:
			return selectedLocations.contains(.dwarfEscort) ? .available : .unavailable
		case .catfish:
			guard hasItem(.moonPearl),
				hasItem(.glove)
				else { return .unavailable }
			if dungeonIsComplete(.castleTower) {
				return .available
			}
			if hasItem(.hammer) || (hasItem(.titansMitts) && hasItem(.flippers)) {
				return .available
			}
			if hasItem(.titansMitts) && hasItem(.boots) {
				return .glitches
			}
			return .unavailable
		case .hammerPegCave:
			return hasItem(.moonPearl) && hasItem(.titansMitts) && hasItem(.hammer) ? .available : .unavailable
		case .bumperCave:
			guard canReachOutcast else { return .unavailable }
			return hasItem(.glove) && hasItem(.cape) ? .available : .visible
		case .pyramid:
			if dungeonIsComplete(.castleTower) {
				return .available
			}
			if hasItem(.glove) && hasItem(.hammer) && hasItem(.moonPearl) {
				return .available
			}

			guard hasItem(.titansMitts) && hasItem(.moonPearl) else { return .unavailable }

			if hasItem(.flippers) {
				return .available
			} else if hasItem(.boots) {
				return .glitches
			}

			return .unavailable
		case .diggingGame,
			 .stumpKid:
			return canReachOutcast || hasSouthDarkWorldFromPyramidAccess ? .available : .unavailable
		case .pyramidFairy:
			let completedRedCrystals = dungeons.filter { $0.reward == .redCrystal && $0.isComplete }
				.count
			guard hasItem(.moonPearl),
				completedRedCrystals == 2
				else { return .unavailable }

			let isAgahnimBeaten = dungeonIsComplete(.castleTower)
			if hasItem(.hammer) && (isAgahnimBeaten || hasItem(.glove)) {
				return .available
			}
			return isAgahnimBeaten && hasItem(.mirror) && canReachOutcast ? .available : .unavailable
		}
	}

	func availability(for dungeon: Dungeon) -> Availability {
		switch dungeon {
		case .castleTower:
			return .available
		case .easternPalace:
			return .available
		case .desertPalace:
			return .available
		case .towerOfHera:
			return .available
		case .palaceOfDarkness:
			return .available
		case .swampPalace:
			return .available
		case .skullWoods:
			return .available
		case .thievesTown:
			return .available
		case .icePalace:
			return .available
		case .miseryMire:
			return .available
		case .turtleRock:
			return .available
		case .ganonsTower:
			return .available
		}
	}

	// MARK: - Helper Functions -
	private func hasItem(_ item: Item) -> Bool {
		guard let progressives = Game.progressives[item] else {
			return selectedItems.contains(item)
		}

		for progressive in progressives {
			if selectedItems.contains(progressive) {
				return true
			}
		}
		return false
	}

	private func dungeonIsComplete(_ dungeon: Dungeon) -> Bool {
		return dungeons.filter { $0.dungeon == dungeon }
			.first?
			.isComplete ?? false
	}

	private var tabletAvailability: Availability {
		guard hasItem(.book) else { return .unavailable }
		if hasItem(.fightersSword) {
			return .visible
		}
		return hasItem(.masterSword) || hasItem(.temperedSword) || hasItem(.goldSword) ? .available : .unavailable
	}
	private var hasAtLeastMasterSword: Bool {
		return hasItem(.masterSword) || hasItem(.temperedSword) || hasItem(.goldSword)
	}

	// MARK: - Area Reachability -
	private var canReachOutcast: Bool {
		guard hasItem(.moonPearl) else { return false }
		return (
			hasItem(.titansMitts) ||
			hasItem(.powerGlove) && hasItem(.hammer) ||
			dungeonIsComplete(.castleTower) && hasItem(.hookshot) && (
				hasItem(.hammer) || hasItem(.glove) || hasItem(.flippers)
			)
		)
	}
	private var hasSouthDarkWorldFromPyramidAccess: Bool {
		return dungeonIsComplete(.castleTower) && hasItem(.moonPearl) && hasItem(.hammer)
	}
	private var deathMountainAvailability: Availability {
		if hasItem(.flute) {
			return .available
		}

		guard hasItem(.glove) else { return .unavailable }
		return hasItem(.lantern) ? .available : .glitches
	}
	private var eastDeathMountainAvailability: Availability {
		let deathMountainAccess = deathMountainAvailability
		guard deathMountainAccess != .unavailable else { return .unavailable }

		return (hasItem(.hookshot) || hasItem(.mirror) && hasItem(.hammer)) ? deathMountainAccess : .unavailable
	}
	private var darkMireAvailability: Availability {
		guard hasItem(.flute) && hasItem(.titansMitts) else {
			return .unavailable
		}
		if hasItem(.moonPearl) {
			return .available
		}
		return hasItem(.mirror) ? .glitches : .unavailable
	}
}
