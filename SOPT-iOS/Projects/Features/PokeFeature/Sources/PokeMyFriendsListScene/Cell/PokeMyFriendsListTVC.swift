//
//  PokeMyFriendsListTVC.swift
//  PokeFeature
//
//  Created by sejin on 12/23/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit
import Domain

final class PokeMyFriendsListTVC: UITableViewCell {
    
    // MARK: - UI Components
    
    private let profileListView = PokeProfileListView(viewType: .default)
        .setDividerViewIsHidden(to: false)
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension PokeMyFriendsListTVC {
    
    private func setUI() {
        backgroundColor = .clear
    }
    
    private func setLayout() {
        self.addSubviews(profileListView)
        
        profileListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension PokeMyFriendsListTVC {
    func setData(model: PokeUserModel) {
        profileListView.setData(with: model)
    }
}
