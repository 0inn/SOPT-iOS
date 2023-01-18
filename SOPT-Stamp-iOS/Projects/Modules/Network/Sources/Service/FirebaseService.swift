//
//  FirebaseService.swift
//  Network
//
//  Created by sejin on 2023/01/18.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import Combine

import Alamofire
import Moya

public typealias DefaultFirebaseService = BaseService<FirebaseAPI>

public protocol FirebaseService {

}

extension DefaultFirebaseService: FirebaseService {
    
}
