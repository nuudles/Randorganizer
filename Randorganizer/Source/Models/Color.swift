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

	var rgb: (Int, Int, Int) {
		switch self {
		case .darkGray: return (73, 75, 75)
		case .triforceYellow: return (212, 206, 70)
		}
	}
}
