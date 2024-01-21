//
//  AmplitudeInstance.swift
//  Core
//
//  Created by sejin on 2023/09/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import AmplitudeSwift

public struct AmplitudeInstance {
    static public let shared = Amplitude(configuration: Configuration(apiKey: Config.Amplitude.apiKey))
    
    private init() {}
}

public extension Amplitude {
    func track(eventType: AmplitudeEventType, eventProperties: [String: Any]? = nil) {
        let eventType: String = eventType.rawValue

        AmplitudeInstance.shared.track(eventType: eventType, eventProperties: eventProperties, options: nil)
    }
    
    func trackWithUserType(event: AmplitudeEventType, otherProperties: [String: Any]? = nil) {
        let eventType: String = event.rawValue
        let userType = UserDefaultKeyList.Auth.getUserType()
        let eventProperties: [String: Any] = ["view_type": userType.rawValue.lowercased()]
        
        AmplitudeInstance.shared.track(eventType: eventType, eventProperties: eventProperties, options: nil)
    }
    
    func addPushNotificationAuthorizationIdentity(isAuthorized: Bool) {
        let identify = Identify()
        let key: AmplitudeUserPropertyKey = .statusOfPushNotification
        identify.set(property: key.rawValue, value: isAuthorized)
        
        AmplitudeInstance.shared.identify(identify: identify)
    }
}
