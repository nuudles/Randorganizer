//
//  Color.swift
//  Randorganizer
//
//  Created by Christopher Luu on 2/6/18.
//

import Foundation

enum Color {
	case darkGray
	case triforceYellow
	case darkGreen

	// swiftlint:disable:next large_tuple
	var rgb: (Int, Int, Int) {
		switch self {
		case .darkGray: return (73, 75, 75)
		case .triforceYellow: return (212, 206, 70)
		case .darkGreen: return (14, 81, 53)
		}
	}
}
