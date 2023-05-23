//
//  MainLayout.swift
//  ExReactor
//
//  Created by LEE on 2023/05/22.
//

import UIKit
class MainLayout {
  static func create() -> UICollectionViewLayout {
            let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
                
                print("Section = \(sectionIndex) env = \(environment)")
                
                // Item 설정
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                // Group 설정
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                group.interItemSpacing = .fixed(10)
                
                // Section 설정
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
//                section.boundarySupplementaryItems = [self.createHeader()]
                
                return section
            }
            
            return layout
        }
}
