//
//  DayLabel.swift
//  ScheduleFeature
//
//  Created by 김영인 on 2024/01/13.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

/*
 캘린더 상단 요일을 보여주는 라벨입니다.
 
 [월]
 */

final class DayLabel: UILabel {
    
    init(type: DayType) {
        super.init(frame: .zero)
        
        text = type.description
        textColor = type.color
        font = DSKitFontFamily.Suit.medium.font(size: 10)
        textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
