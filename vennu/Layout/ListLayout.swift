//
//  ListLayout.swift
//  vennu
//
//  Created by Ina Statkic on 13.1.21..
//  Copyright © 2021 Ina. All rights reserved.
//

import UIKit

enum ListSection: Int {
    case list
    func columns(_ width: CGFloat) -> Int {
        switch self {
        case .list:
            if width > 900 { return 3
            } else if width > 500 { return 2
            } else { return 1 }
        }
    }
    
    static func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let layoutKind = ListSection(rawValue: sectionIndex) else { return nil }
            let columns = layoutKind.columns(environment.container.effectiveContentSize.width)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(112))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(112))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            let spacing = CGFloat(10)
            group.interItemSpacing = .fixed(spacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            return section
        }
        return layout
    }
}

