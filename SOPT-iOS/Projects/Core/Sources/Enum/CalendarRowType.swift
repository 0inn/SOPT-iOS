//
//  CalendarRowType.swift
//  Core
//
//  Created by 김영인 on 2024/01/04.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public enum CalendarRowType: Int, CaseIterable {
    case four = 4
    case five
    case six
    
    static func type(_ row: Int) -> Self? {
        allCases.first { $0.rawValue == row }
    }
}
