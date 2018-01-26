//
//  DungeonViewModel.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/26/18.
//

import Foundation
import RxSwift

/// <# documentation #>.
final class DungeonViewModel {
	// MARK: - Properties -
	private let disposeBag = DisposeBag()

	// MARK: - Initialization -
	init() {
		setupBindings()
	}
}

// MARK: - `RxBinder` -
extension DungeonViewModel: RxBinder {
	func setupBindings() {
	}
}
