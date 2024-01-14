//
//  ScheduleRepositoryInterface.swift
//  Domain
//
//  Created by 김영인 on 2023/12/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

public protocol ScheduleRepositoryInterface {
    func getMonthlySchedule(start: String, end: String) -> AnyPublisher<MonthlyScheduleModel, Error>
}
