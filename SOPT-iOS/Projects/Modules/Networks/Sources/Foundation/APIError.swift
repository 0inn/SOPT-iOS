//
//  APIError.swift
//  Network
//
//  Created by Junho Lee on 2023/04/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public enum APIError: Error, Equatable {
    case network(statusCode: Int)
    case unknown
    case tokenReissuanceFailed
    
    init(error: Error, statusCode: Int? = 0) {
        guard let statusCode else { self = .unknown ; return }
        
        self = .network(statusCode: statusCode)
    }
}
