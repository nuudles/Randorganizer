//
//  RootViewModel.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/26/18.
//

import Foundation
import RxCocoa
import RxSwift

final class RootViewModel {
	// MARK: - Properties -
	private let disposeBag = DisposeBag()

	private let game = Variable(Game())
	let selectedItems = ReplaySubject<Set<Item>>.create(bufferSize: 1)
	let dungeons = ReplaySubject<[DungeonConfiguration]>.create(bufferSize: 1)

	// MARK: - Initialization -
	init() {
		setupBindings()
	}

	// MARK: - Internal Functions -
	func toggle(item: Item) {
		game.value.toggle(item: item)
	}

	func toggle(dungeon: Dungeon) {
		game.value.toggle(dungeon: dungeon)
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

		game.asObservable()
			.map { $0.dungeons }
			.distinctUntilChanged { $0 == $1 }
			.bind(to: dungeons)
			.disposed(by: disposeBag)
	}
}
