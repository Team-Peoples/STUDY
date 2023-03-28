//
//  AttendanceBottomDaySearchSettingViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/23.
//

import UIKit

final class AttendanceBottomDaySearchSettingViewController: FullDoneButtonButtonViewController {
    
    private var viewModel: AttendancesModificationViewModel?
    
    private var time: Time?
    private var alignment: LeftButtonAlignment?
    
    private let titleLabel = CustomLabel(title: "조회조건설정", tintColor: .ppsBlack, size: 16, isBold: true)
    private let separator = UIView(frame: .zero)
    private let sortTitleLabel = CustomLabel(title: "정렬기준", tintColor: .ppsBlack, size: 14, isBold: true)
    private lazy var nameInOrderButton = CustomButton(fontSize: 14, isBold: false, normalBackgroundColor: .background, normalTitleColor: .ppsGray2, height: 36, normalBorderColor: .ppsGray2, normalTitle: "이름순", selectedTitleColor: .keyColor1, selectedBorderColor: .keyColor1, target: self, action: #selector(orderAttendanceDatasInName))
    private lazy var attendanceInOrderButton = CustomButton(fontSize: 14, isBold: false, normalBackgroundColor: .background, normalTitleColor: .ppsGray2, height: 36, normalBorderColor: .ppsGray2, normalTitle: "출석순", selectedTitleColor: .keyColor1, selectedBorderColor: .keyColor1, target: self, action: #selector(orderAttendanceDatasInAttendance))
    private let timeTitleLabel = CustomLabel(title: "회차 선택", tintColor: .ppsBlack, size: 14, isBold: true)
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        
        let f = UICollectionViewFlowLayout()
        f.minimumInteritemSpacing = 6
        f.scrollDirection = .horizontal
        
        return f
    }()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        enableDoneButton()
        
        configureViews()
        configureDoneButton(under: collectionView, constant: 16)
        
        guard let viewModel =  viewModel else { disableDoneButton(); return }
        if viewModel.times.isEmpty {
            disableDoneButton()
        } else {
            enableDoneButton()
        }
    }
    
    @objc private func orderAttendanceDatasInName() {
        alignment = .name
        
        nameInOrderButton.isSelected = true
        attendanceInOrderButton.isSelected = false
    }
    
    @objc private func orderAttendanceDatasInAttendance() {
        alignment = .attendance
        
        nameInOrderButton.isSelected = false
        attendanceInOrderButton.isSelected = true
    }
    
    override func doneButtonTapped() {
        guard let viewModel = viewModel, let time = time, let alignment = alignment else { return }
        
        viewModel.updateAttendancesData(at: time, by: alignment)
        
        dismiss(animated: true)
    }
    
    internal func configureViewWith(viewModel: AttendancesModificationViewModel) {
        self.viewModel = viewModel
        
        self.time = viewModel.selectedTime.value
        self.alignment = viewModel.alignment.value
        
        if alignment == .name {
            nameInOrderButton.isSelected = true
            attendanceInOrderButton.isSelected = false
        } else {
            nameInOrderButton.isSelected = false
            attendanceInOrderButton.isSelected = true
        }
        
        configureCollectionView()
        collectionView.reloadData()
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.register(AttendanceTimeCollectionViewCell.self, forCellWithReuseIdentifier: AttendanceTimeCollectionViewCell.identifier)
    }
    
    private func configureViews() {
        separator.backgroundColor = .appColor(.ppsGray3)
        
        view.addSubview(titleLabel)
        view.addSubview(separator)
        view.addSubview(sortTitleLabel)
        view.addSubview(nameInOrderButton)
        view.addSubview(attendanceInOrderButton)
        view.addSubview(timeTitleLabel)
        view.addSubview(collectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.snp.top).inset(24)
        }
        separator.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.height.equalTo(1)
        }
        sortTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(18)
            make.top.equalTo(separator.snp.bottom).offset(24)
        }
        nameInOrderButton.snp.makeConstraints { make in
            make.leading.equalTo(sortTitleLabel.snp.leading)
            make.top.equalTo(sortTitleLabel.snp.bottom).offset(12)
        }
        attendanceInOrderButton.snp.makeConstraints { make in
            make.leading.equalTo(nameInOrderButton.snp.trailing).offset(14)
            make.trailing.equalTo(view).inset(18)
            make.top.width.equalTo(nameInOrderButton)
        }
        timeTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(sortTitleLabel.snp.leading)
            make.top.equalTo(nameInOrderButton.snp.bottom).offset(26)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.equalTo(sortTitleLabel.snp.leading)
            make.trailing.equalTo(view)
            make.top.equalTo(timeTitleLabel.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
    }
}

extension AttendanceBottomDaySearchSettingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.times.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttendanceTimeCollectionViewCell.identifier, for: indexPath) as! AttendanceTimeCollectionViewCell
        
        cell.time = viewModel?.times[indexPath.item]
        if cell.time == time {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .right)
            cell.enableButton()
        }
        
        return cell
    }
}

extension AttendanceBottomDaySearchSettingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! AttendanceTimeCollectionViewCell
        
        time = viewModel?.times[indexPath.item]
        
        cell.enableButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! AttendanceTimeCollectionViewCell
        cell.disableButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel(frame: CGRect.zero)
        let leftRightInsets:CGFloat = 48
        
        label.text = viewModel?.times[indexPath.item]
        label.sizeToFit()
        
        return CGSize(width: label.frame.width + leftRightInsets, height: 32)
    }
}
