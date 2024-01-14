//
//  MonthlyScheduleView.swift
//  ScheduleFeature
//
//  Created by 김영인 on 2023/12/30.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import DSKit

/*
 일정 뷰 하단 스크롤 영역의 각 날짜에 표시되는 일정 중 하나를 보여주는 뷰입니다.
 
 [14:00 | 세미나] <-
 [17:00 | 메이커스관]
 */

final class MonthlyScheduleView: UIView {
    
    // MARK: - Properties
    
    private let schedule: ScheduleModel
    
    // MARK: - UI Components
    
    private lazy var timeStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 3
        $0.addArrangedSubviews(startTimeLabel, endTimeLabel)
    }
    
    private let startTimeLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray10.color
        $0.font = DSKitFontFamily.Suit.bold.font(size: 16)
    }
    
    private let endTimeLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray300.color
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
    }
    
    private let dividerView = UIView().then {
        $0.layer.cornerRadius = 2
    }
    
    private lazy var scheduleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 3
        $0.addArrangedSubviews(titleLabel, placeLabel)
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray10.color
        $0.font = DSKitFontFamily.Suit.bold.font(size: 16)
    }
    
    private let placeLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray300.color
        $0.font = DSKitFontFamily.Suit.bold.font(size: 11)
    }
    
    // MARK: - Initialization
    
    init(schedule: ScheduleModel) {
        self.schedule = schedule
        super.init(frame: .zero)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension MonthlyScheduleView {
    private func setUI() {
        backgroundColor = DSKitAsset.Colors.gray800.color
        layer.cornerRadius = 12
        
        startTimeLabel.text = schedule.startTime
        endTimeLabel.text = schedule.endTime
        dividerView.backgroundColor = schedule.type.selectedColor
        titleLabel.text = schedule.title
    }
    
    private func setLayout() {
        addSubviews(timeStackView, dividerView, scheduleStackView)
        
        self.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        
        timeStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        dividerView.snp.makeConstraints {
            $0.width.equalTo(4)
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.equalTo(timeStackView.snp.leading).offset(70)
        }
        
        scheduleStackView.snp.makeConstraints {
            $0.leading.equalTo(dividerView.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
        }
    }
}
