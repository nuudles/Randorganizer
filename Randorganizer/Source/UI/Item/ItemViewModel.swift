//
//  ItemViewModel.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/25/18.
//

import Foundation
import RxSwift

final class ItemViewModel {
	// MARK: - properties -
	private let disposeBag = DisposeBag()

	private let settings: Observable<Settings>
	let selectedItems: Observable<Set<Item>>
	let adsEnabled = ReplaySubject<Bool>.create(bufferSize: 1)

	// MARK: - initialization -
	init(settings: Observable<Settings>, selectedItems: Observable<Set<Item>>) {
		self.settings = settings
		self.selectedItems = selectedItems

		setUpBindings()
	}

	// MARK: - private functions -
}

// MARK: - `RxBinder` -
extension ItemViewModel: RxBinder {
	func setUpBindings() {
		settings.map { $0.adsEnabled }
			.bind(to: adsEnabled)
			.disposed(by: disposeBag)
	}
}
