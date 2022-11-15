//
//  EditingStudyFormViewController.swift
//  STUDYA
//
//  Created by 서동운 on 11/10/22.
//

import UIKit

final class EditingStudyFormViewController: StudyFormViewController {
    // MARK: - Properties
    
    private lazy var doneButton = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(barButtonDidTapped))
    private lazy var cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(barButtonDidTapped))
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// 스터디 불러와서 스터디 뷰모델을 생성해줌.
        configure(study: studyViewModel!.study)
        
        setNavigation()
    }
    
    // MARK: - Configure
    
    func configure(study: Study) {
        
        studyNameTextView.text = study.title
        studyIntroductionTextView.text = study.studyDescription
        
        switch study.onoff {
            case "on":
                onlineButton.isSelected = true
            case "off":
                offlineButton.isSelected = true
            case "onoff":
                onlineButton.isSelected = true
                offlineButton.isSelected = true
            default:
                return
        }
        
        if studyNameTextView.text != "" {
            studyNameTextView.hidePlaceholder(true)
            studyNameTextView.getCharactersNumerLabel().text = "\(study.title!.count)/10"
        }
        
        if studyIntroductionTextView.text != "" {
            studyIntroductionTextView.hidePlaceholder(true)
            studyIntroductionTextView.getCharactersNumerLabel().text = "\(study.studyDescription!.count)/10"
        }
    
        let indexPath = StudyCategory(rawValue: study.category!)?.indexPath
        // tobefixed: 셀을 가져오지 못함. 버튼을 눌러야 샐을 가져옴.
        let cell = studyCategoryCollectionView.cellForItem(at: indexPath!) as? CategoryCell
        cell?.toogleButton()
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
