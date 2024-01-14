//
//  MonthlyScheduleModel.swift
//  Domain
//
//  Created by 김영인 on 2023/12/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core

public typealias MonthlyScheduleList = [MonthlyScheduleModel]

public struct MonthlyScheduleModel: Hashable {
    public let month: Int
    public let schedule: [DailyScheduleModel]
    public var row: Int {
        schedule.count / 7
    }
    
    public init(month: Int, schedule: [DailyScheduleModel]) {
        self.month = month
        self.schedule = schedule
    }
}

public typealias DailyScheduleList = [DailyScheduleModel]

public struct DailyScheduleModel: Hashable {
    public let date: String
    public let day: DayType
    public let schedule: ScheduleList
    
    public init(date: String, day: DayType, schedule: ScheduleList) {
        self.date = date
        self.day = day
        self.schedule = schedule
    }
}

public typealias ScheduleList = [ScheduleModel]

public struct ScheduleModel: Hashable {
    public let startTime: String
    public let endTime: String
    public let title: String
    public let type: ScheduleType
    
    public init(startTime: String, endTime: String, title: String, type: ScheduleType) {
        self.startTime = startTime
        self.endTime = endTime
        self.title = title
        self.type = type
    }
}
