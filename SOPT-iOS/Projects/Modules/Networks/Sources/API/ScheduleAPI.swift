//
//  ScheduleAPI.swift
//  Networks
//
//  Created by 김영인 on 2023/12/26.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Alamofire
import Moya

public enum ScheduleAPI {
    case monthly(start: String, end: String)
}

extension ScheduleAPI: BaseAPI {
    
    public static var apiType: APIType = .schedule
    
    public var headers: [String : String]? {
        return HeaderType.jsonWithToken.value
    }
    
    public var path: String {
        return ""
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    private var parameters: Parameters? {
        var params: Parameters = [:]
        
        switch self {
        case let .monthly(start: start, end: end):
            params["start"] = start
            params["end"] = end
        }
        
        return params
    }
    
    private var parameterEncoding: ParameterEncoding {
        switch self {
        case .monthly:
            return URLEncoding.queryString
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .monthly:
            return .requestParameters(
                parameters: parameters ?? [:],
                encoding: parameterEncoding
            )
        }
    }
}
