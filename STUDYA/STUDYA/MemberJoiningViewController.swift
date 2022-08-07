//
//  MemberJoiningViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/05.
//

import UIKit

class MemberJoiningViewController: UIViewController {
    
    let memberJoiningView = MemberJoiningView(frame: .zero)
    
    override func loadView() {
        view = memberJoiningView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func erase() {
        print("지워짐")
    }
}


