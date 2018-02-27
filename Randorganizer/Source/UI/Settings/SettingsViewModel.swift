//
//  SettingsViewModel.swift
//  Randorganizer
//
//  Created by Christopher Luu on 2/8/18.
//

import Default
import Foundation
import RxSwift

final class SettingsViewModel {
	// MARK: - Properties -
	private let disposeBag = DisposeBag()
	private let settings: Observable<Settings>
	let adsEnabled = ReplaySubject<Bool>.create(bufferSize: 1)

	// MARK: - Initializations -
	init(settings: Observable<Settings>) {
		self.settings = settings

		setUpBindings()
	}
}

// MARK: - `RxBinder` -
extension SettingsViewModel: RxBinder {
	func setUpBindings() {
		settings.take(1)
			.map { $0.adsEnabled }
			.bind(to: adsEnabled)
			.disposed(by: disposeBag)
	}
}
