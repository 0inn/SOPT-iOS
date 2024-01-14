//
//  DayType.swift
//  Core
//
//  Created by 김영인 on 2023/12/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public enum DayType: String, CaseIterable {
    case none
    case mon = "월"
    case tue = "화"
    case wed = "수"
    case thur = "목"
    case fri = "금"
    case sat = "토"
    case sun = "일"
    
    public var description: String {
        return self.rawValue
    }
    
    public static var allCases: [DayType] = [
        .sun, .mon, .tue, .wed, .thur, .fri, .sat
    ]
    
    public static func getDay(for day: String) -> Self {
        Self.allCases.first { $0.rawValue == day } ?? .none
    }
}
