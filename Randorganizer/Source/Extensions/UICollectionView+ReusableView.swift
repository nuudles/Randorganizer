//
//  UICollectionView+ReusableView.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/28/18.
//

import UIKit

extension UICollectionView {
	func registerClassForCellReuse<T: UICollectionViewCell>(_: T.Type) {
		register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
	}

	func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
		guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
			fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
		}

		return cell
	}
}

extension UICollectionViewCell: ReusableView { }
