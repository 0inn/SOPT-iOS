//
//  ScheduleFeatureBuildable.swift
//  ScheduleFeatureDemo
//
//  Created by 김영인 on 2023/12/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency

public protocol ScheduleFeatureBuildable {
    func makeScheduleVC() -> ScheduleCoordinatable
}
