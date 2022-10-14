//
//  MainThirdButtonTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/10/15.
//

import UIKit

class MainThirdButtonTableViewCell: UITableViewCell {

    internal var attendable = false
    internal var didAttend = false
    
    private lazy var button = CustomButton(title: " 출석하기", isBold: true, isFill: attendable, size: 20, height: 50)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if didAttend {
            
        } else {
            if attendable {
                button.fillIn(title: " 출석하기")
                let check = UIImage(named: "boldCheck")?.withTintColor(.white, renderingMode: .alwaysTemplate)
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
}
