//
//  HomeViewController.swift
//  MusicPlayer
//
//  Created by Rahul Singh on 16/05/24.
//

import UIKit

final class HomeViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let value = UICollectionView(frame: .zero, collectionViewLayout: getLayout())
        value.translatesAutoresizingMaskIntoConstraints = false
        return value
    }()
    
    private var viewModel = ItemsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        viewModel.delegate = self
        setupUI()
        addAutolayoutConstraints()
        setupCollectionView()
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
    }
    
    private func addAutolayoutConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func getLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { section, environment -> NSCollectionLayoutSection? in
            // Create item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // Create group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // Create section
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseIdentifier, for: indexPath) as! ItemCell
        let item = viewModel.item(at: indexPath.item)
        cell.configure(with: item)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.itemSelected(at: indexPath)
    }
}

extension HomeViewController: ItemsViewModelDelegate {
    func updateUI() {
        collectionView.reloadData()
    }
}
