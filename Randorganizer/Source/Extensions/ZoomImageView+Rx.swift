//
//  ZoomImageView+Rx.swift
//  Randorganizer
//
//  Created by Christopher Luu on 2/3/18.
//

import RxCocoa
import RxSwift
import UIKit
import ZoomImageView

extension Reactive where Base == ZoomImageView {
	var image: Binder<UIImage?> {
		return Binder(base) { (imageView, image) in
			imageView.image = image
		}
	}
}
