//
//  ViewCustomizer.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/25/18.
//

import Foundation

/// A protocol for encouraging consistency across various components that add subviews to themselves.
public protocol ViewCustomizer {
	/// Style the root view.
	func styleView()

	/// Add, constrain, and style subviews to the ViewCustomizer.
	func addSubviews()
}
