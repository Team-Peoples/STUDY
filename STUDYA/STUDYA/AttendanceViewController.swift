//
//  AttendanceViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/19.
//

import UIKit

final class AttendanceViewController: UIViewController {
    
    private lazy var managerView: UIView = {
       
        var v = UIView(frame: .zero)
        
        let nib = UINib(nibName: "AttendanceManagerModeView", bundle: nil)
        print(nib.instantiate(withOwner: self))
        v = nib.instantiate(withOwner: self).first as! UIView
        
        return v
    }()
    
    override func loadView() {
        
        view = managerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
