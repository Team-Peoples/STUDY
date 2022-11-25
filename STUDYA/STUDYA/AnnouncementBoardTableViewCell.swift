//
//  AnnouncementBoardTableViewCell.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/19.
//

import UIKit

final class AnnouncementBoardTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    var announcement: Announcement? {
        didSet {
            
            titleLabel.text = announcement?.title
            contentLabel.text = announcement?.content
            timeLabel.text = announcement?.createdDate?.formatToString()
            isPinned = announcement?.isPinned
        }
    }
    
    var cellAction: (() -> Void) = {}
    var etcAction: (() -> Void) = {}
//    var hideEtcButton: (() -> Void) = {}
    
    private let cell: UIView = {
        let v = UIView()
        
        v.layer.cornerRadius = 24
        v.clipsToBounds = false
        v.backgroundColor = .appColor(.background)

        v.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        v.layer.shadowOpacity = 1
        v.layer.shadowRadius = 5
        v.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        return v
    }()
    
    var isPinned: Bool? {
        willSet(value) {
            if value == true {
                
                cell.layer.borderColor = UIColor.appColor(.keyColor1).cgColor
                cell.layer.borderWidth = 1
            }
        }
    }
    
    private let titleLabel: CustomLabel = {
        let lbl = CustomLabel(title: "", tintColor: .ppsBlack, size: 18, isBold: true)
        
        lbl.numberOfLines = 1
        lbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return lbl
    }()
    
    private let contentLabel: UILabel = {
        let lbl = UILabel()
        
        lbl.textColor = UIColor.appColor(.ppsGray1)
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.numberOfLines = 2
        
        return lbl
    }()
    
    private let timeLabel: UILabel = {
        let lbl = UILabel()
        
        lbl.textColor = UIColor.appColor(.ppsGray1)
        lbl.font = UIFont.systemFont(ofSize: 12)
        
        return lbl
    }()
    
    private lazy var etcButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "etc-row"), for: .normal)
        btn.tintColor = .appColor(.ppsGray2)
        btn.isHidden = true
        return btn
    }()
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellDidTapped)))
        etcButton.addTarget(self, action: #selector(etcButtonDidTapped), for: .touchUpInside)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    private func configureViews() {
        backgroundColor = .clear
        self.contentView.addSubview(cell)

        cell.addSubview(titleLabel)
        cell.addSubview(timeLabel)
        cell.addSubview(contentLabel)
        cell.addSubview(etcButton)
    }
    
    // MARK: - Actions
    
    @objc private func etcButtonDidTapped() {
        etcAction()
    }
    
    @objc private func cellDidTapped() {
        cellAction()
    }
    
    func etcButtonIsHiddenToggle() {
        etcButton.isHidden.toggle()
    }
    
    // MARK: - Setting Constraints
    
    func setConstraints() {
        
        cell.snp.makeConstraints { make in
            make.top.bottom.equalTo(self).inset(7.5)
            make.leading.trailing.equalTo(self).inset(10)
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.top.equalTo(cell).offset(28)
            make.leading.equalTo(cell).offset(24)
        }
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.trailing.equalTo(cell).inset(24)
            make.bottom.equalTo(titleLabel.snp.bottom)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(13)
            make.bottom.greaterThanOrEqualTo(cell).inset(18)
            make.leading.trailing.equalTo(cell).inset(24)
        }
        etcButton.snp.makeConstraints { make in
            make.trailing.equalTo(timeLabel.snp.trailing)
            make.bottom.equalTo(timeLabel.snp.top)
        }
    }
}
