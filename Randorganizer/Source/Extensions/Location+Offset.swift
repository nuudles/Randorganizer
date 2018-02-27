//
//  Location+Offset.swift
//  Randorganizer
//
//  Created by Christopher Luu on 2/27/18.
//

import UIKit

extension Location {
	var offset: CGPoint {
		switch self {
		case .kingsTomb:
			return CGPoint(x: 61.6, y: 29.6)
		case .lightWorldSwamp:
			return CGPoint(x: 46.8, y: 93.4)
		case .linksHouse:
			return CGPoint(x: 54.8, y: 67.9)
		case .spiralCave:
			return CGPoint(x: 79.8, y: 9.3)
		case .mimicCave:
			return CGPoint(x: 85.2, y: 9.3)
		case .tavern:
			return CGPoint(x: 16.2, y: 57.8)
		case .chickenHouse:
			return CGPoint(x: 8.8, y: 54.2)
		case .aginahsCave:
			return CGPoint(x: 20, y: 82.6)
		case .sahasrahlasHut:
			return CGPoint(x: 81.4, y: 41.4)
		case .kakarikoWell:
			return CGPoint(x: 3, y: 41)
		case .blindsHut:
			return CGPoint(x: 12.8, y: 41)
		case .paradoxCave:
			return CGPoint(x: 82.8, y: 17.1)
		case .bonkRocks:
			return CGPoint(x: 39, y: 29.3)
		case .miniMoldormCave:
			return CGPoint(x: 65.2, y: 93.4)
		case .iceRodCave:
			return CGPoint(x: 89.2, y: 76.9)
		case .bottleVendor:
			return CGPoint(x: 9, y: 46.8)
		case .sahasrahlasReward:
			return CGPoint(x: 81.4, y: 46.7)
		case .sickKid:
			return CGPoint(x: 15.6, y: 52.1)
		case .bridgeHideout:
			return CGPoint(x: 70.8, y: 69.7)
		case .etherTablet:
			return CGPoint(x: 42, y: 3)
		case .bombosTablet:
			return CGPoint(x: 22, y: 92.2)
		case .kingZora:
			return CGPoint(x: 96, y: 12.1)
		case .lostOldMan:
			return CGPoint(x: 41.6, y: 20.4)
		case .potionShop:
			return CGPoint(x: 81.6, y: 32.5)
		case .forestHideout:
			return CGPoint(x: 18.8, y: 13)
		case .lumberjackTree:
			return CGPoint(x: 30.4, y: 7.6)
		case .spectacleRockCave:
			return CGPoint(x: 48.6, y: 14.8)
		case .mirrorCave:
			return CGPoint(x: 28.2, y: 84.1)
		case .graveyardCliffCave:
			return CGPoint(x: 56.2, y: 27)
		case .checkerboardCave:
			return CGPoint(x: 17.6, y: 77.3)
		case .library:
			return CGPoint(x: 15.4, y: 65.9)
		case .mushroom:
			return CGPoint(x: 12.4, y: 8.6)
		case .spectacleRock:
			return CGPoint(x: 50.8, y: 8.5)
		case .floatingIsland:
			return CGPoint(x: 80.4, y: 3)
		case .raceMinigame:
			return CGPoint(x: 3.6, y: 69.8)
		case .desertWestLedge:
			return CGPoint(x: 3, y: 91)
		case .lakeHyliaIsland:
			return CGPoint(x: 72.2, y: 82.9)
		case .zoraLedge:
			return CGPoint(x: 95.4, y: 17.3)
		case .buriedItem:
			return CGPoint(x: 28.8, y: 66.2)
		case .sewerEscapeSideRoom:
			return CGPoint(x: 53.6, y: 32.4)
		case .castleSecretEntrance:
			return CGPoint(x: 59.6, y: 41.8)
		case .castleDungeon:
			return CGPoint(x: 50, y: 44.1)
		case .sanctuary:
			return CGPoint(x: 46, y: 28)
		case .madBatter:
			return CGPoint(x: 33, y: 56)
		case .dwarfEscort:
			return CGPoint(x: 30.4, y: 51.8)
		case .masterSwordPedestal:
			return CGPoint(x: 5, y: 3.2)
		case .sewerEscapeDarkRoom:
			return CGPoint(x: 51.2, y: 38.2)
		case .waterfallOfWishing:
			return CGPoint(x: 89.8, y: 14.7)
		case .bombableHut:
			return CGPoint(x: 10.8, y: 57.8)
		case .cShapedHouse:
			return CGPoint(x: 21.6, y: 47.9)
		case .mireHut:
			return CGPoint(x: 3.4, y: 79.5)
		case .superBunnyCave:
			return CGPoint(x: 85.6, y: 14.7)
		case .spikeCave:
			return CGPoint(x: 57.2, y: 14.9)
		case .hypeCave:
			return CGPoint(x: 60, y: 77.1)
		case .hookshotCaveBottom:
			return CGPoint(x: 83.2, y: 8.6)
		case .hookshotCaveTop:
			return CGPoint(x: 83.2, y: 3.4)
		case .treasureChestMinigame:
			return CGPoint(x: 4.2, y: 46.4)
		case .stumpKid:
			return CGPoint(x: 31, y: 68.6)
		case .purpleChest:
			return CGPoint(x: 30.4, y: 52.2)
		case .catfish:
			return CGPoint(x: 92, y: 17.2)
		case .hammerPegCave:
			return CGPoint(x: 31.6, y: 60.1)
		case .bumperCave:
			return CGPoint(x: 34.2, y: 15.2)
		case .pyramid:
			return CGPoint(x: 58, y: 43.5)
		case .diggingGame:
			return CGPoint(x: 5.8, y: 69.2)
		case .pyramidFairy:
			return CGPoint(x: 47, y: 48.5)
		}
	}
}
