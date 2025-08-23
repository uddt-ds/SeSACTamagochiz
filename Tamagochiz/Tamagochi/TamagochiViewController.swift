//
//  TamagochiViewController.swift
//  Tamagochiz
//
//  Created by Lee on 8/23/25.
//

import UIKit
import SnapKit

final class TamagochiViewController: UIViewController {

    let viewModel = TamagochiViewModel()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(TamagochiCell.self, forCellWithReuseIdentifier: TamagochiCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
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
        let itemHeight = (safeAreaFrame.height - (topInset + bottomInset) - (itemSpacing * 5)) / 5.2

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: Tama.topInset.configure,
                                           left: Tama.leftInset.configure,
                                           bottom: Tama.bottomInset.configure,
                                           right: Tama.rightInset.configure)


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
}

extension TamagochiViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0...2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TamagochiCell.identifier, for: indexPath) as? TamagochiCell else { return .init() }
            cell.configureCell(with: viewModel.tamagochiData[indexPath.row])
            return cell
        default:
            let tamagochiData = TamagochiModel(name: "준비중이에요", image: "noImage")
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TamagochiCell.identifier, for: indexPath) as? TamagochiCell else { return .init() }
            cell.configureCell(with: tamagochiData)
            return cell
        }
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
