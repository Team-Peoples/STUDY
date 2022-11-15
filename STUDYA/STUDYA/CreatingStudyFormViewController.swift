//
//  CreatingStudyFormViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/10.
//

import UIKit
import SnapKit

final class CreatingStudyFormViewController: StudyFormViewController {
    // MARK: - Properties
    
    override var studyViewModel: StudyViewModel? {
        didSet {
            guard let studyViewModel = studyViewModel else { return }
            doneButton.isEnabled = studyViewModel.formIsValid
            doneButton.isEnabled ? doneButton.fillIn(title: "다음") : doneButton.fillOut(title: "다음")
        }
    }
    
    private let titleLabel = CustomLabel(title: "어떤 스터디를\n만들까요", tintColor: .ppsBlack, size: 24, isBold: true)

    /// 다음 버튼
    private let bottomStickyView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8).cgColor
        return v
    }()
    private let doneButton = CustomButton(title: "다음", isBold: true, isFill: false)

    private lazy var closeButton = UIBarButtonItem(image: UIImage(named: "close"), style: .done, target: self, action: #selector(closeButtonDidTapped))
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        studyViewModel = StudyViewModel()
        
        configureTitleLabel()
        configureDoneButton()
        setNavigation()
    }
    

    // MARK: - Configure

    private func configureTitleLabel() {
        
        containerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(41)
            make.leading.trailing.equalTo(containerView.safeAreaLayoutGuide).inset(17)
        }
        studyCategoryLabel.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.equalTo(titleLabel)
        }
    }
    
    func configureDoneButton() {
        
        view.addSubview(bottomStickyView)
        bottomStickyView.addSubview(doneButton)
        
        doneButton.addTarget(self, action: #selector(doneButtonDidTapped), for: .touchUpInside)
        doneButton.isEnabled = false
        
        bottomStickyView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(view)
            make.height.equalTo(100 + 30)
        }
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(bottomStickyView).inset(16)
            make.height.equalTo(50)
            make.leading.trailing.equalTo(bottomStickyView).inset(20)
            make.centerX.equalTo(bottomStickyView)
        }
    }

    // MARK: - Actions
    
    @objc func doneButtonDidTapped() {

        let vc = CreatingStudyRuleViewController()

        vc.studyRuleViewModel.study = studyViewModel!.study
        vc.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func closeButtonDidTapped() {

        self.dismiss(animated: true)
    }
    
    private func setNavigation() {
        
        self.navigationItem.title = "스터디 만들기"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.rightBarButtonItem = closeButton
    }
}
