//
//  EditingStudyFormViewController.swift
//  STUDYA
//
//  Created by 서동운 on 11/10/22.
//

import UIKit

final class EditingStudyFormViewController: StudyFormViewController {
    // MARK: - Properties
    
    override var studyViewModel: StudyViewModel? {
        didSet {
            guard let studyViewModel = studyViewModel else { return }
            /// 스터디 뷰모델이 변경되면 씬의 구성을 변경
        }
    }
    
    private lazy var doneButton = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(barButtonDidTapped))
    private lazy var cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(barButtonDidTapped))
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// 스터디 불러와서 스터디 뷰모델을 생성해줌.
        ///
        studyViewModel = StudyViewModel()
        
        setNavigation()
    }
    
    // MARK: - Configure
    
    func configure(study: Study) {
        
        studyNameTextView.text = studyViewModel?.study.title
        studyIntroductionTextView.text = studyViewModel?.study.studyDescription
    }

    // MARK: - Actions
    
    @objc func barButtonDidTapped(sender: UIBarButtonItem) {
        switch sender {
            case doneButton:
                print("수정 완료")
                self.dismiss(animated: true)
            case  cancelButton:
                print("수정 취소")
                self.dismiss(animated: true)
            default:
                return
        }
    }
    
    private func setNavigation() {
        self.navigationItem.title = "스터디 정보관리"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.backgroundColor = .appColor(.keyColor1)
        
        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.leftBarButtonItem = cancelButton
        
        self.navigationItem.rightBarButtonItem?.tintColor = .appColor(.cancel)
        self.navigationItem.leftBarButtonItem?.tintColor = .appColor(.cancel)
    }
    
    // MARK: - Setting Constraints
}
