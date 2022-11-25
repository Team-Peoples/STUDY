//
//  AttendanceBottomDayCheckConditionSettingView.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/23.
//

import UIKit

final class AttendanceBottomDaySearchSettingView: FullDoneButtonButtomView {
    
    internal var delegate: AttendanceBottomViewController?
    
    private let titleLabel = CustomLabel(title: "조회조건설정", tintColor: .ppsBlack, size: 16, isBold: true)
    private let separator: UIView = {
        
        let v = UIView(frame: .zero)
        
        v.backgroundColor = .appColor(.ppsGray3)
        
        return v
    }()
    private let sortTitleLabel = CustomLabel(title: "정렬기준", tintColor: .ppsBlack, size: 14, isBold: true)
    private lazy var nameInOrderButton = CustomButton(fontSize: 14, isBold: false, normalBackgroundColor: .background, normalTitleColor: .ppsGray2, height: 36, normalBorderColor: .ppsGray2, normalTitle: "이름순", selectedTitleColor: .keyColor1, selectedBorderColor: .keyColor1, target: self, action: #selector(changeOrderType))
    private lazy var attendanceInOrderButton = CustomButton(fontSize: 14, isBold: false, normalBackgroundColor: .background, normalTitleColor: .ppsGray2, height: 36, normalBorderColor: .ppsGray2, normalTitle: "출석순", selectedTitleColor: .keyColor1, selectedBorderColor: .keyColor1, target: self, action: #selector(changeOrderType))
    private let timeTitleLabel = CustomLabel(title: "회차 선택", tintColor: .ppsBlack, size: 14, isBold: true)
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        
        let f = UICollectionViewFlowLayout()
        f.minimumInteritemSpacing = 6
        f.scrollDirection = .horizontal
        
        return f
    }()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    
    init(doneButtonTitle: String, delegate: AttendanceBottomViewController) {
        super.init(doneButtonTitle: doneButtonTitle)
        
        backgroundColor = .systemBackground
        
        self.delegate = delegate
        nameInOrderButton.isSelected = true
        
        configureCollectionView()
        addSubViews()
        setConstraints()
        configureDoneButton(on: self, under: collectionView, constant: 16)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func changeOrderType() {
        nameInOrderButton.toggle()
        attendanceInOrderButton.toggle()
    }
    
    private func configureCollectionView() {
        collectionView.delegate = delegate
        collectionView.dataSource = delegate
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.register(AttendanceTimeCollectionViewCell.self, forCellWithReuseIdentifier: AttendanceTimeCollectionViewCell.identifier)
    }
    
    private func addSubViews() {
        addSubview(titleLabel)
        addSubview(separator)
        addSubview(sortTitleLabel)
        addSubview(nameInOrderButton)
        addSubview(attendanceInOrderButton)
        addSubview(timeTitleLabel)
        addSubview(collectionView)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self.snp.top).inset(24)
        }
        separator.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.height.equalTo(1)
        }
        sortTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(18)
            make.top.equalTo(separator.snp.bottom).offset(24)
        }
        nameInOrderButton.snp.makeConstraints { make in
            make.leading.equalTo(sortTitleLabel.snp.leading)
            make.top.equalTo(sortTitleLabel.snp.bottom).offset(12)
            make.height.equalTo(36)
        }
        attendanceInOrderButton.snp.makeConstraints { make in
            make.leading.equalTo(nameInOrderButton.snp.trailing).offset(14)
            make.trailing.equalTo(self).inset(18)
            make.top.width.equalTo(nameInOrderButton)
            make.height.equalTo(36)
        }
        timeTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(sortTitleLabel.snp.leading)
            make.top.equalTo(nameInOrderButton.snp.bottom).offset(26)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.equalTo(sortTitleLabel.snp.leading)
            make.trailing.equalTo(self)
            make.top.equalTo(timeTitleLabel.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
    }
}
