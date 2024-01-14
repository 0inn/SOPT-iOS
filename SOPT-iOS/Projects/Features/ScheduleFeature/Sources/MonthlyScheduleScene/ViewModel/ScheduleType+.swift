//
//  ScheduleType.swift
//  ScheduleFeature
//
//  Created by 김영인 on 2024/01/14.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

extension ScheduleType {
    
    var color: UIColor {
        switch self {
        case .none:
            DSKitAsset.Colors.semanticBackground.color
        case .seminar:
            DSKitAsset.Colors.orange100.color
        case .event:
            DSKitAsset.Colors.blue100.color
        case .etc:
            DSKitAsset.Colors.yellow100.color
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .none:
            DSKitAsset.Colors.semanticBackground.color
        case .seminar:
            DSKitAsset.Colors.orangeAlpha400.color
        case .event:
            DSKitAsset.Colors.blueAlpha400.color
        case .etc:
            DSKitAsset.Colors.yellow800.color
        }
    }
    
    var selectedColor: UIColor {
        switch self {
        case .none:
            DSKitAsset.Colors.semanticBackground.color
        case .seminar:
            DSKitAsset.Colors.orange400.color
        case .event:
            DSKitAsset.Colors.blue400.color
        case .etc:
            DSKitAsset.Colors.yellow600.color
        }
    }
    
    var selectedBackgroundColor: UIColor {
        switch self {
        case .none:
            DSKitAsset.Colors.semanticBackground.color
        case .seminar:
            DSKitAsset.Colors.orangeAlpha300.color
        case .event:
            DSKitAsset.Colors.blueAlpha300.color
        case .etc:
            DSKitAsset.Colors.yellow100.color
        }
    }
}
