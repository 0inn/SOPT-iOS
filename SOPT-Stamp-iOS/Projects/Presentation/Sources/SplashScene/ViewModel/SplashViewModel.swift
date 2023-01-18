//
//  SplashViewModel.swift
//  Presentation
//
//  Created by sejin on 2023/01/18.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain

public class SplashViewModel: ViewModelType {

    private let useCase: AppNoticeUseCase
    private var cancelBag = CancelBag()
  
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        var appNoticeModel = PassthroughSubject<AppNoticeModel?, Never>()
    }
    
    // MARK: - init
  
    public init(useCase: AppNoticeUseCase) {
        self.useCase = useCase
    }
}

extension SplashViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.viewDidLoad.sink { _ in
            self.useCase.getAppNotice()
        }.store(in: cancelBag)
  
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.appNoticeModel.sink { event in
            print("SplashViewModel - completion: \(event)")
        } receiveValue: { appNoticeModel in
            guard let appNoticeModel = appNoticeModel else {
                output.appNoticeModel.send(nil)
                return
            }
            output.appNoticeModel.send(appNoticeModel)
        }.store(in: cancelBag)
    }
}
