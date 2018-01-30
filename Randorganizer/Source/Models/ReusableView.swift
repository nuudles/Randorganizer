//
//  ReusableView.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/28/18.
//

import UIKit

// This code is borrowed from:
// https://medium.com/@gonzalezreal/ios-cell-registration-reusing-with-swift-protocol-extensions-and-generics-c5ac4fb5b75e

protocol ReusableView: class {
	static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
	static var defaultReuseIdentifier: String {
		return NSStringFromClass(self)
	}
}
