//
//  StudyInfoEditViewController.swift
//  STUDYA
//
//  Created by 서동운 on 11/10/22.
//

import UIKit

class StudyBasicInfoEditViewController: StudyBasicInfoViewController {
    // MARK: - Properties
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigation()
    }

    // MARK: - Actions
    
    @objc func barButtonDidTapped() {
        
        self.dismiss(animated: true)
    }
    
    private func setNavigation() {
        self.navigationItem.title = "스터디 정보관리"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.backgroundColor = .appColor(.keyColor1)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(barButtonDidTapped))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(barButtonDidTapped))
        
        self.navigationItem.rightBarButtonItem?.tintColor = .appColor(.cancel)
        self.navigationItem.leftBarButtonItem?.tintColor = .appColor(.cancel)
    }
    
    // MARK: - Setting Constraints
}
