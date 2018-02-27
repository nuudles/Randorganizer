//
//  MapViewController.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/26/18.
//

import EasyTipView
import RxSwift
import SnapKit
import UIKit
import ZoomImageView

protocol MapViewControllerDelegate: class {
	func mapViewController(_ viewController: MapViewController, didToggle location: Location)
}

final class MapViewController: UIViewController {
	// MARK: - Properties -
	private let viewModel: MapViewModel
	private let disposeBag = DisposeBag()

	weak var delegate: MapViewControllerDelegate?

	private let toggleButton = UIButton()
	private let mapImageView = ZoomImageView()
	private let lightWorldButtons: [LocationButton: Location]
	private let darkWorldButtons: [LocationButton: Location]
	private let lightWorldDungeonViews: [Dungeon: DungeonLocationView]
	private let darkWorldDungeonViews: [Dungeon: DungeonLocationView]
	private weak var tipView: EasyTipView?

	// MARK: - Initialization -
	init(locationAvailabilities: Observable<[Location: Availability]>,
		 chestAndBossAvailabilities: Observable<[Dungeon: (Availability, Availability)]>,
		 dungeons: Observable<[DungeonConfiguration]>) {
		self.viewModel = MapViewModel(locationAvailabilities: locationAvailabilities,
									  chestAndBossAvailabilities: chestAndBossAvailabilities,
									  dungeons: dungeons)

		lightWorldButtons = Location.lightWorldLocations
			.reduce([LocationButton: Location]()) { (result, location) in
				var result = result
				result[LocationButton(location: location)] = location
				return result
			}
		darkWorldButtons = Location.darkWorldLocations
			.reduce([LocationButton: Location]()) { (result, location) in
				var result = result
				result[LocationButton(location: location)] = location
				return result
			}
		lightWorldDungeonViews = Dungeon.lightWorldDungeons
			.reduce([Dungeon: DungeonLocationView]()) { (result, dungeon) in
				var result = result
				result[dungeon] = DungeonLocationView(dungeon: dungeon)
				return result
			}
		darkWorldDungeonViews = Dungeon.darkWorldDungeons
			.reduce([Dungeon: DungeonLocationView]()) { (result, dungeon) in
				var result = result
				result[dungeon] = DungeonLocationView(dungeon: dungeon)
				return result
			}

		super.init(nibName: nil, bundle: nil)

		title = "Map"
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle -
	override func viewDidLoad() {
		super.viewDidLoad()

		instantiateView()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		let size = min(mapImageView.bounds.size.width, mapImageView.bounds.size.height)
		lightWorldButtons.forEach { (button, location) in
			button.transform = CGAffineTransform(translationX: size * location.offset.x / 100.0,
												 y: size * location.offset.y / 100.0)
		}
		darkWorldButtons.forEach { (button, location) in
			button.transform = CGAffineTransform(translationX: size * location.offset.x / 100.0,
												 y: size * location.offset.y / 100.0)
		}
		lightWorldDungeonViews.forEach { (dungeon, dungeonView) in
			dungeonView.transform = CGAffineTransform(translationX: size * dungeon.offset.x / 100.0,
												 y: size * dungeon.offset.y / 100.0)
		}
		darkWorldDungeonViews.forEach { (dungeon, dungeonView) in
			dungeonView.transform = CGAffineTransform(translationX: size * dungeon.offset.x / 100.0,
													  y: size * dungeon.offset.y / 100.0)
		}
	}
}

// MARK: - `ViewCustomizer` -
extension MapViewController: ViewCustomizer {
	func styleView() {
		view.backgroundColor = .black
	}

	func addSubviews() {
		addToggleButton()
		addImageView()
		addLocationButtons()
		addDungeonViews()
	}

