//
//  DungeonCollectionViewCell.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/28/18.
//

import RxSwift
import UIKit

protocol DungeonCollectionViewCellDelegate: class {
	func dungeonCollectionViewCell(_ cell: DungeonCollectionViewCell, didToggleChestsFor dungeon: Dungeon)
	func dungeonCollectionViewCell(_ cell: DungeonCollectionViewCell, didToggleRewardFor dungeon: Dungeon)
	func dungeonCollectionViewCell(_ cell: DungeonCollectionViewCell, didToggleMedallionFor dungeon: Dungeon)
}

final class DungeonCollectionViewCell: UICollectionViewCell {
	// MARK: - Properties -
	private let viewModel = DungeonCellViewModel()
	private let disposeBag = DisposeBag()
	private let dungeon = Variable<Dungeon?>(nil)

	weak var delegate: DungeonCollectionViewCellDelegate?

	private let imageView = UIImageView()
	private let chestButton = UIButton()
	private let rewardButton = UIButton()
	private let medallionButton = UIButton()

	// MARK: - Initializations -
	override init(frame: CGRect) {
		super.init(frame: frame)

		instantiateView()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("This init method shouldn't ever be used")
	}

	// MARK: - Internal Functions -
	func update(with configuration: DungeonConfiguration) {
		viewModel.update(with: configuration)
	}
}

// MARK: - `ViewCustomizer` -
extension DungeonCollectionViewCell: ViewCustomizer {
	func styleView() {

	}

	func addSubviews() {
		addImageView()
		addChestButton()
		addRewardButton()
		addMedallionButton()
	}

	private func addImageView() {
		contentView.addSubview(imageView)
		imageView.contentMode = .scaleAspectFit

		imageView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
	}

