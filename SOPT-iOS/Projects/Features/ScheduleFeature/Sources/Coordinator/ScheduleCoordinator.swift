//
//  ScheduleCoordinator.swift
//  ScheduleFeatureDemo
//
//  Created by 김영인 on 2023/12/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import ScheduleFeatureInterface

public final class ScheduleCoordinator: DefaultCoordinator {
    
    public var finishFlow: (() -> Void)?
    
    private let factory: ScheduleFeatureBuildable
    private let router: Router
    
    public init(router: Router, factory: ScheduleFeatureBuildable) {
        self.router = router
        self.factory = factory
    }
    
    override public func start() {
        showSchedule()
    }
    
    private func showSchedule() {
        var schedule = factory.makeScheduleVC()
        
        schedule.onNaviBackTap = { [weak self] in
            self?.router.popModule()
            self?.finishFlow?()
        }
        
        router.push(schedule)
    }
}
