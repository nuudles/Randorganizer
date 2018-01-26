//
//  UIViewController+SafeArea.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/25/18.
//

import SnapKit
import UIKit

// This extension takes cues from: https://github.com/SnapKit/SnapKit/issues/448
extension UIViewController {
	var safeTop: ConstraintItem {
		if #available(iOS 11.0, *) {
			return view.safeAreaLayoutGuide.snp.top
		}
		return topLayoutGuide.snp.bottom
	}
	var safeBottom: ConstraintItem {
		if #available(iOS 11.0, *) {
			return view.safeAreaLayoutGuide.snp.bottom
		}
		return bottomLayoutGuide.snp.top
	}
}
