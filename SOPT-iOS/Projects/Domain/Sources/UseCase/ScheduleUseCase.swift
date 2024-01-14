//
//  ScheduleUseCase.swift
//  Domain
//
//  Created by 김영인 on 2023/12/26.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core

public protocol ScheduleUseCase {
    func getMonthlySchedule(start: String, end: String)
    var monthlySchedule: PassthroughSubject<MonthlyScheduleModel, Error> { get set }
}

public class DefaultScheduleUseCase {
    
    private let repository: ScheduleRepositoryInterface
    private var cancelBag = CancelBag()
    
    public var monthlySchedule = PassthroughSubject<MonthlyScheduleModel, Error>()
    
    public init(repository: ScheduleRepositoryInterface, cancelBag: CancelBag = CancelBag()) {
        self.repository = repository
        self.cancelBag = cancelBag
    }
}

extension DefaultScheduleUseCase: ScheduleUseCase {
    public func getMonthlySchedule(start: String, end: String) {
        repository.getMonthlySchedule(start: start, end: end)
            .withUnretained(self)
            .sink { event in
                print("completion: postAttendance \(event)")
            } receiveValue: { owner, monthlySchedule in
                owner.monthlySchedule.send(monthlySchedule)
            }
            .store(in: cancelBag)
    }
}
