//
//  DungeonViewModel.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/26/18.
//

import Foundation
import RxSwift

final class DungeonViewModel {
	// MARK: - Properties -
	private let disposeBag = DisposeBag()

	let dungeons: Observable<[DungeonConfiguration]>

	// MARK: - Initialization -
	init(dungeons: Observable<[DungeonConfiguration]>) {
		self.dungeons = dungeons

		setupBindings()
	}
}

// MARK: - `RxBinder` -
extension DungeonViewModel: RxBinder {
	func setupBindings() {
	}
}
