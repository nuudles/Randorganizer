//
//  DungeonViewController.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/26/18.
//

import RxDataSources
import RxSwift
import SnapKit
import UIKit

protocol DungeonViewControllerDelegate: class {
	func dungeonViewController(_ viewController: DungeonViewController, didToggle dungeon: Dungeon)
	func dungeonViewController(_ viewController: DungeonViewController, didToggleChestsFor dungeon: Dungeon)
	func dungeonViewController(_ viewController: DungeonViewController, didToggleRewardFor dungeon: Dungeon)
	func dungeonViewController(_ viewController: DungeonViewController, didToggleMedallionFor dungeon: Dungeon)
}

final class DungeonViewController: UIViewController {
	// MARK: - Properties -
	private let viewModel: DungeonViewModel
	private let disposeBag = DisposeBag()

	weak var delegate: DungeonViewControllerDelegate?

	private let dataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<Int, DungeonConfiguration>>(
		configureCell: { (_, _, _, _) in
			return UICollectionViewCell()
		},
		configureSupplementaryView: { (_, _, _, _) in
			return UICollectionReusableView()
		}
	)
	private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

	// MARK: - Initialization -
	init(dungeons: Observable<[DungeonConfiguration]>) {
		self.viewModel = DungeonViewModel(dungeons: dungeons)

		super.init(nibName: nil, bundle: nil)

		title = "Dungeons"
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle -
	override func viewDidLoad() {
		super.viewDidLoad()

		setUpDataSource()
		instantiateView()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		collectionView.collectionViewLayout.invalidateLayout()
	}

	// MARK: - Private Functions -
	private func setUpDataSource() {
		dataSource.configureCell = { [unowned self] (_, collectionView, indexPath, item) in
			let cell: DungeonCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
			cell.delegate = self
			cell.update(with: item)
			return cell
		}
	}
}

// MARK: - `ViewCustomizer` -
extension DungeonViewController: ViewCustomizer {
	// MARK: - Constants -

	func styleView() {
	}

	func addSubviews() {
		addCollectionView()
	}

	private func addCollectionView() {
		view.addSubview(collectionView)
		collectionView.registerClassForCellReuse(DungeonCollectionViewCell.self)

		guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0

		collectionView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
	}
}

// MARK: - `RxBinder` -
extension DungeonViewController: RxBinder {
	func setupBindings() {
		collectionView.rx
			.setDelegate(self)
			.disposed(by: disposeBag)

		viewModel.dungeons
			.map { [AnimatableSectionModel(model: 0, items: $0)] }
			.bind(to: collectionView.rx.items(dataSource: dataSource))
			.disposed(by: disposeBag)

		collectionView.rx
			.modelSelected(DungeonConfiguration.self)
			.subscribe(onNext: { [unowned self] in self.delegate?.dungeonViewController(self, didToggle: $0.dungeon)})
			.disposed(by: disposeBag)
	}
}

// MARK: - `UICollectionViewDelegateFlowLayout` -
extension DungeonViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = floor(collectionView.bounds.width / 3.0)
		return CGSize(width: width, height: width)
	}
}

// MARK: - `DungeonCollectionViewCellDelegate` -
extension DungeonViewController: DungeonCollectionViewCellDelegate {
	func dungeonCollectionViewCell(_ cell: DungeonCollectionViewCell, didToggleChestsFor dungeon: Dungeon) {
		delegate?.dungeonViewController(self, didToggleChestsFor: dungeon)
	}

	func dungeonCollectionViewCell(_ cell: DungeonCollectionViewCell, didToggleRewardFor dungeon: Dungeon) {
		delegate?.dungeonViewController(self, didToggleRewardFor: dungeon)
	}

	func dungeonCollectionViewCell(_ cell: DungeonCollectionViewCell, didToggleMedallionFor dungeon: Dungeon) {
		delegate?.dungeonViewController(self, didToggleMedallionFor: dungeon)
	}
}

extension DungeonConfiguration: IdentifiableType {
	var identity: String {
		return "\(self)"
	}
}
