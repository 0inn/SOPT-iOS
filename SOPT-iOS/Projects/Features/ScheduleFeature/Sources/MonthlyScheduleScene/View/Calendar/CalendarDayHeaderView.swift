//
//  CalendarDayHeaderView.swift
//  ScheduleFeature
//
//  Created by 김영인 on 2023/12/30.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

/*
 캘린더 상단 요일을 보여주는 뷰입니다.
 
 [일 월 화 수 목 금 토]
 */

final class CalendarDayHeaderView: UIView {
    
    // MARK: - UI Components
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension CalendarDayHeaderView {
    private func setUI() {
        backgroundColor = DSKitAsset.Colors.semanticBackground.color
        
        DayType.allCases.forEach {
            let dayLabel: DayLabel = .init(type: $0)
            stackView.addArrangedSubview(dayLabel)
        }
    }
    
    private func setLayout() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
