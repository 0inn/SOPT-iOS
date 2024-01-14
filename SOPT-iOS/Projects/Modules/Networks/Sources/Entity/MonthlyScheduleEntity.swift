//
//  MonthlyScheduleEntity.swift
//  Networks
//
//  Created by 김영인 on 2023/12/26.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public typealias MonthlyScheduleEntity = [DailyScheduleEntity]

public struct DailyScheduleEntity: Decodable {
    public let date: String
    public let dayOfWeek: String
    public let schedules: [ScheduleEntity]
}

public struct ScheduleEntity: Decodable {
    public let start: String
    public let end: String
    public let name: String
    public let attribute: String
}
