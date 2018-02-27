//
//  Eureka+Rx.swift
//  Randorganizer
//
//  Created by Christopher Luu on 2/8/18.
//

import Eureka
import Foundation
import RxCocoa
import RxSwift

// This code is borrowed from: https://gist.github.com/dangthaison91/914ee150bb7cf7171b4b82bdf3523477
extension RowOf: ReactiveCompatible {}

extension Reactive where Base: RowType, Base: BaseRow {
	var value: ControlProperty<Base.Cell.Value?> {
		let source = Observable<Base.Cell.Value?>.create { observer in
			self.base.onChange { row in
				observer.onNext(row.value)
			}
			return Disposables.create()
		}
		let binder = Binder(base) { (row, value) in
			row.value = value
		}
		return ControlProperty(values: source, valueSink: binder)
	}
}
