//
//  CollectionViewController.swift
//  MyApp
//
//  Created by Jinwoo Kim on 6/7/22.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    private var viewModel: (any CollectionViewModel)!
    private var requestTask: Task<Void, Never>?
    
    convenience init() {
        let configuration: UICollectionLayoutListConfiguration = .init(appearance: .insetGrouped)
        let layout: UICollectionViewCompositionalLayout = .list(using: configuration)
        self.init(collectionViewLayout: layout)
        
        modalPresentationStyle = .custom
        transitioningDelegate = self
        
        let cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, Int> = .init { cell, indexPath, itemIdentifier in
            var contentConfiguration: UIListContentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = "\(indexPath)"
            
            var backgroundConfiguration: UIBackgroundConfiguration = cell.defaultBackgroundConfiguration()
            backgroundConfiguration.backgroundColor = .systemCyan
            
            cell.contentConfiguration = contentConfiguration
            cell.backgroundConfiguration = backgroundConfiguration
            
            let test1: UIAction = .init(title: "Test", subtitle: "keepsMenuPresented", image: .init(systemName: "pencil.tip"), identifier: nil, discoverabilityTitle: nil, attributes: [.keepsMenuPresented], state: .on) { _ in
                
            }
            
            let test2: UIAction = .init(title: "Test", subtitle: "disabled + mixed", image: .init(systemName: "pencil.tip"), identifier: nil, discoverabilityTitle: nil, attributes: [.disabled], state: .mixed) { _ in
                
            }
            
            let menu: UIMenu = .init(title: "Test", subtitle: "Test", image: .init(systemName: "pencil.tip"), identifier: nil, options: [.displayInline], preferredElementSize: .medium, children: [test1, test2])
            
            cell.accessories = [
                .popUpMenu(menu, displayed: .always, options: .init(isHidden: false, reservedLayoutWidth: .standard, tintColor: .brown), selectedElementDidChangeHandler: { menu in
                    
                }),
                
                    .detail(displayed: .always, options: .init(isHidden: false, reservedLayoutWidth: .standard, tintColor: .magenta), actionHandler: {
                        
                    })
            ]
        }
        
        let dataSource: UICollectionViewDiffableDataSource<Int, Int> = .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell: UICollectionViewCell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
        
        let viewModel: CollectionViewModel = CollectionViewModelImpl(dataSource: dataSource)
        
        let requestTask: Task = .init { [viewModel] in
            await viewModel.request()
        }
        self.viewModel = viewModel
        self.requestTask = requestTask
    }
    
    deinit {
        requestTask?.cancel()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension CollectionViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let pc: UISheetPresentationController = .init(presentedViewController: presented, presenting: presenting)
        pc.detents = [.custom(identifier: .init("1"), resolver: { context in
            print(context.maximumDetentValue)
            return 300.0
        })]
        
        return pc
    }
}
