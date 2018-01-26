//
//  DungeonViewController.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/26/18.
//

import RxSwift
import SnapKit
import UIKit

/// <# documentation #>
final class DungeonViewController: UIViewController {
	// MARK: - properties -
	private let viewModel: DungeonViewModel
	private let disposeBag = DisposeBag()

	// MARK: - initialization -
	init() {
		self.viewModel = DungeonViewModel()

		super.init(nibName: nil, bundle: nil)

		title = "Dungeons"
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
extension DungeonViewController: ViewCustomizer {
	// MARK: - constants -
	
	func styleView() {
	}
	
	func addSubviews() {
	}
}

// MARK: - `RxBinder` -
extension DungeonViewController: RxBinder {
	func setupBindings() {
	}
}
