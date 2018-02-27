//
//  AppearanceHelper.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/26/18.
//

import UIKit

struct AppearanceHelper {
	static func setUp() {
		UINavigationBar.appearance().barTintColor = .black
		UINavigationBar.appearance().titleTextAttributes = [
			NSAttributedStringKey.font: UIFont.pressStartFont(ofSize: 18),
			NSAttributedStringKey.foregroundColor: UIColor(.triforceYellow)
		]

		UIBarButtonItem.appearance().setTitleTextAttributes([
				NSAttributedStringKey.font: UIFont.pressStartFont(ofSize: 10)
			], for: .normal)

		UITabBar.appearance().barTintColor = .black
		UITabBar.appearance().tintColor = UIColor(.triforceYellow)
		UITabBarItem.appearance().setTitleTextAttributes([
				NSAttributedStringKey.font: UIFont.returnOfGanonFont(ofSize: 14)
			], for: .normal)

		UISwitch.appearance().tintColor = UIColor(.triforceYellow)
		UISwitch.appearance().onTintColor = UIColor(.triforceYellow)
	}

	// MARK: - Initializations -
	private init() { }
}
