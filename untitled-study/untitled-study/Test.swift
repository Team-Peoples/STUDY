//
//  Test.swift
//  Untitled-Study
//
//  Created by 신동훈 on 2022/07/31.
//

import Foundation
import UIKit

class testVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
    
        let tv = grayBorderTextView(placeholder: "스터디 내용을 입력해주세요.", maxCharactersNumber: 10)

        view.addSubview(tv)
        
        tv.snp.makeConstraints { make in
            make.left.equalTo(view).offset(10)
            make.top.equalTo(view).offset(50)
            make.right.equalTo(view).offset(-10)
        }
    }
}
