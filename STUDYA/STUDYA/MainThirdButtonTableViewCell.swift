//
//  MainThirdButtonTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/10/15.
//

import UIKit

class MainThirdButtonTableViewCell: UITableViewCell {

    static let identifier = "MainThirdButtonTableViewCell"
    
    internal var attendable = true
    internal var didAttend = false
    
    private lazy var button = CustomButton(title: "  출석하기", isBold: true, isFill: attendable, size: 20, height: 50)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = false
        selectionStyle = .none
        backgroundColor = UIColor.appColor(.background)
        
        if didAttend {
            
        } else {
            if attendable {
                button.fillIn(title: "  출석하기")
                let check = UIImage(named: "boldCheck")?.withTintColor(.white, renderingMode: .alwaysOriginal)
                button.setImage(check, for: .normal)
            } else {
                button.setImage(UIImage(named: "boldCheck"), for: .normal)
                button.setTitleColor(UIColor.appColor(.ppsGray2), for: .normal)
                button.configureBorder(color: .ppsGray2, width: 1, radius: 25)
                button.isEnabled = false
            }
            
            addSubview(button)
            button.anchor(top: topAnchor, topConstant: 20, bottom: bottomAnchor, leading: leadingAnchor, leadingConstant: 20, trailing: trailingAnchor, trailingConstant: 20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
