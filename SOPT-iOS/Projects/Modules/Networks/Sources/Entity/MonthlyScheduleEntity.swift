//
//  MonthlyScheduleEntity.swift
//  Networks
//
//  Created by 김영인 on 2023/12/26.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct MonthlyScheduleEntity: Decodable {
    public let dates: [DailyScheduleEntity]
}

public struct DailyScheduleEntity: Decodable {
    public let date: String
    public let dayOfWeek: String
    public let schedules: [ScheduleEntity]
}

public struct ScheduleEntity: Decodable {
    public let scheduleId: Int
    public let startDate: String
    public let endDate: String
    public let title: String
    public let attribute: String
}
