//
//  AppearanceHelper.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/26/18.
//

import UIKit

struct AppearanceHelper {
	static func setUp() {
		UINavigationBar.appearance().titleTextAttributes = [
			NSAttributedStringKey.font: UIFont.returnOfGanonFont(ofSize: 26)
		]
	}

	// MARK: - Initializations -
	private init() { }
}
