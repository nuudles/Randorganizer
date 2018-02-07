//
//  UIViewController+Instantiate.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/25/18.
//

import UIKit

extension UIViewController {
	func instantiateView() {
		if let viewCustomizer = self as? ViewCustomizer {
			viewCustomizer.styleView()
			viewCustomizer.addSubviews()
		}
		if let binder = self as? RxBinder {
			binder.setUpBindings()
		}
	}
}
