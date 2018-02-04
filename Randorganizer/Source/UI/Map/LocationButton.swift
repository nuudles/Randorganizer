//
//  LocationButton.swift
//  Randorganizer
//
//  Created by Christopher Luu on 2/4/18.
//

import UIKit

final class LocationButton: UIButton {
	// MARK: - Enums -
	fileprivate enum LocationType {
		case outside
		case pit
		case single
		case multiple
	}

	// MARK: - Constants -
	static let size = CGSize(width: 16, height: 16)
	static let availabilityColors: [Availability: UIImage?] = [
		.completed: UIImage(color: .gray),
		.unavailable: UIImage(color: .red),
		.visible: UIImage(color: .orange),
		.glitchesVisible: UIImage(color: .orange),
		.possible: UIImage(color: .yellow),
		.available: UIImage(color: .cyan),
		.glitches: UIImage(color: .cyan)
	]

	// MARK: - Properties -
	private let borderLayer = CAShapeLayer()

	// MARK: - Initializations -
	init(location: Location) {
		super.init(frame: .zero)

		style(with: location.type)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("This init method shouldn't ever be used")
	}

	// MARK: - Private Functions -
	private func style(with type: LocationType) {
		let bezierPath: UIBezierPath
		switch type {
		case .outside:
			bezierPath = UIBezierPath(ovalIn: CGRect(x: 0,
													 y: 0,
													 width: LocationButton.size.width,
													 height: LocationButton.size.height))
		case .pit:
			bezierPath = UIBezierPath()
			bezierPath.move(to: .zero)
			bezierPath.addLine(to: CGPoint(x: LocationButton.size.width, y: 0))
			bezierPath.addLine(to: CGPoint(x: LocationButton.size.width / 2.0, y: LocationButton.size.height))
			bezierPath.close()
		case .single:
			bezierPath = UIBezierPath(rect: CGRect(x: 0,
												   y: 0,
												   width: LocationButton.size.width,
												   height: LocationButton.size.height))
		case .multiple:
			bezierPath = UIBezierPath()
			bezierPath.move(to: CGPoint(x: 0, y: LocationButton.size.height / 2.0))
			bezierPath.addLine(to: CGPoint(x: LocationButton.size.width / 2.0, y: 0))
			bezierPath.addLine(to: CGPoint(x: LocationButton.size.width, y: LocationButton.size.height / 2.0))
			bezierPath.addLine(to: CGPoint(x: LocationButton.size.width / 2.0, y: LocationButton.size.height))
			bezierPath.close()
		}

		let mask = CAShapeLayer()
		mask.path = bezierPath.cgPath
		layer.mask = mask

		borderLayer.lineWidth = 2
		borderLayer.fillColor = nil
		borderLayer.path = bezierPath.cgPath
		layer.addSublayer(borderLayer)
	}

	// MARK: - Internal Functions -
	func update(availability: Availability) {
		setBackgroundImage(LocationButton.availabilityColors[availability] ?? nil, for: .normal)

		borderLayer.strokeColor = (availability != .glitches && availability != .glitchesVisible) ?
			UIColor.black.cgColor : UIColor.white.cgColor
	}
}

private extension Location {
	var type: LocationButton.LocationType {
		switch self {
		case .kingsTomb:
			return .single
		case .lightWorldSwamp:
			return .single
		case .linksHouse:
			return .single
		case .spiralCave:
			return .multiple
		case .mimicCave:
			return .single
		case .tavern:
			return .single
		case .chickenHouse:
			return .single
		case .aginahsCave:
			return .single
		case .sahasrahlasHut:
			return .single
		case .kakarikoWell:
			return .pit
		case .blindsHut:
			return .single
		case .paradoxCave:
			return .multiple
		case .bonkRocks:
			return .single
		case .miniMoldormCave:
			return .single
		case .iceRodCave:
			return .single
		case .bottleVendor:
			return .outside
		case .sahasrahlasReward:
			return .outside
		case .sickKid:
			return .single
		case .bridgeHideout:
			return .outside
		case .etherTablet:
			return .outside
		case .bombosTablet:
			return .outside
		case .kingZora:
			return .outside
		case .lostOldMan:
			return .multiple
		case .potionShop:
			return .single
		case .forestHideout:
			return .pit
		case .lumberjackTree:
			return .pit
		case .spectacleRockCave:
			return .multiple
		case .mirrorCave:
			return .single
		case .graveyardCliffCave:
			return .single
		case .checkerboardCave:
			return .single
		case .library:
			return .single
		case .mushroom:
			return .outside
		case .spectacleRock:
			return .outside
		case .floatingIsland:
			return .outside
		case .raceMinigame:
			return .outside
		case .desertWestLedge:
			return .outside
		case .lakeHyliaIsland:
			return .outside
		case .zoraLedge:
			return .outside
		case .buriedItem:
			return .outside
		case .sewerEscapeSideRoom:
			return .multiple
		case .castleSecretEntrance:
			return .pit
		case .castleDungeon:
			return .multiple
		case .sanctuary:
			return .multiple
		case .madBatter:
			return .pit
		case .dwarfEscort:
			return .outside
		case .masterSwordPedestal:
			return .outside
		case .sewerEscapeDarkRoom:
			return .multiple
		case .waterfallOfWishing:
			return .single
		case .bombableHut:
			return .single
		case .cShapedHouse:
			return .single
		case .mireHut:
			return .single
		case .superBunnyCave:
			return .multiple
		case .spikeCave:
			return .single
		case .hypeCave:
			return .single
		case .hookshotCaveBottom:
			return .multiple
		case .hookshotCaveTop:
			return .multiple
		case .treasureChestMinigame:
			return .single
		case .stumpKid:
			return .outside
		case .purpleChest:
			return .outside
		case .catfish:
			return .outside
		case .hammerPegCave:
			return .single
		case .bumperCave:
			return .multiple
		case .pyramid:
			return .outside
		case .diggingGame:
			return .outside
		case .pyramidFairy:
			return .single
		}
	}
}
