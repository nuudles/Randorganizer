//
//  UIImage+Color.swift
//  Randorganizer
//
//  Created by Christopher Luu on 2/4/18.
//

import UIKit

// This code is borrowed from:
// https://stackoverflow.com/questions/26542035/create-uiimage-with-solid-color-in-swift
extension UIImage {
	convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
		let rect = CGRect(origin: .zero, size: size)
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		color.setFill()
		UIRectFill(rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		guard let cgImage = image?.cgImage else { return nil }
		self.init(cgImage: cgImage)
	}
}
