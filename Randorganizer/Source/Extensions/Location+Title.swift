//
//  Location+Title.swift
//  Randorganizer
//
//  Created by Christopher Luu on 2/27/18.
//

import Foundation

extension Location {
	var title: String {
		switch self {
		case .kingsTomb:
			return "King's Tomb"
		case .lightWorldSwamp:
			return "Light World Swamp"
		case .linksHouse:
			return "Link's House"
		case .spiralCave:
			return "Spiral Cave"
		case .mimicCave:
			return "Mimic Cave"
		case .tavern:
			return "Tavern"
		case .chickenHouse:
			return "Chicken House"
		case .aginahsCave:
			return "Aginah's Cave"
		case .sahasrahlasHut:
			return "Sahasrahla's Hut"
		case .kakarikoWell:
			return "Kakariko Well"
		case .blindsHut:
			return "Blind's Hut"
		case .paradoxCave:
			return "Paradox Cave"
		case .bonkRocks:
			return "Bonk Rocks"
		case .miniMoldormCave:
			return "Minimoldorm Cave"
		case .iceRodCave:
			return "Ice Rod Cave"
		case .bottleVendor:
			return "Bottle Vendor"
		case .sahasrahlasReward:
			return "Sahasrahla"
		case .sickKid:
			return "Sick kid"
		case .bridgeHideout:
			return "Hideout under the bridge"
		case .etherTablet:
			return "Ether Tablet"
		case .bombosTablet:
			return "Bombos Tablet"
		case .kingZora:
			return "King Zora"
		case .lostOldMan:
			return "Lost Old Man"
		case .potionShop:
			return "Witch outside Potion Shop"
		case .forestHideout:
			return "Forest Hideout"
		case .lumberjackTree:
			return "Lumberjack Tree"
		case .spectacleRockCave:
			return "Spectacle Rock Cave"
		case .mirrorCave:
			return "South of Grove (Mirror Cave)"
		case .graveyardCliffCave:
			return "Graveyard Cliff Cave"
		case .checkerboardCave:
			return "Checkerboard Cave"
		case .library:
			return "Library"
		case .mushroom:
			return "Mushroom"
		case .spectacleRock:
			return "Spectacle Rock"
		case .floatingIsland:
			return "Floating Island"
		case .raceMinigame:
			return "Race minigame"
		case .desertWestLedge:
			return "Desert West Ledge"
		case .lakeHyliaIsland:
			return "Lake Hylia Island"
		case .zoraLedge:
			return "Zora River Ledge"
		case .buriedItem:
			return "Buried Item"
		case .sewerEscapeSideRoom:
			return "Escape Sewer Side Room"
		case .castleSecretEntrance:
			return "Castle Secret Entrance"
		case .castleDungeon:
			return "Hyrule Castle Dungeon"
		case .sanctuary:
			return "Sanctuary"
		case .madBatter:
			return "Mad Batter"
		case .dwarfEscort:
			return "Take the dwarf/frog home"
		case .masterSwordPedestal:
			return "Master Sword Pedestal"
		case .sewerEscapeDarkRoom:
			return "Escape Sewer Dark Room"
		case .waterfallOfWishing:
			return "Waterfall of Wishing"
		case .bombableHut:
			return "Bombable Hut"
		case .cShapedHouse:
			return "C-Shaped House"
		case .mireHut:
			return "Mire Hut"
		case .superBunnyCave:
			return "SuperBunny Cave"
		case .spikeCave:
			return "Spike Cave"
		case .hypeCave:
			return "Hype Cave"
		case .hookshotCaveBottom:
			return "Hookshot Cave (Boots Accessible)"
		case .hookshotCaveTop:
			return "Hookshot Cave (Not Boots Accessible)"
		case .treasureChestMinigame:
			return "Treasure Chest Mini-game"
		case .stumpKid:
			return "Stump Kid"
		case .purpleChest:
			return "Purple Chest"
		case .catfish:
			return "Catfish"
		case .hammerPegCave:
			return "Hammer Peg Cave"
		case .bumperCave:
			return "Bumper Cave"
		case .pyramid:
			return "Pyramid Ledge"
		case .diggingGame:
			return "Digging Minigame"
		case .pyramidFairy:
			return "Pyramid Fairy"
		}
	}
}
