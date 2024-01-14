//
//  ScheduleViewControllable.swift
//  ScheduleFeatureDemo
//
//  Created by 김영인 on 2023/12/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency

public protocol ScheduleViewControllable: ViewControllable & ScheduleCoordinatable { }

public protocol ScheduleCoordinatable: ViewControllable {
    var onNaviBackTap: (() -> Void)? { get set }
}
