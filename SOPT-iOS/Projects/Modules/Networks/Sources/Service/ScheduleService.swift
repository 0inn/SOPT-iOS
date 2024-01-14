//
//  ScheduleService.swift
//  Networks
//
//  Created by 김영인 on 2023/12/26.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core

public typealias DefaultScheduleService = BaseService<ScheduleAPI>

public protocol ScheduleService {
    func fetchMonthlySchedule(start: String, end: String) -> AnyPublisher<BaseEntity<MonthlyScheduleEntity>, Error>
}

extension DefaultScheduleService: ScheduleService {
    public func fetchMonthlySchedule(start: String, end: String) -> AnyPublisher<BaseEntity<MonthlyScheduleEntity>, Error> {
        opRequestObjectInCombine(ScheduleAPI.monthly(start: start, end: end))
    }
}
