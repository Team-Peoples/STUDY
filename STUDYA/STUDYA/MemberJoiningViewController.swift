//
//  MemberJoiningViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/05.
//

import UIKit

class MemberJoiningViewController: UIViewController {
    
    let meberJoiningView = MemberJoiningView(frame: .zero)
    
    override func loadView() {
        view = meberJoiningView
    }
}
