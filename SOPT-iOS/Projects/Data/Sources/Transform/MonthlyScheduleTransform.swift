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
        let year = Date().toYear()
        let month = Date().toMonth()
        
        let schedule = self.dates.map { dailySchedule in
            let schedule =  dailySchedule.schedules.map { schedule in
                ScheduleModel.init(
                    startTime: schedule.startDate,
                    endTime: schedule.endDate,
                    title: schedule.title,
                    type: ScheduleType.getType(for: schedule.attribute)
                )
            }
            
            return DailyScheduleModel.init(
                date: dailySchedule.date,
                day: DayType.getDay(for: dailySchedule.dayOfWeek),
                isCurMonth: dailySchedule.date.toDate(with: "yyyy-MM-dd").toMonth() == month,
                schedule: schedule
            )
        }
        
        return .init(
            year: year,
            month: month,
            schedule: schedule
        )
    }
}
