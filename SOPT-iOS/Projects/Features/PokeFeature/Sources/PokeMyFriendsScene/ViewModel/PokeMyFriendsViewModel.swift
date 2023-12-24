//
//  PokeMyFriendsViewModel.swift
//  PokeFeature
//
//  Created by sejin on 12/14/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain

import PokeFeatureInterface

public class PokeMyFriendsViewModel:
    PokeMyFriendsViewModelType {
    
    public var showFriendsListButtonTap: ((PokeRelation) -> Void)?
    public var onPokeButtonTapped: ((PokeUserModel) -> Driver<(PokeUserModel, PokeMessageModel)>)?
    public var onProfileImageTapped: ((Int) -> Void)?
        
    // MARK: - Properties
    
    private let useCase: PokeMyFriendsUseCase
    private var cancelBag = CancelBag()
    private var myFriends: PokeMyFriendsModel?
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let moreFriendListButtonTap: Driver<PokeRelation>
        let pokeButtonTap: Driver<PokeUserModel?>
        let profileImageTap: Driver<PokeUserModel?>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let myFriends = PassthroughSubject<PokeMyFriendsModel, Never>()
    }
    
    // MARK: - initialization
    
    public init(useCase: PokeMyFriendsUseCase) {
        self.useCase = useCase
    }
}
    
extension PokeMyFriendsViewModel {
    public func transform(from input: Input, cancelBag: Core.CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                owner.useCase.getFriends()
            }.store(in: cancelBag)
        
        input.moreFriendListButtonTap
            .withUnretained(self)
            .sink { owner, relation in
                owner.showFriendsListButtonTap?(relation)
            }.store(in: cancelBag)
        
        input.pokeButtonTap
            .compactMap { $0 }
            .flatMap { [weak self] userModel -> Driver<(PokeUserModel, PokeMessageModel)> in
                guard let self, let value = self.onPokeButtonTapped?(userModel) else { return .empty() }
                return value
            }
            .sink {[weak self] userModel, messageModel in
                self?.useCase.poke(userId: userModel.userId, message: messageModel)
            }.store(in: cancelBag)
        
        input.profileImageTap
            .compactMap { $0 }
            .sink { [weak self] user in
                self?.onProfileImageTapped?(user.playgroundId)
            }.store(in: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.myFriends
            .subscribe(output.myFriends)
            .store(in: cancelBag)
        
        useCase.myFriends
            .sink { [weak self] myFriends in
                self?.myFriends = myFriends
            }.store(in: cancelBag)
        
        useCase.pokedResponse
            .withUnretained(self)
            .sink { owner, user in
                owner.myFriends = owner.myFriends?.replaceUser(newUserModel: user)
                if let myFriends = owner.myFriends {
                    output.myFriends.send(myFriends)
                }
            }.store(in: cancelBag)
    }
}
