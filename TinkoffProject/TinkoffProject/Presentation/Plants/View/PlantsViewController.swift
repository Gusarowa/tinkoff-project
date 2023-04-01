//
//  PlantsViewController.swift
//  TinkoffProject
//
//  Created by Лена Гусарова on 01.04.2023.
//

import UIKit

class PlantsViewController: UIViewController {
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return layout
    }()
    
    var presenter: PlantsViewControllerOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        presenter?.viewDidLoad()
    }
    
    private func setup() {
        let collectionView: UICollectionView = .init(
            frame: .zero,
            collectionViewLayout: flowLayout
        )
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension PlantsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let presenter else { return 0 }
        return presenter.itemCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let presenter else { return UICollectionViewCell() }

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath)
        let plant = presenter.getItem(for: indexPath.item)
        var config = UIListContentConfiguration.cell()
        config.text = plant.name
        config.image = UIImage(named: "plant")
        config.imageProperties.maximumSize = CGSize(width: 50, height: 50)
        cell.contentConfiguration = config
        return cell
        
    }
    


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = flowLayout.minimumInteritemSpacing
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension * 0.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.viewDidSelectRow(index: indexPath.item)
    }
}

extension PlantsViewController: PlantsViewControllerInput {
    func reloadData() {
        flowLayout.collectionView?.reloadData()
    }
}
