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
	let remainingChests = PublishSubject<String>()
	let hasReward = PublishSubject<Bool>()
	let reward = PublishSubject<DungeonConfiguration.Reward?>()
	let needsMedallion = PublishSubject<Bool>()
	let requiredMedallion = PublishSubject<Item?>()

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
			.bind(to: dungeon)
			.disposed(by: disposeBag)

		configuration.map { $0.isComplete }
			.bind(to: isComplete)
			.disposed(by: disposeBag)

		configuration.map {
				let remainingChests = $0.remainingChests
				return remainingChests > 0 ? String(remainingChests) : ""
			}
			.bind(to: remainingChests)
			.disposed(by: disposeBag)

		configuration.map { $0.reward }
			.bind(to: reward)
			.disposed(by: disposeBag)

		dungeon.map { $0.hasReward }
			.bind(to: hasReward)
			.disposed(by: disposeBag)

		dungeon.map { $0.needsMedallion }
			.bind(to: needsMedallion)
			.disposed(by: disposeBag)

		configuration.map { $0.requiredMedallion }
			.bind(to: requiredMedallion)
			.disposed(by: disposeBag)
	}
}

// MARK: - Dungeon Extension -
private extension Dungeon {
	var hasReward: Bool {
		switch self {
		case .castleTower, .ganonsTower: return false
		default: return true
		}
	}
	var needsMedallion: Bool {
		switch self {
		case .miseryMire, .turtleRock: return true
		default: return false
		}
	}
}
