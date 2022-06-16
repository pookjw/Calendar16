//
//  CollectionViewModel.swift
//  MyApp
//
//  Created by Jinwoo Kim on 6/7/22.
//

import UIKit

protocol CollectionViewModel {
    func request() async
}

actor CollectionViewModelImpl: CollectionViewModel {
    let dataSource: UICollectionViewDiffableDataSource<Int, Int>

    init(dataSource: UICollectionViewDiffableDataSource<Int, Int>) {
        self.dataSource = dataSource
    }
    
    func request() {
        var snapshot: NSDiffableDataSourceSnapshot<Int, Int> = .init()
        
        snapshot.deleteAllItems()
        snapshot.appendSections([0, 1, 2])
        snapshot.appendItems([0, 1, 2, 3], toSection: 0)
        snapshot.appendItems([4, 5, 6], toSection: 1)
        snapshot.appendItems([7, 8], toSection: 2)
        
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
}
