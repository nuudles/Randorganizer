//
//  DungeonViewController.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/26/18.
//

import RxSwift
import SnapKit
import UIKit

protocol DungeonViewControllerDelegate: class {
	func dungeonViewController(_ viewController: DungeonViewController, didToggle dungeon: Dungeon)
}

final class DungeonViewController: UIViewController {
	// MARK: - properties -
	private let viewModel: DungeonViewModel
	private let disposeBag = DisposeBag()

	weak var delegate: DungeonViewControllerDelegate?
	private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

	// MARK: - initialization -
	init(dungeons: Observable<[DungeonConfiguration]>) {
		self.viewModel = DungeonViewModel(dungeons: dungeons)

		super.init(nibName: nil, bundle: nil)

		title = "Dungeons"
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - lifecycle -
	override func viewDidLoad() {
		super.viewDidLoad()

		instantiateView()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		collectionView.collectionViewLayout.invalidateLayout()
	}
}

// MARK: - `ViewCustomizer` -
extension DungeonViewController: ViewCustomizer {
	// MARK: - constants -

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
			.bind(to: collectionView.rx.items) { (collectionView, row, item) in
				let cell: DungeonCollectionViewCell =
					collectionView.dequeueReusableCell(forIndexPath: IndexPath(item: row, section: 0))
				cell.update(with: item)
				return cell
			}
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
