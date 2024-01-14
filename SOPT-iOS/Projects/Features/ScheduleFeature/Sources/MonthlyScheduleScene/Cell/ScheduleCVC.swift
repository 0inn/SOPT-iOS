//
//  ScheduleCVC.swift
//  ScheduleFeature
//
//  Created by 김영인 on 2024/01/04.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import DSKit

/*
 해당하는 달의 전체(캘린더, 해당 날짜 일정)를 보여주는 뷰입니다.
 
 [일 월 화 수 목 금 토]
 13
 [솝커톤]
 [세미나]
 ---
 13일(토)
 14:00 | 세미나
 17:00 | 메이커스관
 */

final class ScheduleCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    
    enum ScheduleSection {
        case calendar
        case dailySchedule
    }
    
    private typealias MonthlyDataSource = UICollectionViewDiffableDataSource<ScheduleSection, DailyScheduleModel>
    private typealias MonthlySnapshot = NSDiffableDataSourceSnapshot<ScheduleSection, DailyScheduleModel>
    
    private lazy var calenderDataSource: MonthlyDataSource! = nil
    private lazy var monthlyScheduleDataSource: MonthlyDataSource! = nil
    
    // MARK: - UI Components
    
    private lazy var calendarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        $0.backgroundColor = DSKitAsset.Colors.semanticBackground.color
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
        CalendarCVC.register(target: $0)
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.gray600.color
    }
    
    private lazy var monthlyScheduleCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createMonthlyScheduleViewLayout()).then {
        $0.backgroundColor = DSKitAsset.Colors.semanticBackground.color
        $0.showsVerticalScrollIndicator = false
        MonthlyScheduleCVC.register(target: $0)
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
        setDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

private extension ScheduleCVC {
    func setUI() {
        backgroundColor = DSKitAsset.Colors.semanticBackground.color
    }
    
    func setLayout() {
        addSubviews(calendarCollectionView, lineView, monthlyScheduleCollectionView)
        
        calendarCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(360)
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.top.equalTo(calendarCollectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        monthlyScheduleCollectionView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension ScheduleCVC {
    private func setDataSource() {
        calenderDataSource = UICollectionViewDiffableDataSource(collectionView: calendarCollectionView) { collectionView, indexPath, dailySchedule in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCVC.className, for: indexPath) as? CalendarCVC
            else { return UICollectionViewCell() }
            cell.setData(with: dailySchedule)
            
            return cell
        }
        
        monthlyScheduleDataSource = UICollectionViewDiffableDataSource(collectionView: monthlyScheduleCollectionView) { collectionView, indexPath, dailySchedule in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthlyScheduleCVC.className, for: indexPath) as? MonthlyScheduleCVC
            else { return UICollectionViewCell() }
            cell.setData(with: dailySchedule)
            
            return cell
        }
    }
    
    func applyMonthlySnapshot(model: MonthlyScheduleModel) {
        var snapshot = MonthlySnapshot()
        snapshot.appendSections([.calendar])
        snapshot.appendItems(model.schedule)
        calendarCollectionView.collectionViewLayout =  createCalendarViewLayout(row: model.row)
        calenderDataSource.apply(snapshot)
        
        snapshot = MonthlySnapshot()
        snapshot.appendSections([.dailySchedule])
        snapshot.appendItems(model.schedule.filter { !$0.schedule.isEmpty })
        monthlyScheduleDataSource.apply(snapshot)
    }
}
