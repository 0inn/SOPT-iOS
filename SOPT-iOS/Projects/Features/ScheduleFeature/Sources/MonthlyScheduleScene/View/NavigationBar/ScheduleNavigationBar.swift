//
//  ScheduleNavigationBar.swift
//  ScheduleFeature
//
//  Created by 김영인 on 2024/01/13.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class ScheduleNavigationBar: UIView {
    
    public var backButtonTapped: Driver<Void> {
        backButton.publisher(for: .touchUpInside)
            .mapVoid()
            .asDriver()
    }
    
    // MARK: - UI Components
    
    private let backButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(asset: DSKitAsset.Assets.arrowLeft), for: .normal)
    }
    
    private let dateLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.bold.font(size: 18)
        $0.textColor = DSKitAsset.Colors.gray10.color
        $0.text = "2024.01"
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension ScheduleNavigationBar {
    private func setUI() {
        backgroundColor = DSKitAsset.Colors.semanticBackground.color
    }
    
    private func setLayout() {
        addSubviews(backButton, dateLabel)
        
        self.snp.makeConstraints {
            $0.height.equalTo(34)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension ScheduleNavigationBar {
    
}
