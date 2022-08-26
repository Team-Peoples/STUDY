//
//  NoticeBoardTableViewCell.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/19.
//

import UIKit

class NoticeBoardTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    ///ViewModel
    var isPinned: Bool? {
        willSet(value) {
            if value == true {
                
                cell.backgroundColor = UIColor.appColor(.brandMilky)
                cell.layer.borderColor = UIColor.appColor(.brandLight).cgColor
                cell.layer.borderWidth = 2
            }
        }
    }
    var notice: Notice? {
        didSet {
            
            titleLabel.text = notice?.title
            contentLabel.text = notice?.content
            timeLabel.text = notice?.date
            isPinned = notice?.isPined
        }
    }
    
    private let titleLabel: CustomLabel = {
        let lbl = CustomLabel(title: "", tintColor: .titleGeneral, size: 18, isBold: true)
        
        lbl.numberOfLines = 1
        lbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return lbl
    }()
    
    private let contentLabel: UILabel = {
        let lbl = UILabel()
        
        lbl.textColor = UIColor.appColor(.subTitleGeneral)
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.numberOfLines = 2
        
        return lbl
    }()
    
    private let timeLabel: UILabel = {
        let lbl = UILabel()
        
        lbl.textColor = UIColor.appColor(.subTitleGeneral)
        lbl.font = UIFont.systemFont(ofSize: 14)
        
        return lbl
    }()
    
    private let cell: UIView = {
        let v = UIView()
        
        v.layer.cornerRadius = 24
        v.clipsToBounds = true
        v.backgroundColor = .white
        
        return v
    }()
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Configure
    
    private func configureViews() {
        backgroundColor = UIColor.appColor(.background)
        addSubview(cell)
        
        cell.addSubview(titleLabel)
        cell.addSubview(timeLabel)
        cell.addSubview(contentLabel)
    }
    
    // MARK: - Setting Constraints
    func setConstraints() {
        cell.snp.makeConstraints { make in
            make.top.bottom.equalTo(self).inset(7.5)
            make.leading.trailing.equalTo(self).inset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(cell).offset(28)
            make.leading.equalTo(cell).offset(24)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.trailing.equalTo(cell).inset(24)
            make.bottom.equalTo(titleLabel.snp.bottom)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.bottom.equalTo(cell).inset(28)
            make.leading.trailing.equalTo(cell).inset(24)
        }
    }
}
