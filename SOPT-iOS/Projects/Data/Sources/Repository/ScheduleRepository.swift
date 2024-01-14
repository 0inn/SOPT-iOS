//
//  ScheduleRepository.swift
//  Data
//
//  Created by 김영인 on 2023/12/26.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Networks

public class ScheduleRepository {
    
    private let scheduleService: ScheduleService
    private let cancelBag = CancelBag()
    
    public init(scheduleService: ScheduleService) {
        self.scheduleService = scheduleService
    }
}

extension ScheduleRepository: ScheduleRepositoryInterface {
    public func getMonthlySchedule(start: String, end: String) -> AnyPublisher<MonthlyScheduleModel, Error> {
        return self.scheduleService
            .fetchMonthlySchedule(start: start, end: end)
            .compactMap { $0.data?.toDomain() }
            .eraseToAnyPublisher()
    }
}
