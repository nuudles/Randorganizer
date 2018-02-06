//
//  MapViewController.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/26/18.
//

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

	private let toggleBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
	private let mapImageView = ZoomImageView()
	private let lightWorldButtons: [LocationButton: Location]
	private let darkWorldButtons: [LocationButton: Location]
	private let lightWorldDungeonViews: [Dungeon: DungeonLocationView]
	private let darkWorldDungeonViews: [Dungeon: DungeonLocationView]

	// MARK: - Initialization -
	init(locationAvailabilities: Observable<[Location: Availability]>,
		 chestAndBossAvailabilities: Observable<[Dungeon: (Availability, Availability)]>) {
		self.viewModel = MapViewModel(locationAvailabilities: locationAvailabilities,
									  chestAndBossAvailabilities: chestAndBossAvailabilities)

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

		navigationItem.rightBarButtonItem = toggleBarButtonItem
		toggleBarButtonItem.target = self
		toggleBarButtonItem.action = #selector(toggleButtonTapped)
	}

	func addSubviews() {
		addImageView()
		addLocationButtons()
		addDungeonViews()
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
}

// MARK: - `RxBinder` -
extension MapViewController: RxBinder {
	func setupBindings() {
		viewModel.world
			.map { $0 == .light ? "Dark" : "Light" }
			.bind(to: toggleBarButtonItem.rx.title)
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
	}
}

