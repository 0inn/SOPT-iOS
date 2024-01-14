//
//  ScheduleUseCase.swift
//  Domain
//
//  Created by 김영인 on 2023/12/26.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine
import Foundation

import Core

public protocol ScheduleUseCase {
    var monthlySchedule: PassthroughSubject<MonthlyScheduleModel, Never> { get set }

    func getMonthlySchedule()
}

public class DefaultScheduleUseCase {
    
    private let repository: ScheduleRepositoryInterface
    private var cancelBag = CancelBag()
    
    public var monthlySchedule = PassthroughSubject<MonthlyScheduleModel, Never>()
    
    public init(repository: ScheduleRepositoryInterface, cancelBag: CancelBag = CancelBag()) {
        self.repository = repository
        self.cancelBag = cancelBag
    }
}

extension DefaultScheduleUseCase: ScheduleUseCase {
    public func getMonthlySchedule() {
        let (start, end) = getDate()
        
        repository.getMonthlySchedule(start: start, end: end)
            .withUnretained(self)
            .sink { event in
                print("completion: getMonthlySchedule \(event)")
            } receiveValue: { owner, monthlySchedule in
                owner.monthlySchedule.send(monthlySchedule)
            }
            .store(in: cancelBag)
    }
}

extension DefaultScheduleUseCase {
    private func getDate() -> (startDate: String, endDate: String) {
        let date = Date()
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_kr")
        
        let curMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))
        let startOfMonth = calendar.date(byAdding: .day, value: 1, to: curMonth!)
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: curMonth!)
        
        let startDay = calendar.component(.weekday, from: startOfMonth!) - 1
        let endDay = 7 - calendar.component(.weekday, from: endOfMonth!)

        let startDate = calendar.date(byAdding: .day, value: -startDay, to: startOfMonth!)
        let endDate = calendar.date(byAdding: .day, value: endDay, to: endOfMonth!)
        
        return (startDate: startDate!.toString(), endDate: endDate!.toString())
    }
}
