//
//  RankAPI.swift
//  Network
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Alamofire
import Moya

public enum RankAPI {
    case rank
    case rankDetail(userName: String)
    case editSentence(sentence: String)
}

extension RankAPI: BaseAPI {
    
    public static var apiType: APIType = .rank
    
    // MARK: - Header
    public var headers: [String: String]? {
        switch self {
        case .rank, .editSentence, .rankDetail:
            return HeaderType.jsonWithToken.value
        default: return HeaderType.json.value
        }
    }
    
    // MARK: - Path
    public var path: String {
        switch self {
        case .rank:
            return ""
        case .rankDetail:
            return "/detail"
        case .editSentence:
            return "/profileMessage"
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .editSentence:
            return .post
        default: return .get
        }
    }
    
    // MARK: - Parameters
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        switch self {
        case .rankDetail(let userName):
            params["nickname"] = userName
        case .editSentence(let sentence):
            params["profileMessage"] = sentence
        default: break
        }
        return params
    }
    
    private var parameterEncoding: ParameterEncoding {
        switch self {
        case .rankDetail:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    public var task: Task {
        switch self {
        case .rankDetail:
            return .requestParameters(parameters: bodyParameters ?? [:], encoding: parameterEncoding)
        case .editSentence:
            return .requestParameters(parameters: self.bodyParameters ?? [:], encoding: parameterEncoding)
        default:
            return .requestPlain
        }
    }
}
