//
//  ItemViewController.swift
//  Randorganizer
//
//  Created by Christopher Luu on 1/25/18.
//

import SnapKit
import RxSwift
import UIKit

protocol ItemViewControllerDelegate: class {
	func itemViewController(_ viewController: ItemViewController, didToggle item: Item)
}

final class ItemViewController: UIViewController {
	// MARK: - Constants -
	private static let toggles: [Item] = [
		.bowAndArrow,
		.boomerang,
		.hookshot,
		.bomb,
		.mushroom,
		.powder,
		.fireRod,
		.iceRod,
		.bombos,
		.ether,
		.quake,
		.magic,
		.lantern,
		.hammer,
		.flute,
		.bugNet,
		.book,
		.tunic,
		.bottle,
		.somaria,
		.byrna,
		.cape,
		.mirror,
		.shield,
		.shovel,
		.boots,
		.glove,
		.flippers,
		.moonPearl,
		.sword
	]

	// MARK: - Properties -
	private let viewModel: ItemViewModel
	private let disposeBag = DisposeBag()

	weak var delegate: ItemViewControllerDelegate?

	private let stackView = UIStackView()
	private let buttons: [UIButton]

	// MARK: - Initializations -
	init(selectedItems: Observable<Set<Item>>) {
		var buttons = [UIButton]()
		ItemViewController.toggles.enumerated().forEach { (index, toggle) in
			let button = UIButton()
			button.tag = index
			buttons.append(button)
		}

		self.buttons = buttons

		viewModel = ItemViewModel(selectedItems: selectedItems)

		super.init(nibName: nil, bundle: nil)

		title = "Items"
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("This init method shouldn't ever be used")
	}

	// MARK: - Lifecycle -
	override func viewDidLoad() {
		instantiateView()
	}

	private func updateButtons(with selectedItems: Set<Item>) {
		buttons.forEach {
			let toggle = ItemViewController.toggles[$0.tag]
			let (image, shouldFade) = toggle.image(with: selectedItems)
			$0.setImage(image, for: .normal)
			$0.alpha = (shouldFade ? 0.3 : 1.0)
		}
	}
}

// MARK: - `ViewCustomizer` -
extension ItemViewController: ViewCustomizer {
	func styleView() {
		view.backgroundColor = .black
	}

	func addSubviews() {
		addStackView()
		addButtons()
	}

	private func addStackView() {
		view.addSubview(stackView)
		stackView.axis = .vertical
		stackView.spacing = 0
		stackView.alignment = .fill
		stackView.distribution = .fillEqually

		stackView.snp.makeConstraints { (make) in
			make.top.equalTo(view.safeArea.top)
			make.bottom.equalTo(view.safeArea.bottom)
			make.leading.trailing.equalToSuperview()
		}
	}

	private func addButtons() {
		buttons.chunked(by: 6)
			.forEach {
				let rowStackView = UIStackView()
				rowStackView.axis = .horizontal
				rowStackView.alignment = .fill
				rowStackView.distribution = .fillEqually

				$0.forEach { (button) in
					button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
					button.imageView?.contentMode = .scaleAspectFit
					rowStackView.addArrangedSubview(button)
				}

				stackView.addArrangedSubview(rowStackView)
			}
	}

	@objc private func buttonTapped(sender: UIButton) {
		let toggle = ItemViewController.toggles[sender.tag]
		delegate?.itemViewController(self, didToggle: toggle)
	}
}

// MARK: - `RxBinder` -
extension ItemViewController: RxBinder {
	func setupBindings() {
		viewModel.selectedItems
			.subscribe(onNext: { [unowned self] in self.updateButtons(with: $0) })
			.disposed(by: disposeBag)
	}
}

