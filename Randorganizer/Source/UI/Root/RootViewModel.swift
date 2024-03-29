//
//  RootViewModel.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/26/18.
//

import Default
import Foundation
import RxCocoa
import RxSwift

final class RootViewModel {
	// MARK: - Properties -
	private let disposeBag = DisposeBag()

	private let game: Variable<Game>
	let settings: Variable<Settings>
	let selectedItems = ReplaySubject<Set<Item>>.create(bufferSize: 1)
	let dungeons = ReplaySubject<[DungeonConfiguration]>.create(bufferSize: 1)
	let locationAvailabilities = ReplaySubject<[Location: Availability]>.create(bufferSize: 1)
	let chestAndBossAvailabilities = ReplaySubject<[Dungeon: (Availability, Availability)]>.create(bufferSize: 1)

	var adsEnabled: Bool {
		get { return settings.value.adsEnabled }
		set { settings.value.adsEnabled = newValue }
	}
	var defaultBombsSelected: Bool {
		get { return settings.value.defaultBombsSelected }
		set { settings.value.defaultBombsSelected = newValue }
	}

	// MARK: - Initialization -
	init() {
		settings = Variable(Settings.read() ?? Settings())
		game = Variable(Game(settings: settings.value))

		setUpBindings()
	}

	// MARK: - Internal Functions -
	func toggle(item: Item) {
		game.value.toggle(item: item)
	}

	func toggle(dungeon: Dungeon) {
		game.value.toggle(dungeon: dungeon)
	}

	func toggleChests(for dungeon: Dungeon) {
		game.value.toggleChests(for: dungeon)
	}

	func toggleReward(for dungeon: Dungeon) {
		game.value.toggleReward(for: dungeon)
	}

	func toggleMedallion(for dungeon: Dungeon) {
		game.value.toggleMedallion(for: dungeon)
	}

	func toggle(location: Location) {
		game.value.toggle(location: location)
	}

	func reset() {
		game.value = Game(settings: settings.value)
	}
}

// MARK: - `RxBinder` -
extension RootViewModel: RxBinder {
	func setUpBindings() {
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

		game.asObservable()
			.map { (game) in
				var availabilities = [Location: Availability]()
				(Location.lightWorldLocations + Location.darkWorldLocations)
					.forEach {
						availabilities[$0] = game.availability(for: $0)
					}
				return availabilities
			}
			.bind(to: locationAvailabilities)
			.disposed(by: disposeBag)

		game.asObservable()
			.map { (game) in
				var availabilities = [Dungeon: (Availability, Availability)]()
				Dungeon.allValues
					.forEach {
						availabilities[$0] = (game.chestAvailability(for: $0), game.bossAvailability(for: $0))
					}
				return availabilities
			}
			.bind(to: chestAndBossAvailabilities)
			.disposed(by: disposeBag)

		settings.asObservable()
			.subscribe(onNext: { $0.write() })
			.disposed(by: disposeBag)

		settings.asObservable()
			.skip(1)
			.map { $0.defaultBombsSelected }
			.distinctUntilChanged()
			.filter { [unowned self] in $0 && !self.game.value.selectedItems.contains(.bomb) }
			.subscribe(onNext: { [unowned self] _ in self.toggle(item: .bomb) })
			.disposed(by: disposeBag)
	}
}
