//
//  CollectionsViewController.swift
//  users
//
//  Created by Ina Statkic on 20.1.21..
//  Copyright © 2021 Ina. All rights reserved.
//

import UIKit

final class CollectionsViewController<Item: Hashable, Cell: UICollectionViewCell>: UIViewController, UICollectionViewDelegate {
    
    var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    var items: [Item] = []
    var configure: (Item, Cell) -> () = { _, _ in }
    var didSelect: (Item) -> () = { _ in }
    var scrollUp: () -> () = {  }
    var scrollDown: () -> () = {  }
    var contentOffset: CGFloat = 0
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        setElements()
        configureDataSource()
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.clipsToBounds = false
    }
    
    // MARK: - Init
    
    init(items: [Item], configure: @escaping (Item, Cell) -> ()) {
        self.configure = configure
        super.init(nibName: nil, bundle: nil)
        self.items = items
    }
    
    init(configure: @escaping (Item, Cell) -> ()) {
        self.configure = configure
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data
    
    var dataSource: UICollectionViewDiffableDataSource<ListSection, Item>!
    
    // MARK: - Elements
    
    private func setElements() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: ListSection.createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
    }
    
    // MARK: - Scroll Delegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        contentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if contentOffset < scrollView.contentOffset.y {
            scrollUp()
        } else if contentOffset > scrollView.contentOffset.y {
            scrollDown()
        }
    }
    
    // MARK: - Collection Delegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        didSelect(item)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // MARK: - Collection Data Source
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<Cell, Item>(cellNib: UINib(nibName: Cell.reuseIdentifier, bundle: nil)) { [weak self] (cell, indexPath, item) in
            self?.configure(item, cell)
        }
        
        dataSource = UICollectionViewDiffableDataSource<ListSection, Item>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
    
    func snapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ListSection, Item>()
        snapshot.appendSections([.list])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
