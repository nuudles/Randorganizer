//
//  UIFont+Randorganizer.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/26/18.
//

import UIKit

extension UIFont {
	static func listFonts() {
		let fontFamilyNames = UIFont.familyNames
		for familyName in fontFamilyNames {
			print("------------------------------")
			print("Font Family Name = [\(familyName)]")
			let names = UIFont.fontNames(forFamilyName: familyName)
			print("Font Names = [\(names)]")
		}
	}

	static func returnOfGanonFont(ofSize size: CGFloat) -> UIFont {
		return UIFont(name: "ReturnOfGanonReg", size: size)!
	}

	static func pressStartFont(ofSize size: CGFloat) -> UIFont {
		return UIFont(name: "PressStart2P", size: size)!
	}
}
