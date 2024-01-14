//
//  MonthlyScheduleTransform.swift
//  Data
//
//  Created by 김영인 on 2023/12/26.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Core
import Domain
import Networks

extension MonthlyScheduleEntity {
    public func toDomain() -> MonthlyScheduleModel {
        let schedule = self.map { dailySchedule in
            let schedule =  dailySchedule.schedules.map { schedule in
                ScheduleModel.init(
                    startTime: schedule.start,
                    endTime: schedule.end,
                    title: schedule.name,
                    type: ScheduleType.getType(for: schedule.attribute)
                )
            }
            
            return DailyScheduleModel.init(
                date: dailySchedule.date,
                day: DayType.getDay(for: dailySchedule.dayOfWeek),
                schedule: schedule
            )
        }
        
        // TODO: - 서버 맞게 바꾸기
        return .init(month: 1, schedule: schedule)
    }
}
