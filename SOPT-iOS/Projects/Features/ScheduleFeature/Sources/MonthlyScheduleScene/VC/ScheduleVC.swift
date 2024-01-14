//
//  ScheduleVC.swift
//  ScheduleFeature
//
//  Created by 김영인 on 2023/12/26.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine
import UIKit

import Core
import Domain
import DSKit

import BaseFeatureDependency
import ScheduleFeatureInterface

public final class ScheduleVC: UIViewController, ScheduleViewControllable {
    
    typealias MonthlyScheduleListModel = [MonthlyScheduleModel]
    typealias ScheduleDataSource = UICollectionViewDiffableDataSource<Int, MonthlyScheduleModel>
    typealias ScheduleSnapshot = NSDiffableDataSourceSnapshot<Int, MonthlyScheduleModel>
                                                                        
    // MARK: - Properties
    
    public var viewModel: ScheduleViewModel
    private var cancelBag = CancelBag()
    
    public var onNaviBackTap: (() -> Void)?
    
    private lazy var scheduleDataSource: ScheduleDataSource! = nil
    
    // MARK: - UI Compenents
    
    private let navigationBar: ScheduleNavigationBar = .init()
    
    private let calendarDayHeaderView: CalendarDayHeaderView = .init()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.backgroundColor = DSKitAsset.Colors.semanticBackground.color
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        ScheduleCVC.register(target: cv)
        return cv
    }()
    
    // MARK: - initialization
    
    public init(viewModel: ScheduleViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        setDataSource()
        bindViewModel()
    }
}

// MARK: - UI & Layout

extension ScheduleVC {
    private func setUI() {
        view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setLayout() {
        view.addSubviews(navigationBar, calendarDayHeaderView, collectionView)
        
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        calendarDayHeaderView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(calendarDayHeaderView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension ScheduleVC {
    private func setDataSource() {
        scheduleDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, model in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleCVC.className, for: indexPath) as? ScheduleCVC else { return UICollectionViewCell() }
            cell.applyMonthlySnapshot(model: model)
            
            return cell
        }
    }
    
    private func applySnapshot(model: MonthlyScheduleListModel) {
        var snapshot = ScheduleSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(model)
        
        scheduleDataSource.apply(snapshot)
    }
    
    private func bindViewModel() {
        let input = ScheduleViewModel.Input(
            viewDidLoad: Just(()).asDriver()
        )
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
        
        output.monthlyScheduleList
            .withUnretained(self)
            .sink { owner, scheduleList in
                owner.applySnapshot(model: scheduleList)
            }
            .store(in: cancelBag)
    }
}

// MARK: - UICollectionViewDelegate

extension ScheduleVC: UICollectionViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.isScrollEnabled = scrollView.contentOffset.x > 0
    }
}
