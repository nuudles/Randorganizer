//
//  DungeonCellViewModel.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/28/18.
//

import Foundation
import RxSwift

final class DungeonCellViewModel {
	// MARK: - Properties -
	private let disposeBag = DisposeBag()

	private let configuration = PublishSubject<DungeonConfiguration>()
	let dungeon = PublishSubject<Dungeon>()
	let isComplete = PublishSubject<Bool>()

	// MARK: - Initializations -
	init() {
		setupBindings()
	}

	// MARK: - Internal Functions -
	func update(with configuration: DungeonConfiguration) {
		self.configuration.onNext(configuration)
	}
}

// MARK: - `RxBinder` -
extension DungeonCellViewModel: RxBinder {
	func setupBindings() {
		configuration.map { $0.dungeon }
			.debug()
			.bind(to: dungeon)
			.disposed(by: disposeBag)

		configuration.map { $0.isComplete }
			.bind(to: isComplete)
			.disposed(by: disposeBag)
	}
}
