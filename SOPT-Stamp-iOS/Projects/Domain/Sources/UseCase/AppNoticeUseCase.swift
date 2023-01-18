//
//  AppNoticeUseCase.swift
//  Domain
//
//  Created by sejin on 2023/01/18.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import Combine

import Core

public protocol AppNoticeUseCase {
    func getAppNotice()
    
    var appNoticeModel: PassthroughSubject<AppNoticeModel?, Error> { get set }
}

public class DefaultAppNoticeUseCase {
  
    private let repository: AppNoticeRepositoryInterface
    private var cancelBag = CancelBag()

    public var appNoticeModel = PassthroughSubject<AppNoticeModel?, Error>()
    
    public init(repository: AppNoticeRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultAppNoticeUseCase: AppNoticeUseCase {
    public func getAppNotice() {
        repository.getAppNotice().sink { event in
            print("AppNoticeUseCase : \(event)")
        } receiveValue: { appNoticeModel in
            self.appNoticeModel.send(appNoticeModel)
        }.store(in: cancelBag)
    }
}
