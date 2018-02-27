//
//  SettingsViewController.swift
//  Randorganizer
//
//  Created by Christopher Luu on 2/7/18.
//

import Eureka
import RxSwift
import UIKit

protocol SettingsViewControllerDelegate: class {
	func settingsViewControllerDidReset(_ viewController: SettingsViewController)
	func settingsViewController(_ viewController: SettingsViewController, didSetAdsEnabled adsEnabled: Bool)
	func settingsViewController(_ viewController: SettingsViewController,
								didSetDefaultBombsSelected defaultBombsSelected: Bool)
}

final class SettingsViewController: FormViewController {
	// MARK: - Properties -
	private let disposeBag = DisposeBag()
	private let viewModel: SettingsViewModel
	private let adsRow = SwitchRow()
	weak var delegate: SettingsViewControllerDelegate?

	// MARK: - Initializations -
	init(settings: Observable<Settings>) {
		viewModel = SettingsViewModel(settings: settings)

		super.init(nibName: nil, bundle: nil)

		title = "Settings"
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("This init method shouldn't ever be used")
	}

	// MARK: - Lifecycle -
	override func viewDidLoad() {
		super.viewDidLoad()

		instantiateView()
	}
}

// MARK: - `ViewCustomizer` -
extension SettingsViewController: ViewCustomizer {
	func styleView() {
		tableView.backgroundColor = .black
		tableView.separatorStyle = .none
	}

	func addSubviews() {
		setUpForm()
	}

	private func setUpForm() {
		ButtonRow.defaultCellSetup = { (cell, row) in
			cell.backgroundColor = UIColor(.darkGray)
			cell.textLabel?.font = .returnOfGanonFont(ofSize: 30)

			let selectedView = UIView()
			selectedView.backgroundColor = UIColor(.darkGreen)
			cell.selectedBackgroundView = selectedView
		}
		ButtonRow.defaultCellUpdate = { (cell, row) in
			cell.textLabel?.textColor = UIColor(.triforceYellow)
		}
		SwitchRow.defaultCellSetup = { (cell, row) in
			cell.backgroundColor = UIColor(.darkGray)
			cell.textLabel?.font = .returnOfGanonFont(ofSize: 26)

			let selectedView = UIView()
			selectedView.backgroundColor = UIColor(.darkGreen)
			cell.selectedBackgroundView = selectedView
		}
		SwitchRow.defaultCellUpdate = { (cell, row) in
			cell.textLabel?.textColor = UIColor(.triforceYellow)
		}

		adsRow.title = "Enable Ads"

		form
			+++ Section("")
			<<< ButtonRow {
					$0.title = "Help"
				}
				.onCellSelection { [unowned self] (_, _) in
					self.help()
				}
			+++ Section("")
			<<< ButtonRow {
					$0.title = "Reset"
				}
				.onCellSelection { [unowned self] (_, _) in
					self.reset()
				}
			+++ Section("Advertisements")
			<<< adsRow
	}

	private func help() {
		let viewController = HelpViewController()
		navigationController?.pushViewController(viewController, animated: true)
	}

	private func reset() {
		let alertController = UIAlertController(title: "Randorganizer",
												message: "Reset the game, including all selected items, locations, and dungeon data?",
												preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		alertController.addAction(UIAlertAction(title: "Reset", style: .default) { [unowned self] (_) in
			self.delegate?.settingsViewControllerDidReset(self)
		})
		present(alertController, animated: true, completion: nil)
	}
}

// MARK: - `RxBinder` -
extension SettingsViewController: RxBinder {
	func setUpBindings() {
		viewModel.adsEnabled
			.bind(to: adsRow.rx.value)
			.disposed(by: disposeBag)

		adsRow.rx.value
			.map { $0 ?? false }
			.subscribe(onNext: { [unowned self] in self.delegate?.settingsViewController(self, didSetAdsEnabled: $0) })
			.disposed(by: disposeBag)
	}
}
