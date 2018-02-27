//
//  Dungeon+Offset.swift
//  Randorganizer
//
//  Created by Christopher Luu on 2/27/18.
//

import UIKit

extension Dungeon {
	var offset: CGPoint {
		switch self {
		case .castleTower:
			return CGPoint(x: 50, y: 52.6)
		case .easternPalace:
			return CGPoint(x: 94.6, y: 38.8)
		case .desertPalace:
			return CGPoint(x: 7.6, y: 78.4)
		case .towerOfHera:
			return CGPoint(x: 62, y: 5.5)
		case .palaceOfDarkness:
			return CGPoint(x: 94, y: 40)
		case .swampPalace:
			return CGPoint(x: 47, y: 91)
		case .skullWoods:
			return CGPoint(x: 6.6, y: 5.4)
		case .thievesTown:
			return CGPoint(x: 12.8, y: 47.9)
		case .icePalace:
			return CGPoint(x: 79.6, y: 85.8)
		case .miseryMire:
			return CGPoint(x: 11.6, y: 82.9)
		case .turtleRock:
			return CGPoint(x: 93.8, y: 7)
		case .ganonsTower:
			return CGPoint(x: 58, y: 5.5)
		}
	}
}
