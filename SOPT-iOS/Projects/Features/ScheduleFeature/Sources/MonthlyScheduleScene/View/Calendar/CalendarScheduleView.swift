//
//  CalendarScheduleView.swift
//  ScheduleFeature
//
//  Created by 김영인 on 2023/12/30.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

/*
 캘린더의 각 날짜에 표시되는 일정 중 하나를 보여주는 뷰입니다.
 
   13
 [솝커톤] <-
 [세미나]
 */

final class CalendarScheduleView: UIView {
    
    // MARK: - Properties
    
    private var type: ScheduleType = .none
    
    var isSelected: Bool = false {
        didSet {
            update()
        }
    }
    
    // MARK: - UI Components
    
    private let scheduleLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.medium.font(size: 8)
    }
    
    // MARK: - Initialization
    
    init(title: String, type: ScheduleType) {
        self.type = type
        super.init(frame: .zero)
        
        setUI(title: title)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension CalendarScheduleView {
    private func setUI(title: String) {
        scheduleLabel.text = title
        scheduleLabel.textColor = type.color
        backgroundColor = type.backgroundColor
        layer.cornerRadius = 2
    }
    
    private func setLayout() {
        addSubview(scheduleLabel)
        
        self.snp.makeConstraints {
            $0.height.equalTo(10)
        }
        
        scheduleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(3)
            $0.centerY.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension CalendarScheduleView {
    private func update() {
        scheduleLabel.textColor = isSelected ? type.selectedColor : type.color
        backgroundColor = isSelected ? type.selectedBackgroundColor : type.backgroundColor
    }
}
