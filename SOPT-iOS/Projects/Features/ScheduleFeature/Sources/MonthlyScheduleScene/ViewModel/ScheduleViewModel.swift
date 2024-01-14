//
//  ScheduleViewModel.swift
//  ScheduleFeature
//
//  Created by 김영인 on 2023/12/26.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain

public class ScheduleViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let useCase: ScheduleUseCase
    private var cancelBag = CancelBag()
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let monthlyScheduleList = PassthroughSubject<[MonthlyScheduleModel], Never>()
    }
    
    // MARK: - initialization
    
    public init(useCase: ScheduleUseCase) {
        self.useCase = useCase
    }
}

extension ScheduleViewModel {
    public func transform(from input: Input, cancelBag: Core.CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                owner.useCase.getMonthlySchedule()
            }
            .store(in: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.monthlySchedule
            .map { [$0] }
            .subscribe(output.monthlyScheduleList)
            .store(in: cancelBag)
    }
}