private extension Item {
	func image(with selectedItems: Set<Item>) -> (image: UIImage, shouldFade: Bool) {
		switch self {
		case .bowAndArrow where selectedItems.contains(.bowAndSilverArrows):
			return (image: #imageLiteral(resourceName: "bow3"), shouldFade: false)
		case .bowAndArrow where selectedItems.contains(.bow):
			return (image: #imageLiteral(resourceName: "bow2"), shouldFade: false)
		case .bowAndArrow where selectedItems.contains(.silverArrows):
			return (image: #imageLiteral(resourceName: "silvers"), shouldFade: false)
		case .bowAndArrow:
			return (image: #imageLiteral(resourceName: "bow2"), shouldFade: true)
		case .boomerang where selectedItems.contains(.blueAndRedBoomerangs):
			return (image: #imageLiteral(resourceName: "boomerang3"), shouldFade: false)
		case .boomerang where selectedItems.contains(.blueBoomerang):
			return (image: #imageLiteral(resourceName: "boomerang1"), shouldFade: false)
		case .boomerang where selectedItems.contains(.redBoomerang):
			return (image: #imageLiteral(resourceName: "boomerang2"), shouldFade: false)
		case .boomerang:
			return (image: #imageLiteral(resourceName: "boomerang1"), shouldFade: true)
		case .hookshot:
			return (image: #imageLiteral(resourceName: "hookshot"), shouldFade: !selectedItems.contains(.hookshot))
		case .bomb:
			return (image: #imageLiteral(resourceName: "bomb"), shouldFade: !selectedItems.contains(.bomb))
		case .mushroom:
			return (image: #imageLiteral(resourceName: "mushroom"), shouldFade: !selectedItems.contains(.mushroom))
		case .powder:
			return (image: #imageLiteral(resourceName: "powder"), shouldFade: !selectedItems.contains(.powder))
		case .fireRod:
			return (image: #imageLiteral(resourceName: "firerod"), shouldFade: !selectedItems.contains(.fireRod))
		case .iceRod:
			return (image: #imageLiteral(resourceName: "icerod"), shouldFade: !selectedItems.contains(.iceRod))
		case .bombos:
			return (image: #imageLiteral(resourceName: "bombos"), shouldFade: !selectedItems.contains(.bombos))
		case .ether:
			return (image: #imageLiteral(resourceName: "ether"), shouldFade: !selectedItems.contains(.ether))
		case .quake:
			return (image: #imageLiteral(resourceName: "quake"), shouldFade: !selectedItems.contains(.quake))
		case .magic where selectedItems.contains(.halfMagic):
			return (image: #imageLiteral(resourceName: "magic1"), shouldFade: false)
		case .magic where selectedItems.contains(.quarterMagic):
			return (image: #imageLiteral(resourceName: "magic2"), shouldFade: false)
		case .magic:
			return (image: #imageLiteral(resourceName: "magic1"), shouldFade: true)
		case .lantern:
			return (image: #imageLiteral(resourceName: "lantern"), shouldFade: !selectedItems.contains(.lantern))
		case .hammer:
			return (image: #imageLiteral(resourceName: "hammer"), shouldFade: !selectedItems.contains(.hammer))
		case .flute:
			return (image: #imageLiteral(resourceName: "flute"), shouldFade: !selectedItems.contains(.flute))
		case .bugNet:
			return (image: #imageLiteral(resourceName: "net"), shouldFade: !selectedItems.contains(.bugNet))
		case .book:
			return (image: #imageLiteral(resourceName: "book"), shouldFade: !selectedItems.contains(.book))
		case .tunic where selectedItems.contains(.blueTunic):
			return (image: #imageLiteral(resourceName: "tunic2"), shouldFade: false)
		case .tunic where selectedItems.contains(.redTunic):
			return (image: #imageLiteral(resourceName: "tunic3"), shouldFade: false)
		case .tunic:
			return (image: #imageLiteral(resourceName: "tunic1"), shouldFade: false)
		case .bottle:
			return (image: #imageLiteral(resourceName: "bottle0"), shouldFade: !selectedItems.contains(.bottle))
		case .somaria:
			return (image: #imageLiteral(resourceName: "somaria"), shouldFade: !selectedItems.contains(.somaria))
		case .byrna:
			return (image: #imageLiteral(resourceName: "byrna"), shouldFade: !selectedItems.contains(.byrna))
		case .cape:
			return (image: #imageLiteral(resourceName: "cape"), shouldFade: !selectedItems.contains(.cape))
		case .mirror:
			return (image: #imageLiteral(resourceName: "mirror"), shouldFade: !selectedItems.contains(.mirror))
		case .shield where selectedItems.contains(.fightersShield):
			return (image: #imageLiteral(resourceName: "shield1"), shouldFade: false)
		case .shield where selectedItems.contains(.fireShield):
			return (image: #imageLiteral(resourceName: "shield2"), shouldFade: false)
		case .shield where selectedItems.contains(.mirrorShield):
			return (image: #imageLiteral(resourceName: "shield3"), shouldFade: false)
		case .shield:
			return (image: #imageLiteral(resourceName: "shield1"), shouldFade: true)
		case .shovel:
			return (image: #imageLiteral(resourceName: "shovel"), shouldFade: !selectedItems.contains(.shovel))
		case .boots:
			return (image: #imageLiteral(resourceName: "boots"), shouldFade: !selectedItems.contains(.boots))
		case .glove where selectedItems.contains(.powerGlove):
			return (image: #imageLiteral(resourceName: "glove1"), shouldFade: false)
		case .glove where selectedItems.contains(.titansMitts):
			return (image: #imageLiteral(resourceName: "glove2"), shouldFade: false)
		case .glove:
			return (image: #imageLiteral(resourceName: "glove1"), shouldFade: true)
		case .flippers:
			return (image: #imageLiteral(resourceName: "flippers"), shouldFade: !selectedItems.contains(.flippers))
		case .moonPearl:
			return (image: #imageLiteral(resourceName: "moonpearl"), shouldFade: !selectedItems.contains(.moonPearl))
		case .sword where selectedItems.contains(.fightersSword):
			return (image: #imageLiteral(resourceName: "sword1"), shouldFade: false)
		case .sword where selectedItems.contains(.masterSword):
			return (image: #imageLiteral(resourceName: "sword2"), shouldFade: false)
		case .sword where selectedItems.contains(.temperedSword):
			return (image: #imageLiteral(resourceName: "sword3"), shouldFade: false)
		case .sword where selectedItems.contains(.goldSword):
			return (image: #imageLiteral(resourceName: "sword4"), shouldFade: false)
		case .sword:
			return (image: #imageLiteral(resourceName: "sword1"), shouldFade: true)
		default:
			fatalError("Should never get to this point")
		}
	}
}
