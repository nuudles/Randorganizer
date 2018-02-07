//
//  UIColor+Color.swift
//  Randorganizer
//
//  Created by Christopher Luu on 2/6/18.
//

import UIKit

extension UIColor {
	convenience init(_ color: Color, alpha: CGFloat = 1.0) {
		let (r, g, b) = color.rgb
		self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: alpha)
	}
}