	private func addChestButton() {
		contentView.addSubview(chestButton)
		chestButton.setBackgroundImage(#imageLiteral(resourceName: "keychest"), for: .normal)
		chestButton.setBackgroundImage(#imageLiteral(resourceName: "keychest0"), for: .selected)
		chestButton.setTitleColor(.black, for: .normal)
		chestButton.titleLabel?.font = .pressStartFont(ofSize: 12)
		chestButton.setTitle(nil, for: .selected)
		chestButton.addTarget(self, action: #selector(chestButtonTapped), for: .touchUpInside)

		chestButton.snp.makeConstraints { (make) in
			make.leading.equalToSuperview().offset(5)
			make.bottom.equalToSuperview().inset(5)
			make.width.height.equalTo(32)
		}
	}

	private func addRewardButton() {
		contentView.addSubview(rewardButton)
		rewardButton.addTarget(self, action: #selector(rewardButtonTapped), for: .touchUpInside)

		rewardButton.snp.makeConstraints { (make) in
			make.trailing.equalToSuperview().inset(5)
			make.top.equalToSuperview().offset(5)
			make.width.height.equalTo(32)
		}
	}

	private func addMedallionButton() {
		contentView.addSubview(medallionButton)
		medallionButton.addTarget(self, action: #selector(medallionButtonTapped), for: .touchUpInside)

		medallionButton.snp.makeConstraints { (make) in
			make.trailing.equalToSuperview().inset(5)
			make.top.equalTo(rewardButton.snp.bottom).offset(5)
			make.width.height.equalTo(32)
		}
	}

	// MARK: - Control Targets -
	@objc private func chestButtonTapped() {
		guard let dungeon = dungeon.value else { return }
		delegate?.dungeonCollectionViewCell(self, didToggleChestsFor: dungeon)
	}

	@objc private func rewardButtonTapped() {
		guard let dungeon = dungeon.value else { return }
		delegate?.dungeonCollectionViewCell(self, didToggleRewardFor: dungeon)
	}

	@objc private func medallionButtonTapped() {
		guard let dungeon = dungeon.value else { return }
		delegate?.dungeonCollectionViewCell(self, didToggleMedallionFor: dungeon)
	}
}

// MARK: - `RxBinder` -
extension DungeonCollectionViewCell: RxBinder {
	func setUpBindings() {
		Observable.combineLatest(viewModel.dungeon, viewModel.isComplete)
			.subscribe(onNext: { [unowned self] in self.updateImageView(with: $0, isComplete: $1) })
			.disposed(by: disposeBag)

		viewModel.dungeon
			.bind(to: dungeon)
			.disposed(by: disposeBag)

		viewModel.remainingChests
			.bind(to: chestButton.rx.title(for: .normal))
			.disposed(by: disposeBag)

		viewModel.remainingChests
			.map { $0.isEmpty }
			.bind(to: chestButton.rx.isSelected)
			.disposed(by: disposeBag)

		viewModel.hasReward
			.map { !$0 }
			.bind(to: rewardButton.rx.isHidden)
			.disposed(by: disposeBag)

		viewModel.reward
			.subscribe(onNext: { [unowned self] in self.updateRewardButton(with: $0) })
			.disposed(by: disposeBag)

		viewModel.needsMedallion
			.map { !$0 }
			.bind(to: medallionButton.rx.isHidden)
			.disposed(by: disposeBag)

		viewModel.requiredMedallion
			.subscribe(onNext: { [unowned self] in self.updateMedallionButton(with: $0) })
			.disposed(by: disposeBag)
	}

	private func updateImageView(with dungeon: Dungeon, isComplete: Bool) {
		switch dungeon {
		case .castleTower where !isComplete: imageView.image = #imageLiteral(resourceName: "agahnim0")
		case .castleTower: imageView.image = #imageLiteral(resourceName: "agahnim1")
		case .easternPalace: imageView.image = #imageLiteral(resourceName: "armosKnights")
		case .desertPalace: imageView.image = #imageLiteral(resourceName: "lanmolas")
		case .towerOfHera: imageView.image = #imageLiteral(resourceName: "moldorm")
		case .palaceOfDarkness: imageView.image = #imageLiteral(resourceName: "helmasaurKing")
		case .swampPalace: imageView.image = #imageLiteral(resourceName: "arrghus")
		case .skullWoods: imageView.image = #imageLiteral(resourceName: "mothula")
		case .thievesTown: imageView.image = #imageLiteral(resourceName: "blind")
		case .icePalace: imageView.image = #imageLiteral(resourceName: "kholdstare")
		case .miseryMire: imageView.image = #imageLiteral(resourceName: "vitreous")
		case .turtleRock: imageView.image = #imageLiteral(resourceName: "trinexx")
		case .ganonsTower: imageView.image = #imageLiteral(resourceName: "ganon")
		}
		imageView.alpha = isComplete ? 1.0 : 0.3
	}

	private func updateRewardButton(with reward: DungeonConfiguration.Reward?) {
		let image: UIImage

		switch reward {
		case .some(.greenPendant): image = #imageLiteral(resourceName: "reward-greenPendant")
		case .some(.otherPendant): image = #imageLiteral(resourceName: "reward-standardPendant")
		case .some(.crystal): image = #imageLiteral(resourceName: "reward-standardCrystal")
		case .some(.redCrystal): image = #imageLiteral(resourceName: "reward-fairyCrystal")
		default: image = #imageLiteral(resourceName: "reward-unknown")
		}
		rewardButton.setImage(image, for: .normal)
	}

	private func updateMedallionButton(with medallion: Item?) {
		let image: UIImage

		switch medallion {
		case .some(.bombos): image = #imageLiteral(resourceName: "medallion-bombos")
		case .some(.ether): image = #imageLiteral(resourceName: "medallion-ether")
		case .some(.quake): image = #imageLiteral(resourceName: "medallion-quake")
		default: image = #imageLiteral(resourceName: "medallion-unknown")
		}
		medallionButton.setImage(image, for: .normal)
	}
}
