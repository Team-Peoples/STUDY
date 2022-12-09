//
//  CreatingStudyCompleteViewController.swift
//  STUDYA
//
//  Created by 서동운 on 12/9/22.
//

import UIKit

class CreatingStudyCompleteViewController: UIViewController {
    
    // MARK: - Properties
    
    private let titleLabel = CustomLabel(title: "스터디를 만들었어요!", tintColor: .ppsBlack, size: 28, isBold: true)
    private let completeImageView = UIImageView(image: UIImage(named: "congratulation"))
    private let completeButton = BrandButton(title: "완료", isBold: true, isFill: true, fontSize: 28, height: 50)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        completeButton.addTarget(self, action: #selector(completeButtonDidTapped), for: .touchUpInside)
        
        navigationController?.setBrandNavigation()
        navigationController?.navigationBar.tintColor = .black
        navigationItem.hidesBackButton = true
        
        configureViews()
        setConstraints()
    }
    
    // MARK: - Actions
    
    @objc private func completeButtonDidTapped() {
        self.dismiss(animated: true)
    }
    
    
    // MARK: - Configure
    
    private func configureViews() {
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(completeImageView)
        view.addSubview(completeButton)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        completeImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(100)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(200)
        }
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(completeImageView.snp.top).offset(-35)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(completeImageView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
}
