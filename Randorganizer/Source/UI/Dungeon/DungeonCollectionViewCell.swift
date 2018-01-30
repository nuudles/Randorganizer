//
//  DungeonCollectionViewCell.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/28/18.
//

import RxSwift
import UIKit

final class DungeonCollectionViewCell: UICollectionViewCell {
	// MARK: - Properties -
	private let viewModel = DungeonCellViewModel()
	private let disposeBag = DisposeBag()

	private let imageView = UIImageView()

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
	}

	private func addImageView() {
		contentView.addSubview(imageView)

		imageView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
	}
}

// MARK: - `RxBinder` -
extension DungeonCollectionViewCell: RxBinder {
	func setupBindings() {
		Observable.combineLatest(viewModel.dungeon, viewModel.isComplete)
			.subscribe(onNext: { [unowned self] in self.updateImageView(with: $0, isComplete: $1) })
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
		case .ganonsTower: imageView.image = #imageLiteral(resourceName: "ganonTower")
		}
		imageView.alpha = isComplete ? 1.0 : 0.3
	}
}
