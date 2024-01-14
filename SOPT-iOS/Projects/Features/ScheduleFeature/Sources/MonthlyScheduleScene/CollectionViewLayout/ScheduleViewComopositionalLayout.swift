//
//  ScheduleViewComopositionalLayout.swift
//  ScheduleFeatureInterface
//
//  Created by 김영인 on 2024/01/04.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

// MARK: - ScheduleCVC Layout

extension ScheduleCVC {
    func createCalendarViewLayout(row: Int) -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            self.createCalendarSection(row: row)
        }
    }
    
    func createMonthlyScheduleViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            self.createMonthlyScheduleSection()
        }
    }
    
    private func createCalendarSection(row: Int) -> NSCollectionLayoutSection {
        let height: NSCollectionLayoutDimension = .absolute(CGFloat(360/row))
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width/7), heightDimension: height)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: height)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 7)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func createMonthlyScheduleSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 14, leading: 16, bottom: 14, trailing: 16)
        section.interGroupSpacing = 16
        
        return section
    }
    
    private func createEmptySection() -> NSCollectionLayoutSection {
        NSCollectionLayoutSection(group: NSCollectionLayoutGroup(layoutSize: .init(widthDimension: .absolute(0), heightDimension: .absolute(0))))
    }
}

// MARK: - ScheduleVC Layout

extension ScheduleVC {
    func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout(section: createScheduleSection())
    }
    
    private func createScheduleSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
}
