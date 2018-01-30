//
//  UIView+Instantiate.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/28/18.
//

import UIKit

extension UIView {
	func instantiateView() {
		if let viewCustomizer = self as? ViewCustomizer {
			viewCustomizer.styleView()
			viewCustomizer.addSubviews()
		}
		if let binder = self as? RxBinder {
			binder.setupBindings()
		}
	}
}
