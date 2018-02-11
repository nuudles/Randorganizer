//
//  SettingsViewController.swift
//  Randorganizer
//
//  Created by Christopher Luu on 2/7/18.
//

import Eureka
import UIKit

protocol SettingsViewControllerDelegate: class {
	func settingsViewControllerDidReset(_ viewController: SettingsViewController)
}

final class SettingsViewController: FormViewController {
	// MARK: - Properties -
	weak var delegate: SettingsViewControllerDelegate?
	// MARK: - Initializations -
	init() {
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
			cell.contentView.backgroundColor = UIColor(.darkGray)
			cell.textLabel?.font = .returnOfGanonFont(ofSize: 30)

			let selectedView = UIView()
			selectedView.backgroundColor = UIColor(.darkGreen)
			cell.selectedBackgroundView = selectedView
		}
		ButtonRow.defaultCellUpdate = { (cell, row) in
			cell.textLabel?.textColor = UIColor(.triforceYellow)
		}
		form +++ Section("")
			<<< ButtonRow {
					$0.title = "Reset"
				}
				.onCellSelection { [unowned self] (_, _) in
					self.reset()
				}
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