private extension Location {
	var offset: CGPoint {
		switch self {
		case .kingsTomb:
			return CGPoint(x: 61.6, y: 29.6)
		case .lightWorldSwamp:
			return CGPoint(x: 46.8, y: 93.4)
		case .linksHouse:
			return CGPoint(x: 54.8, y: 67.9)
		case .spiralCave:
			return CGPoint(x: 79.8, y: 9.3)
		case .mimicCave:
			return CGPoint(x: 85.2, y: 9.3)
		case .tavern:
			return CGPoint(x: 16.2, y: 57.8)
		case .chickenHouse:
			return CGPoint(x: 8.8, y: 54.2)
		case .aginahsCave:
			return CGPoint(x: 20, y: 82.6)
		case .sahasrahlasHut:
			return CGPoint(x: 81.4, y: 41.4)
		case .kakarikoWell:
			return CGPoint(x: 3, y: 41)
		case .blindsHut:
			return CGPoint(x: 12.8, y: 41)
		case .paradoxCave:
			return CGPoint(x: 82.8, y: 17.1)
		case .bonkRocks:
			return CGPoint(x: 39, y: 29.3)
		case .miniMoldormCave:
			return CGPoint(x: 65.2, y: 93.4)
		case .iceRodCave:
			return CGPoint(x: 89.2, y: 76.9)
		case .bottleVendor:
			return CGPoint(x: 9, y: 46.8)
		case .sahasrahlasReward:
			return CGPoint(x: 81.4, y: 46.7)
		case .sickKid:
			return CGPoint(x: 15.6, y: 52.1)
		case .bridgeHideout:
			return CGPoint(x: 70.8, y: 69.7)
		case .etherTablet:
			return CGPoint(x: 42, y: 3)
		case .bombosTablet:
			return CGPoint(x: 22, y: 92.2)
		case .kingZora:
			return CGPoint(x: 96, y: 12.1)
		case .lostOldMan:
			return CGPoint(x: 41.6, y: 20.4)
		case .potionShop:
			return CGPoint(x: 81.6, y: 32.5)
		case .forestHideout:
			return CGPoint(x: 18.8, y: 13)
		case .lumberjackTree:
			return CGPoint(x: 30.4, y: 7.6)
		case .spectacleRockCave:
			return CGPoint(x: 48.6, y: 14.8)
		case .mirrorCave:
			return CGPoint(x: 28.2, y: 84.1)
		case .graveyardCliffCave:
			return CGPoint(x: 56.2, y: 27)
		case .checkerboardCave:
			return CGPoint(x: 17.6, y: 77.3)
		case .library:
			return CGPoint(x: 15.4, y: 65.9)
		case .mushroom:
			return CGPoint(x: 12.4, y: 8.6)
		case .spectacleRock:
			return CGPoint(x: 50.8, y: 8.5)
		case .floatingIsland:
			return CGPoint(x: 80.4, y: 3)
		case .raceMinigame:
			return CGPoint(x: 3.6, y: 69.8)
		case .desertWestLedge:
			return CGPoint(x: 3, y: 91)
		case .lakeHyliaIsland:
			return CGPoint(x: 72.2, y: 82.9)
		case .zoraLedge:
			return CGPoint(x: 95.4, y: 17.3)
		case .buriedItem:
			return CGPoint(x: 28.8, y: 66.2)
		case .sewerEscapeSideRoom:
			return CGPoint(x: 53.6, y: 32.4)
		case .castleSecretEntrance:
			return CGPoint(x: 59.6, y: 41.8)
		case .castleDungeon:
			return CGPoint(x: 50, y: 44.1)
		case .sanctuary:
			return CGPoint(x: 46, y: 28)
		case .madBatter:
			return CGPoint(x: 33, y: 56)
		case .dwarfEscort:
			return CGPoint(x: 30.4, y: 51.8)
		case .masterSwordPedestal:
			return CGPoint(x: 5, y: 3.2)
		case .sewerEscapeDarkRoom:
			return CGPoint(x: 51.2, y: 38.2)
		case .waterfallOfWishing:
			return CGPoint(x: 89.8, y: 14.7)
		case .bombableHut:
			return CGPoint(x: 10.8, y: 57.8)
		case .cShapedHouse:
			return CGPoint(x: 21.6, y: 47.9)
		case .mireHut:
			return CGPoint(x: 3.4, y: 79.5)
		case .superBunnyCave:
			return CGPoint(x: 85.6, y: 14.7)
		case .spikeCave:
			return CGPoint(x: 57.2, y: 14.9)
		case .hypeCave:
			return CGPoint(x: 60, y: 77.1)
		case .hookshotCaveBottom:
			return CGPoint(x: 83.2, y: 8.6)
		case .hookshotCaveTop:
			return CGPoint(x: 83.2, y: 3.4)
		case .treasureChestMinigame:
			return CGPoint(x: 4.2, y: 46.4)
		case .stumpKid:
			return CGPoint(x: 31, y: 68.6)
		case .purpleChest:
			return CGPoint(x: 30.4, y: 52.2)
		case .catfish:
			return CGPoint(x: 92, y: 17.2)
		case .hammerPegCave:
			return CGPoint(x: 31.6, y: 60.1)
		case .bumperCave:
			return CGPoint(x: 34.2, y: 15.2)
		case .pyramid:
			return CGPoint(x: 58, y: 43.5)
		case .diggingGame:
			return CGPoint(x: 5.8, y: 69.2)
		case .pyramidFairy:
			return CGPoint(x: 47, y: 48.5)
		}
	}
}

private extension Dungeon {
	var offset: CGPoint {
		switch self {
		case .castleTower:
			return CGPoint(x: 50, y: 52.6)
		case .easternPalace:
			return CGPoint(x: 94.6, y: 38.8)
		case .desertPalace:
			return CGPoint(x: 7.6, y: 78.4)
		case .towerOfHera:
			return CGPoint(x: 62, y: 5.5)
		case .palaceOfDarkness:
			return CGPoint(x: 94, y: 40)
		case .swampPalace:
			return CGPoint(x: 47, y: 91)
		case .skullWoods:
			return CGPoint(x: 6.6, y: 5.4)
		case .thievesTown:
			return CGPoint(x: 12.8, y: 47.9)
		case .icePalace:
			return CGPoint(x: 79.6, y: 85.8)
		case .miseryMire:
			return CGPoint(x: 11.6, y: 82.9)
		case .turtleRock:
			return CGPoint(x: 93.8, y: 7)
		case .ganonsTower:
			return CGPoint(x: 58, y: 5.5)
		}
	}
}
