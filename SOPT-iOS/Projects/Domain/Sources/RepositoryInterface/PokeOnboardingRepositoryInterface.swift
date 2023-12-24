//
//  PokeOnboardingRepositoryInterface.swift
//  Domain
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

public protocol PokeOnboardingRepositoryInterface: PokeRepositoryInterface {
    func getRandomAcquaintances() -> AnyPublisher<[PokeUserModel], Error>
    func getMesseageTemplates(type: PokeMessageType) -> AnyPublisher<[PokeMessageModel], Error>
}
