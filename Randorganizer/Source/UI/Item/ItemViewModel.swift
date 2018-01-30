//
//  ItemViewModel.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/25/18.
//

import Foundation
import RxSwift

final class ItemViewModel {
	// MARK: - properties -
	private let disposeBag = DisposeBag()

	let selectedItems: Observable<Set<Item>>

	// MARK: - initialization -
	init(selectedItems: Observable<Set<Item>>) {
		self.selectedItems = selectedItems
	}

	// MARK: - private functions -
}

// MARK: - `RxBinder` -
extension ItemViewModel: RxBinder {
	func setupBindings() {
	}
}
