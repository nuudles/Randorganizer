//
//  MapViewController.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/26/18.
//

import RxSwift
import SnapKit
import UIKit

final class MapViewController: UIViewController {
	// MARK: - properties -
	private let viewModel: MapViewModel
	private let disposeBag = DisposeBag()

	// MARK: - initialization -
	init() {
		self.viewModel = MapViewModel()

		super.init(nibName: nil, bundle: nil)

		title = "Map"
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - lifecycle -
	override func viewDidLoad() {
		super.viewDidLoad()

		instantiateView()
	}
}

// MARK: - `ViewCustomizer` -
extension MapViewController: ViewCustomizer {
	// MARK: - constants -

	func styleView() {
	}

	func addSubviews() {
	}
}

// MARK: - `RxBinder` -
extension MapViewController: RxBinder {
	func setupBindings() {
	}
}
