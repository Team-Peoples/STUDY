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
    private let completeButton = BrandButton(title: Const.done, isBold: true, isFill: true)
    
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
        guard let tabbarController = self.presentingViewController as? UITabBarController else { return }
        guard let mainNavigationController = tabbarController.selectedViewController as? UINavigationController else { return }
        guard let mainVC = mainNavigationController.viewControllers.first as? MainViewController else { return }
        
        dismiss(animated: true) {
            let linkShareMessageView = LinkShareMessageView()
            linkShareMessageView.delegate = mainVC
            mainVC.view.addSubview(linkShareMessageView)
            
            linkShareMessageView.snp.makeConstraints { make in
                make.leading.trailing.equalTo(mainVC.view.safeAreaLayoutGuide).inset(20)
                make.bottom.equalTo(mainVC.view.safeAreaLayoutGuide).offset(-40)
            }
        }
    }
    
    @objc func linkShare() {
        print(#function)
    }
    
    @objc func closeButtonDidTapped() {
        print(#function)
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
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.height.width.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.73)
        }
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(completeImageView.snp.top).offset(-35)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(completeImageView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
}
