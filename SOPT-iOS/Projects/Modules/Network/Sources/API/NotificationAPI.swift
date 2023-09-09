//
//  NotificationAPI.swift
//  Network
//
//  Created by sejin on 2023/09/09.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Alamofire
import Moya

public enum NotificationAPI {
    case getNotificationList(page: Int)
}

extension NotificationAPI: BaseAPI {
    public static var apiType: APIType = .notification
    
    public var path: String {
        switch self {
        default:
            return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getNotificationList(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        }
    }
}
