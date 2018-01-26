//
//  MapViewModel.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/26/18.
//

import Foundation
import RxSwift

/// <# documentation #>.
final class MapViewModel {
	// MARK: - Properties -
	private let disposeBag = DisposeBag()

	// MARK: - Initialization -
	init() {
		setupBindings()
	}
}

// MARK: - `RxBinder` -
extension MapViewModel: RxBinder {
	func setupBindings() {
	}
}
