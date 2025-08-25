//
//  TamagochiViewController.swift
//  Tamagochiz
//
//  Created by Lee on 8/23/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TamagochiViewController: UIViewController {

    var disposeBag = DisposeBag()

//    var tamagochiModel: TamagochiModel = .init(tamaCategory: .tama1, name: "", image: ""){
//        didSet {
//            if let decodedData = try? JSONEncoder().encode(tamagochiModel) {
//                UserDefaults.standard.set(decodedData, forKey: "tamagochiModel")
//            }
//        }
//    }

    let viewModel = TamagochiViewModel()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(TamagochiCell.self, forCellWithReuseIdentifier: TamagochiCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
        bind()
        setupNavigation()
    }

    private func makeCollectionViewLayout() -> UICollectionViewFlowLayout {

        typealias Tama = TamagochiConfigureSet

        let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame
        let lineSpacing = Tama.lineSpacing.configure
        let itemSpacing = Tama.itemSpacing.configure
        let topInset = Tama.topInset.configure
        let leftInset = Tama.leftInset.configure
        let rightInset = Tama.rightInset.configure
        let bottomInset = Tama.bottomInset.configure

        let itemWidth = (safeAreaFrame.width - (leftInset + rightInset) - (lineSpacing * 2)) / 3
        let itemHeight = itemWidth + 16 + 4

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: topInset,
                                           left: leftInset,
                                           bottom: bottomInset,
                                           right: rightInset)

        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)

        return layout
    }

    override func viewDidLayoutSubviews() {
        collectionView.collectionViewLayout = makeCollectionViewLayout()
    }

    private func configureHierarchy() {
        [collectionView].forEach { view.addSubview($0) }
    }

    private func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }

    private func configureView() {
        collectionView.backgroundColor = .clear
        view.backgroundColor = .white
    }

    private func setupNavigation() {
        navigationItem.title = "다마고치 선택하기"
        navigationItem.backButtonTitle = ""
    }

    private func bind() {
        let viewDidLoadtrigger = PublishRelay<Void>()

        let input = TamagochiViewModel.Input(viewDidLoadTrigger: viewDidLoadtrigger)

        let output = viewModel.transform(input: input)

        output.tamagochiRawData
            .bind(to: collectionView.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TamagochiCell.identifier, for: indexPath) as? TamagochiCell else { return .init() }
                cell.configureCell(with: element)
                return cell
            }
            .disposed(by: disposeBag)

        collectionView.rx.modelSelected(TamagochiModel.self)
            .bind(with: self) { owner, model in
//                owner.tamagochiModel = model
                UserDefaults.standard.set(model.name, forKey: UserDefaultsKey.tamagochiName.rawValue)
                UserDefaults.standard.set(model.tamaCategory.rawValue, forKey: UserDefaultsKey.tamagochi.rawValue)
                let vc = TamagochiPopupViewController(tamaModel: model, okButtonTapped: owner.pushMainView)
                vc.modalPresentationStyle = .overCurrentContext
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }

    private func pushMainView() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainViewController")
        navigationController?.setViewControllers([vc], animated: true)
    }
}



extension TamagochiViewController {
    enum TamagochiConfigureSet {
        case lineSpacing
        case itemSpacing
        case topInset
        case bottomInset
        case leftInset
        case rightInset

        var configure: CGFloat {
            return 20
        }
    }
}