	private func addToggleButton() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: toggleButton)
		toggleButton.addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)
	}

	private func addImageView() {
		view.addSubview(mapImageView)
		mapImageView.imageView.isUserInteractionEnabled = true

		mapImageView.snp.makeConstraints { (make) in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(safeTop)
			make.bottom.equalTo(safeBottom)
		}
	}

	private func addLocationButtons() {
		(Array(lightWorldButtons.keys) + Array(darkWorldButtons.keys)).forEach { (button) in
			mapImageView.imageView.addSubview(button)
			button.addTarget(self, action: #selector(locationButtonTapped(_:)), for: .touchUpInside)

			let gestureRecognizer = UILongPressGestureRecognizer(target: self,
																 action: #selector(longPressRecognized(_:)))
			button.addGestureRecognizer(gestureRecognizer)

			button.snp.makeConstraints { (make) in
				make.centerX.equalTo(mapImageView.imageView.snp.left)
				make.centerY.equalTo(mapImageView.imageView.snp.top)
				make.size.equalTo(LocationButton.size)
			}
		}
	}

	private func addDungeonViews() {
		(Array(lightWorldDungeonViews.values) + Array(darkWorldDungeonViews.values)).forEach { (dungeonView) in
			mapImageView.imageView.addSubview(dungeonView)

			dungeonView.snp.makeConstraints { (make) in
				make.centerX.equalTo(mapImageView.imageView.snp.left)
				make.centerY.equalTo(mapImageView.imageView.snp.top)
				make.size.equalTo(DungeonLocationView.size)
			}
		}
	}

	// MARK: - Control Action Functions -
	@objc private func toggleButtonTapped() {
		UIView.transition(
			with: mapImageView,
			duration: 0.3,
			options: .transitionFlipFromLeft,
			animations: { [unowned self] in
				self.viewModel.toggleWorld()
			},
			completion: nil
		)
	}

	@objc private func locationButtonTapped(_ sender: LocationButton) {
		guard let location = lightWorldButtons[sender] ?? darkWorldButtons[sender] else { return }
		delegate?.mapViewController(self, didToggle: location)
	}

	// MARK: - UIGestureRecognizer Callback Functions -
	@objc private func longPressRecognized(_ recognizer: UILongPressGestureRecognizer) {
		if recognizer.state == .ended || recognizer.state == .cancelled {
			tipView?.dismiss()
		}

		guard recognizer.state == .began,
			let button = recognizer.view as? LocationButton,
			let location = lightWorldButtons[button] ?? darkWorldButtons[button]
			else { return }

		var preferences = EasyTipView.Preferences()
		preferences.drawing.backgroundColor = .black
		preferences.drawing.foregroundColor = .white
		preferences.drawing.font = .returnOfGanonFont(ofSize: 18)
		let tip = EasyTipView(text: location.title, preferences: preferences)
		tip.show(forView: button)

		tipView = tip
	}
}

// MARK: - `RxBinder` -
extension MapViewController: RxBinder {
	func setUpBindings() {
		viewModel.world
			.map { $0 == .light ? #imageLiteral(resourceName: "darkWorldTile") : #imageLiteral(resourceName: "magicMirror") }
			.bind(to: toggleButton.rx.image(for: .normal))
			.disposed(by: disposeBag)

		viewModel.world
			.map { $0 == .light ? #imageLiteral(resourceName: "light-world"): #imageLiteral(resourceName: "dark-world") }
			.bind(to: mapImageView.rx.image)
			.disposed(by: disposeBag)

		viewModel.world
			.subscribe(
				onNext: { [unowned self] (world) in
					self.lightWorldButtons.keys.forEach { $0.isHidden = (world != .light) }
					self.darkWorldButtons.keys.forEach { $0.isHidden = (world != .dark) }
					self.lightWorldDungeonViews.values.forEach { $0.isHidden = (world != .light) }
					self.darkWorldDungeonViews.values.forEach { $0.isHidden = (world != .dark) }
				}
			)
			.disposed(by: disposeBag)

		viewModel.locationAvailabilities
			.subscribe(
				onNext: { [unowned self] (locationAvailabilities) in
					let closure = { (button: LocationButton, location: Location) in
						button.update(availability: locationAvailabilities[location] ?? .unavailable)
					}
					self.lightWorldButtons.forEach(closure)
					self.darkWorldButtons.forEach(closure)
				}
			)
			.disposed(by: disposeBag)

		viewModel.chestAndBossAvailabilities
			.subscribe(
				onNext: { [unowned self] in
					$0.forEach { (dungeon, availabilities) in
						let dungeonView = self.lightWorldDungeonViews[dungeon] ?? self.darkWorldDungeonViews[dungeon]
						dungeonView?.update(with: availabilities)
					}
				}
			)
			.disposed(by: disposeBag)

		viewModel.dungeons
			.subscribe(
				onNext: { [unowned self] (dungeons) in
					dungeons.forEach {
						let dungeonView = self.lightWorldDungeonViews[$0.dungeon] ??
							self.darkWorldDungeonViews[$0.dungeon]
						dungeonView?.update(with: $0.reward)
					}
				}
			)
			.disposed(by: disposeBag)
	}
}
