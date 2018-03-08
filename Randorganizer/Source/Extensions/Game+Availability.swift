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
			guard hasItem(.moonPearl) && hasItem(.hammer) && hasItem(.somaria) && hasItem(.mirror) &&
					hasItem(.titansMitts)
				else { return .unavailable }

			let medallionAvailability = medallionDungeonAvailability(.turtleRock)
			guard medallionAvailability == .available else { return medallionAvailability }

			return hasItem(.fireRod) ? deathMountainAvailability : .possible
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
			let deathMountainAccess = deathMountainAvailability
			guard tabletAvailability != .unavailable,
				deathMountainAccess != .unavailable,
				hasItem(.mirror) || (hasItem(.hookshot) && hasItem(.hammer))
				else { return .unavailable }

			return tabletAvailability == .available ? deathMountainAccess : tabletAvailability
		case .bombosTablet:
			let tabletAvailability = self.tabletAvailability
			guard tabletAvailability != .unavailable,
				hasItem(.mirror),
				canReachOutcast || hasSouthDarkWorldFromPyramidAccess
				else { return .unavailable }

			return tabletAvailability
		case .kingZora:
			return hasItem(.flippers) || hasItem(.glove) ? .available : .glitches
		case .lostOldMan:
			let deathMountainAccess = deathMountainAvailability
			guard deathMountainAccess != .unavailable else { return .unavailable }
			return hasItem(.lantern) ? .available : .glitches
		case .potionShop:
			return hasItem(.mushroom) ? .available : .unavailable
		case .forestHideout:
			return .available
		case .lumberjackTree:
			return dungeonIsComplete(.castleTower) && hasItem(.boots) ? .available : .visible
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

	func bossAvailability(for dungeon: Dungeon) -> Availability {
		guard dungeons.filter({ $0.dungeon == dungeon && $0.isComplete }).count == 0 else { return .completed }

		switch dungeon {
		case .castleTower:
			guard hasItem(.cape) || hasAtLeastMasterSword,
				canDefeatBoss(for: dungeon) else {
				return .unavailable
			}
			return hasItem(.lantern) ? .available : .glitches
		case .easternPalace:
			guard hasItem(.bow) || hasItem(.bowAndSilverArrows),
				canDefeatBoss(for: dungeon)
				else { return .unavailable }
			return hasItem(.lantern) ? .available : .glitches
		case .desertPalace:
			let canEnterLightWay = hasItem(.book) && hasItem(.glove)
			let canEnterDarkWay = hasItem(.flute) && hasItem(.titansMitts) && hasItem(.mirror)
			guard canEnterLightWay || canEnterDarkWay,
				hasItem(.lantern) || hasItem(.fireRod),
				canDefeatBoss(for: dungeon)
				else { return .unavailable }
			return hasItem(.boots) ? .available : .possible
		case .towerOfHera:
			guard canDefeatBoss(for: dungeon)
				else { return .unavailable }

			let deathMountainAccess = deathMountainAvailability
			guard deathMountainAccess != .unavailable,
				hasItem(.mirror) || (hasItem(.hookshot) && hasItem(.hammer))
				else { return .unavailable }
			guard hasItem(.fireRod) || hasItem(.lantern) else { return .possible }

			return deathMountainAccess
		case .palaceOfDarkness:
			guard hasItem(.moonPearl) && (hasItem(.bow) || hasItem(.bowAndSilverArrows)) && hasItem(.hammer),
				dungeonIsComplete(.castleTower) || hasItem(.glove),
				canDefeatBoss(for: dungeon)
				else { return .unavailable }
			return hasItem(.lantern) ? .available : .glitches
		case .swampPalace:
			guard hasItem(.moonPearl) && hasItem(.mirror) && hasItem(.flippers),
				hasItem(.hammer) && hasItem(.hookshot),
				hasItem(.glove) || dungeonIsComplete(.castleTower),
				canDefeatBoss(for: dungeon)
				else { return .unavailable }
			return .available
		case .skullWoods:
			guard canReachOutcast,
				hasItem(.fireRod),
				canDefeatBoss(for: dungeon),
				hasItem(.sword)
				else { return .unavailable }
			return .available
		case .thievesTown:
			guard canReachOutcast,
				canDefeatBoss(for: dungeon)
				else { return .unavailable }
			return .available
		case .icePalace:
			guard hasItem(.moonPearl) && hasItem(.flippers) && hasItem(.titansMitts) && hasItem(.hammer),
				canDefeatBoss(for: dungeon)
				else { return .unavailable }
			return hasItem(.hookshot) || hasItem(.somaria) ? .available : .glitches
		case .miseryMire:
			guard hasItem(.flute) && hasItem(.moonPearl) && hasItem(.titansMitts) && hasItem(.somaria),
				hasItem(.boots) || hasItem(.hookshot),
				canDefeatBoss(for: dungeon)
				else { return .unavailable }

			let medallionAvailability = medallionDungeonAvailability(dungeon)
			guard medallionAvailability == .available else { return medallionAvailability }

			if hasItem(.lantern) {
				return .available
			}

			return hasItem(.fireRod) ? .glitches : .possible
		case .turtleRock:
			guard hasItem(.moonPearl) && hasItem(.hammer) && hasItem(.titansMitts) && hasItem(.somaria),
				hasItem(.hookshot) || hasItem(.mirror),
				hasItem(.iceRod) && hasItem(.fireRod),
				canDefeatBoss(for: dungeon)
				else { return .unavailable }

			let medallionAvailability = medallionDungeonAvailability(dungeon)
			guard medallionAvailability == .available else { return medallionAvailability }

			if !(hasItem(.byrna) || hasItem(.cape) || hasItem(.mirrorShield)) {
				return .possible
			}
			return hasItem(.lantern) ? .available : .glitches
		case .ganonsTower:
			let completedCrystals =
				dungeons.filter({ ($0.reward == .crystal || $0.reward == .redCrystal) && $0.isComplete }).count
			guard completedCrystals == 7,
				hasItem(.titansMitts) && hasItem(.moonPearl),
				hasItem(.hookshot) || hasItem(.hammer),
				hasItem(.bow) || hasItem(.bowAndSilverArrows),
				hasItem(.lantern) || hasItem(.fireRod),
				canDefeatBoss(for: dungeon)
				else { return .unavailable }
			return .available
		}
	}

	func chestAvailability(for dungeon: Dungeon) -> Availability {
		guard let configuration = dungeons.filter({ $0.dungeon == dungeon }).first else { return .unavailable }
		guard configuration.remainingChests > 0 || dungeon == .castleTower || dungeon == .ganonsTower
			else { return .completed }

		switch dungeon {
		case .castleTower:
			return bossAvailability(for: dungeon)
		case .easternPalace:
			if configuration.remainingChests <= 2 && !hasItem(.lantern) {
				return .possible
			} else if configuration.remainingChests == 1 && !(hasItem(.bow) || hasItem(.bowAndSilverArrows)) {
				return .possible
			}
			return .available
		case .desertPalace:
			guard hasItem(.book) || (hasItem(.flute) && hasItem(.titansMitts) && hasItem(.mirror))
				else { return .unavailable }

			if hasItem(.glove) && (hasItem(.fireRod) || hasItem(.lantern)) && hasItem(.boots) {
				return .available
			}

			return configuration.remainingChests > 1 && hasItem(.boots) ? .available : .possible
		case .towerOfHera:
			let deathMountainAccess = deathMountainAvailability
			guard deathMountainAccess != .unavailable,
				hasItem(.mirror) || (hasItem(.hookshot) && hasItem(.hammer))
				else { return .unavailable }
			guard hasItem(.fireRod) || hasItem(.lantern) else { return .possible }

			return deathMountainAccess
		case .palaceOfDarkness:
			guard hasItem(.moonPearl),
				dungeonIsComplete(.castleTower) || (hasItem(.hammer) && hasItem(.glove)) ||
					(hasItem(.titansMitts) && hasItem(.flippers))
				else { return .unavailable }
			return !((hasItem(.bow) || hasItem(.bowAndSilverArrows)) && hasItem(.lantern)) ||
				configuration.remainingChests == 1 && !hasItem(.hammer)
				? .possible : .available
		case .swampPalace:
			guard hasItem(.moonPearl) && hasItem(.mirror) && hasItem(.flippers),
				canReachOutcast || (dungeonIsComplete(.castleTower) && hasItem(.hammer))
				else { return .unavailable }
			if configuration.remainingChests <= 2 {
				return !hasItem(.hammer) || !hasItem(.hookshot) ? .unavailable : .available
			} else if configuration.remainingChests <= 4 {
				return !hasItem(.hammer) ? .unavailable : !hasItem(.hookshot) ? .possible : .available
			} else if configuration.remainingChests <= 5 {
				return !hasItem(.hammer) ? .unavailable : .available
			}
			return !hasItem(.hammer) ? .possible : .available
		case .skullWoods:
			guard canReachOutcast else { return .unavailable }
			return hasItem(.fireRod) ? .available : .possible
		case .thievesTown:
			guard canReachOutcast else { return .unavailable }
			return configuration.remainingChests == 1 && !hasItem(.hammer) ? .possible : .available
		case .icePalace:
			guard hasItem(.moonPearl) && hasItem(.flippers) && hasItem(.titansMitts),
				hasItem(.fireRod) || (hasItem(.bombos) && hasItem(.sword))
				else { return .unavailable }
			return hasItem(.hammer) ? .available : .glitches
		case .miseryMire:
			guard hasItem(.flute) && hasItem(.moonPearl) && hasItem(.titansMitts),
				hasItem(.boots) || hasItem(.hookshot)
				else { return .unavailable }

			let medallionAvailability = medallionDungeonAvailability(dungeon)
			guard medallionAvailability == .available else { return medallionAvailability }

			if configuration.remainingChests > 1 {
				return hasItem(.fireRod) || hasItem(.lantern) ? .available : .possible
			}
			return hasItem(.lantern) && hasItem(.somaria) ? .available : .possible
		case .turtleRock:
			guard hasItem(.moonPearl) && hasItem(.hammer) && hasItem(.titansMitts) && hasItem(.somaria),
				hasItem(.hookshot) || hasItem(.mirror)
				else { return .unavailable }

			let medallionAvailability = medallionDungeonAvailability(dungeon)
			guard medallionAvailability == .available else { return medallionAvailability }

			let hasLaserBridgeSafety = hasItem(.byrna) || hasItem(.cape) || hasItem(.mirrorShield)
			let darkAvailability = hasItem(.lantern) ? Availability.available : .glitches

			if configuration.remainingChests <= 1 {
				return !hasLaserBridgeSafety ? .unavailable : hasItem(.fireRod) && hasItem(.iceRod)
					? darkAvailability : .possible
			} else if configuration.remainingChests <= 2 {
				return !hasLaserBridgeSafety ? .unavailable : hasItem(.fireRod) ? darkAvailability : .possible
			} else if configuration.remainingChests <= 4 {
				return hasLaserBridgeSafety && hasItem(.fireRod) && hasItem(.lantern) ? .available : .possible
			}

			return hasItem(.fireRod) && hasItem(.lantern) ? .available : .possible
		case .ganonsTower:
			return bossAvailability(for: dungeon)
		}
	}

	private func canDefeatBoss(for dungeon: Dungeon) -> Bool {
		switch dungeon {
		case .castleTower, .ganonsTower:
			return hasItem(.bugNet) || hasItem(.sword)
		case .easternPalace:
			return hasItem(.sword) || hasItem(.hammer) || hasItem(.bow) || hasItem(.bowAndSilverArrows) || hasItem(.fireRod) ||
				hasItem(.iceRod) || hasItem(.somaria) || hasItem(.byrna) || hasItem(.boomerang) || hasItem(.bomb)
		case .desertPalace:
			return hasItem(.sword) || hasItem(.hammer) || hasItem(.bow) || hasItem(.bowAndSilverArrows) || hasItem(.somaria) ||
				hasItem(.byrna) || hasItem(.bomb)
		case .towerOfHera:
			return hasItem(.sword) || hasItem(.hammer)
		case .palaceOfDarkness:
			return hasItem(.hammer) || (hasItem(.bomb) && (hasItem(.sword) || hasItem(.bow) || hasItem(.bowAndSilverArrows)))
		case .swampPalace:
			return hasItem(.hookshot) && (hasItem(.sword) || hasItem(.bow) || hasItem(.bowAndSilverArrows) || hasItem(.somaria) || hasItem(.byrna) || hasItem(.bomb))
		case .skullWoods:
			return hasItem(.sword) || hasItem(.hammer) || hasItem(.somaria) || hasItem(.byrna) || hasItem(.fireRod)
		case .thievesTown:
			return hasItem(.sword) || hasItem(.hammer) || hasItem(.somaria) || hasItem(.byrna)
		case .icePalace:
			let canDefeatBlock = (hasItem(.bombos) && hasItem(.sword)) || hasItem(.fireRod)
			let canDefeatCloud = hasItem(.fireRod) || hasItem(.sword) || hasItem(.hammer)
			return canDefeatBlock && canDefeatCloud
		case .miseryMire:
			return hasItem(.sword) || hasItem(.hammer) || hasItem(.bow) || hasItem(.bowAndSilverArrows) || hasItem(.bomb)
		case .turtleRock:
			return hasItem(.fireRod) && hasItem(.iceRod) && (hasItem(.sword) || hasItem(.hammer))
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

	private func medallionDungeonAvailability(_ dungeon: Dungeon) -> Availability {
		// Need a sword to use a medallion
		guard hasItem(.sword) else { return .unavailable }

		if hasItem(.bombos) && hasItem(.ether) && hasItem(.quake) {
			return .available
		}
		guard let medallion = dungeons.filter({ $0.dungeon == dungeon }).first?.requiredMedallion
			else { return (hasItem(.bombos) || hasItem(.ether) || hasItem(.quake)) ? .possible : .unavailable }
		return hasItem(medallion) ? .available : .unavailable
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
