//
//  RootViewController.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/25/18.
//

import RxSwift
import SnapKit
import UIKit

/// <# documentation #>
final class RootViewController: UITabBarController {
	// MARK: - Properties -
	private let viewModel = RootViewModel()
	private let disposeBag = DisposeBag()

	private let itemViewController: ItemViewController
	private let dungeonViewController: DungeonViewController
	private let mapViewController: MapViewController

	// MARK: - Initialization -
	init() {
		itemViewController = ItemViewController(selectedItems: viewModel.selectedItems)
		dungeonViewController = DungeonViewController()
		mapViewController = MapViewController()

		super.init(nibName: nil, bundle: nil)

		itemViewController.delegate = self
		viewControllers = [
			UINavigationController(rootViewController: itemViewController),
			UINavigationController(rootViewController: dungeonViewController),
			UINavigationController(rootViewController: mapViewController)
		]
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle -
	override func viewDidLoad() {
		super.viewDidLoad()

		instantiateView()
	}
}

// MARK: - `RxBinder` -
extension RootViewController: RxBinder {
	func setupBindings() {
	}
}

// MARK: - `ItemViewControllerDelegate` -
extension RootViewController: ItemViewControllerDelegate {
	func itemViewController(_ viewController: ItemViewController, didToggle item: Item) {
		viewModel.toggle(item: item)
	}
}
