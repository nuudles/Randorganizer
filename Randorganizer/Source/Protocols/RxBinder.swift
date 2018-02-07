//
//  RxBinder.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/25/18.
//

import Foundation

/// A protocol for encouraging consistency across various components that setup rx bindings.
public protocol RxBinder {
	/// Configure data bindings.
	func setUpBindings()
}
