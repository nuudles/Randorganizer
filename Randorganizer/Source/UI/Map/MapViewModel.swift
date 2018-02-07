//
//  MapViewModel.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/26/18.
//

import Foundation
import RxSwift

final class MapViewModel {
	// MARK: - Properties -
	private let disposeBag = DisposeBag()
	let locationAvailabilities: Observable<[Location: Availability]>
	let chestAndBossAvailabilities: Observable<[Dungeon: (Availability, Availability)]>
	let world = BehaviorSubject<World>(value: .light)

	// MARK: - Initialization -
	init(locationAvailabilities: Observable<[Location: Availability]>,
		 chestAndBossAvailabilities: Observable<[Dungeon: (Availability, Availability)]>) {
		self.locationAvailabilities = locationAvailabilities
		self.chestAndBossAvailabilities = chestAndBossAvailabilities
		setUpBindings()
	}

	// MARK: - Internal Functions -
	func toggleWorld() {
		let nextWorld: World
		switch (try? world.value()) ?? .dark {
		case .light: nextWorld = .dark
		case .dark: nextWorld = .light
		}

		world.onNext(nextWorld)
	}
}

// MARK: - `RxBinder` -
extension MapViewModel: RxBinder {
	func setUpBindings() {
	}
}
