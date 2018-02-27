//
//  DungeonLocationView.swift
//  Randorganizer
//
//  Created by Christopher Luu on 2/4/18.
//

import UIKit

final class DungeonLocationView: UIView {
	// MARK: - Constants -
	static let size = CGSize(width: 32, height: 32)

	// MARK: - Properties -
	private let imageBackgroundView = UIView()
	private let imageView = UIImageView()
	private let rewardImageView = UIImageView()

	// MARK: - Initializations -
	init(dungeon: Dungeon) {
		super.init(frame: .zero)

		instantiateView()

		update(with: dungeon)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("This init method shouldn't ever be used")
	}

	// MARK: - Private Functions -
	private func update(with dungeon: Dungeon) {
		imageView.image = dungeon.image

		rewardImageView.isHidden = (dungeon == .castleTower || dungeon == .ganonsTower)
	}

	// MARK: - Internal Functions -
	func update(with availabilities: (Availability, Availability)) {
		let (chestAvailability, bossAvailability) = availabilities

		switch chestAvailability {
		case .completed: backgroundColor = .gray
		case .unavailable: backgroundColor = .red
		case .visible, .glitchesVisible: backgroundColor = .orange
		case .possible: backgroundColor = .yellow
		case .available, .glitches: backgroundColor = .cyan
		}
		layer.borderColor = (chestAvailability == .glitches || chestAvailability == .glitchesVisible)
			? UIColor.white.cgColor : UIColor.black.cgColor

		switch bossAvailability {
		case .completed: imageBackgroundView.backgroundColor = .gray
		case .unavailable: imageBackgroundView.backgroundColor = .red
		case .visible, .glitchesVisible: imageBackgroundView.backgroundColor = .orange
		case .possible: imageBackgroundView.backgroundColor = .yellow
		case .available, .glitches: imageBackgroundView.backgroundColor = .cyan
		}
		imageBackgroundView.layer.borderColor = (bossAvailability == .glitches || bossAvailability == .glitchesVisible)
			? UIColor.white.cgColor : UIColor.black.cgColor
	}

	func update(with reward: DungeonConfiguration.Reward?) {
		let image: UIImage

		switch reward {
		case .some(.greenPendant): image = #imageLiteral(resourceName: "reward-greenPendant")
		case .some(.otherPendant): image = #imageLiteral(resourceName: "reward-standardPendant")
		case .some(.crystal): image = #imageLiteral(resourceName: "reward-standardCrystal")
		case .some(.redCrystal): image = #imageLiteral(resourceName: "reward-fairyCrystal")
		default: image = #imageLiteral(resourceName: "reward-unknown")
		}
		rewardImageView.image = image
	}
}

// MARK: - `ViewCustomizer` -
extension DungeonLocationView: ViewCustomizer {
	func styleView() {
		layer.borderWidth = 2
	}

	func addSubviews() {
		addImageView()
		addRewardImageView()
	}

	private func addImageView() {
		addSubview(imageBackgroundView)
		imageBackgroundView.layer.borderWidth = 1

		imageBackgroundView.addSubview(imageView)
		imageView.contentMode = .scaleAspectFit

		imageBackgroundView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview().inset(6.0)
		}
		imageView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview().inset(3.0)
		}
	}

	private func addRewardImageView() {
		addSubview(rewardImageView)

		rewardImageView.snp.makeConstraints { (make) in
			make.centerX.equalTo(imageView.snp.trailing)
			make.centerY.equalTo(imageView.snp.top)
			make.width.height.equalTo(10)
		}
	}
}

private extension Dungeon {
	var image: UIImage? {
		switch self {
		case .castleTower: return #imageLiteral(resourceName: "agahnim0")
		case .easternPalace: return #imageLiteral(resourceName: "armosKnights")
		case .desertPalace: return #imageLiteral(resourceName: "lanmolas")
		case .towerOfHera: return #imageLiteral(resourceName: "moldorm")
		case .palaceOfDarkness: return #imageLiteral(resourceName: "helmasaurKing")
		case .swampPalace: return #imageLiteral(resourceName: "arrghus")
		case .skullWoods: return #imageLiteral(resourceName: "mothula")
		case .thievesTown: return #imageLiteral(resourceName: "blind")
		case .icePalace: return #imageLiteral(resourceName: "kholdstare")
		case .miseryMire: return #imageLiteral(resourceName: "vitreous")
		case .turtleRock: return #imageLiteral(resourceName: "trinexx")
		case .ganonsTower: return #imageLiteral(resourceName: "ganon")
		}
	}
}
