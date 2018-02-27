//
//  RootViewController.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/25/18.
//

import RxSwift
import SnapKit
import UIKit

final class RootViewController: UITabBarController {
	// MARK: - Properties -
	private let viewModel = RootViewModel()
	private let disposeBag = DisposeBag()

	private let itemViewController: ItemViewController
	private let dungeonViewController: DungeonViewController
	private let mapViewController: MapViewController
	private let settingsViewController: SettingsViewController

	// MARK: - Initialization -
	init() {
		itemViewController = ItemViewController(settings: viewModel.settings.asObservable(),
												selectedItems: viewModel.selectedItems)
		dungeonViewController = DungeonViewController(dungeons: viewModel.dungeons)
		mapViewController = MapViewController(locationAvailabilities: viewModel.locationAvailabilities,
											  chestAndBossAvailabilities: viewModel.chestAndBossAvailabilities)
		settingsViewController = SettingsViewController(settings: viewModel.settings.asObservable())

		super.init(nibName: nil, bundle: nil)

		setUpViewControllers()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle -
	override func viewDidLoad() {
		super.viewDidLoad()

		instantiateView()
	}

	// MARK: - Private Functions -
	private func setUpViewControllers() {
		itemViewController.delegate = self
		dungeonViewController.delegate = self
		mapViewController.delegate = self
		settingsViewController.delegate = self

		viewControllers = [
			UINavigationController(rootViewController: itemViewController),
			UINavigationController(rootViewController: dungeonViewController),
			UINavigationController(rootViewController: mapViewController),
			UINavigationController(rootViewController: settingsViewController)
		]

		viewControllers?[0].tabBarItem.image = #imageLiteral(resourceName: "itemTab").withRenderingMode(.alwaysOriginal)
		viewControllers?[1].tabBarItem.image = #imageLiteral(resourceName: "dungeonTab").withRenderingMode(.alwaysOriginal)
		viewControllers?[2].tabBarItem.image = #imageLiteral(resourceName: "mapTab").withRenderingMode(.alwaysOriginal)
		viewControllers?[3].tabBarItem.image = #imageLiteral(resourceName: "settingsTab").withRenderingMode(.alwaysOriginal)
	}
}

// MARK: - `RxBinder` -
extension RootViewController: RxBinder {
	func setUpBindings() {
	}
}

// MARK: - `ItemViewControllerDelegate` -
extension RootViewController: ItemViewControllerDelegate {
	func itemViewController(_ viewController: ItemViewController, didToggle item: Item) {
		viewModel.toggle(item: item)
	}
}

// MARK: - `DungeonViewControllerDelegate` -
extension RootViewController: DungeonViewControllerDelegate {
	func dungeonViewController(_ viewController: DungeonViewController, didToggle dungeon: Dungeon) {
		viewModel.toggle(dungeon: dungeon)
	}

	func dungeonViewController(_ viewController: DungeonViewController, didToggleChestsFor dungeon: Dungeon) {
		viewModel.toggleChests(for: dungeon)
	}

	func dungeonViewController(_ viewController: DungeonViewController, didToggleRewardFor dungeon: Dungeon) {
		viewModel.toggleReward(for: dungeon)
	}

	func dungeonViewController(_ viewController: DungeonViewController, didToggleMedallionFor dungeon: Dungeon) {
		viewModel.toggleMedallion(for: dungeon)
	}
}

// MARK: - `MapViewControllerDelegate` -
extension RootViewController: MapViewControllerDelegate {
	func mapViewController(_ viewController: MapViewController, didToggle location: Location) {
		viewModel.toggle(location: location)
	}
}

// MARK: - `SettingsViewControllerDelegate` -
extension RootViewController: SettingsViewControllerDelegate {
	func settingsViewControllerDidReset(_ viewController: SettingsViewController) {
		viewModel.reset()
	}

	func settingsViewController(_ viewController: SettingsViewController, didSetAdsEnabled adsEnabled: Bool) {
		viewModel.adsEnabled = adsEnabled
	}

	func settingsViewController(_ viewController: SettingsViewController,
								didSetDefaultBombsSelected defaultBombsSelected: Bool) {
		viewModel.defaultBombsSelected = defaultBombsSelected
	}
}
