//
//  DayType+.swift
//  ScheduleFeature
//
//  Created by 김영인 on 2024/01/14.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

extension DayType {
    
    var color: UIColor {
        switch self {
        case .sat:
            DSKitAsset.Colors.blue300.color
        case .sun:
            DSKitAsset.Colors.red400.color
        default:
            DSKitAsset.Colors.gray10.color
        }
    }
    
    var selectedColor: UIColor {
        switch self {
        case .sat, .sun:
            self.color
        default:
            DSKitAsset.Colors.semanticBackground.color
        }
    }
}
