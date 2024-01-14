//
//  MonthlyScheduleCVC.swift
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
 캘린더 하단 해당 날짜의 일정을 보여주는 뷰입니다.
 
 13일(토)
 14:00 | 세미나
 17:00 | 메이커스관
 */

final class MonthlyScheduleCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    
    // MARK: - UI Components
    
    private let dateLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.bold.font(size: 18)
        $0.textAlignment = .left
    }
    
    private let scheduleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        invalidateIntrinsicContentSize()
        scheduleStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}

// MARK: - UI & Layout

private extension MonthlyScheduleCVC {
    func setUI() {
        backgroundColor = DSKitAsset.Colors.semanticBackground.color
    }
    
    func setLayout() {
        addSubview(scheduleStackView)
        
        scheduleStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension MonthlyScheduleCVC {
    func setData(with dailySchedule: DailyScheduleModel) {
        dateLabel.text = "\(dailySchedule.date)일 (\(dailySchedule.day.description))"
        dateLabel.textColor = dailySchedule.day.color
        
        scheduleStackView.addArrangedSubview(dateLabel)
        dailySchedule.schedule.forEach { schedule in
            let scheduleView: MonthlyScheduleView = .init(schedule: schedule)
            scheduleStackView.addArrangedSubview(scheduleView)
        }
    }
}
