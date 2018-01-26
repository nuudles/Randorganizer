//
//  UIView+SafeArea.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/25/18.
//

import SnapKit
import UIKit

// This extension is borrowed from: https://github.com/SnapKit/SnapKit/issues/448
extension UIView {
	var safeArea: ConstraintBasicAttributesDSL {
		#if swift(>=3.2)
			if #available(iOS 11.0, *) {
				return safeAreaLayoutGuide.snp
			}
			return self.snp
		#else
			return self.snp
		#endif
	}
}
