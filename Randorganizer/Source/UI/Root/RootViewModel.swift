//
//  RootViewModel.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/26/18.
//

import Foundation
import RxCocoa
import RxSwift

/// <# documentation #>.
final class RootViewModel {
	// MARK: - Properties -
	private let disposeBag = DisposeBag()

	private let game = Variable(Game())
	let selectedItems = ReplaySubject<Set<Item>>.create(bufferSize: 1)

	// MARK: - Initialization -
	init() {
		setupBindings()
	}

	// MARK: - Internal Functions -
	func toggle(item: Item) {
		game.value.toggle(item: item)
	}
}

// MARK: - `RxBinder` -
extension RootViewModel: RxBinder {
	func setupBindings() {
		game.asObservable()
			.map { $0.selectedItems }
			.distinctUntilChanged()
			.bind(to: selectedItems)
			.disposed(by: disposeBag)
	}
}
