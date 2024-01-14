//
//  CalendarCVC.swift
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
 캘린더의 각 날짜에 표시되는 일정들을 보여주는 뷰입니다.
 
 13
 [솝커톤]
 [세미나]
 */

final class CalendarCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    enum Color {
        static let bg: UIColor = DSKitAsset.Colors.semanticBackground.color
    }
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    
    private var dayType: DayType = .none
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? DSKitAsset.Colors.white.color : DSKitAsset.Colors.semanticBackground.color
            dateLabel.textColor = isSelected ? dayType.selectedColor : dayType.color
            stackView.arrangedSubviews.map { $0 as? CalendarScheduleView }.forEach { $0?.isSelected.toggle() }
        }
    }
    
    // MARK: - UI Components
    
    private let dateLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray10.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 12)
        $0.textAlignment = .center
    }
    
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 2
    }
    
    private let frontView = UIView().then {
        $0.backgroundColor = Color.bg.withAlphaComponent(0.0)
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

private extension CalendarCVC {
    func setUI() {
        backgroundColor = DSKitAsset.Colors.semanticBackground.color
        layer.cornerRadius = 4
    }
    
    func setLayout() {
        addSubviews(dateLabel, stackView, frontView)
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.leading.trailing.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(4)
        }
        
        frontView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension CalendarCVC {
    func setData(with dailySchedule: DailyScheduleModel) {
        dateLabel.text = dailySchedule.dayString
        dateLabel.textColor = dailySchedule.day.color
        dayType = dailySchedule.day
        if !dailySchedule.isCurMonth { frontView.backgroundColor = Color.bg.withAlphaComponent(0.7) }
        
        dailySchedule.schedule.forEach { schedule in
            let scheduleView: CalendarScheduleView = .init(title: schedule.title, type: schedule.type)
            stackView.addArrangedSubview(scheduleView)
        }
    }
}
