//
//  ScheduleBuilder.swift
//  ScheduleFeature
//
//  Created by 김영인 on 2023/12/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import Domain
@_exported import ScheduleFeatureInterface

public final class ScheduleBuilder {
    @Injected public var monthlyScheduleRepository: ScheduleRepositoryInterface
    
    public init() { }
}

extension ScheduleBuilder: ScheduleFeatureBuildable {
    public func makeScheduleVC() -> ScheduleCoordinatable {
        let useCase = DefaultScheduleUseCase(repository: monthlyScheduleRepository)
        let viewModel = ScheduleViewModel(useCase: useCase)
        let scheduleVC = ScheduleVC(viewModel: viewModel)
        return scheduleVC
    }
}
