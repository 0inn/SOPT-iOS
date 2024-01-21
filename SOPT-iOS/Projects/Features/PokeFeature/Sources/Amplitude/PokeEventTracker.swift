//
//  PokeEventTracker.swift
//  PokeFeature
//
//  Created by sejin on 1/21/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Core

struct PokeEventTracker {
    func trackViewEvent(with viewEvent: AmplitudeEventType) {
        AmplitudeInstance.shared.trackWithUserType(event: viewEvent)
    }
    
    func trackClickPokeEvent(clickView: PokeAmplitudeEventPropertyValue) {
        let properties = AmplitudeEventPropertyBuilder<PokeAmplitudeEventPropertyValue>()
            .addViewType()
            .add(key: .clickViewType, value: clickView)
            .build()
        
        AmplitudeInstance.shared.track(eventType: .clickPokeIcon, eventProperties: properties)
    }
    
    func trackClickPokeEvent(clickView: PokeAmplitudeEventPropertyValue, playgroundId: Int) {
        let properties = AmplitudeEventPropertyBuilder<PokeAmplitudeEventPropertyValue>()
            .addViewType()
            .add(key: .clickViewType, value: clickView)
            .add(key: .viewProfile, value: playgroundId)
            .build()
        
        AmplitudeInstance.shared.track(eventType: .clickPokeIcon, eventProperties: properties)
    }
    
    func trackClickMemberProfileEvent(clickView: PokeAmplitudeEventPropertyValue) {
        let properties = AmplitudeEventPropertyBuilder<PokeAmplitudeEventPropertyValue>()
            .addViewType()
            .add(key: .clickViewType, value: clickView)
            .build()
        
        AmplitudeInstance.shared.track(eventType: .clickMemberProfile, eventProperties: properties)
    }
    
    func trackClickMemberProfileEvent(clickView: PokeAmplitudeEventPropertyValue, playgroundId: Int) {
        let properties = AmplitudeEventPropertyBuilder<PokeAmplitudeEventPropertyValue>()
            .addViewType()
            .add(key: .clickViewType, value: clickView)
            .add(key: .viewProfile, value: playgroundId)
            .build()
        
        AmplitudeInstance.shared.track(eventType: .clickMemberProfile, eventProperties: properties)
    }
}
