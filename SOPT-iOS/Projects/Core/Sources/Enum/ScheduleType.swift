//
//  ScheduleType.swift
//  Core
//
//  Created by 김영인 on 2023/12/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public enum ScheduleType: String, CaseIterable {
    case none
    case seminar = "SEMINAR"
    case event = "EVENT"
    case etc = "ETC"
    
    public static func getType(for type: String) -> Self {
        Self.allCases.first { $0.rawValue == type } ?? .none
    }
}
