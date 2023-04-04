//
//  CreatingStudyCompleteViewController.swift
//  STUDYA
//
//  Created by 서동운 on 12/9/22.
//

import UIKit

final class CreatingStudyCompleteViewController: UIViewController {
    
    // MARK: - Properties
    
    var studyID: ID
    
    private let titleLabel = CustomLabel(title: "스터디를 만들었어요!", tintColor: .ppsBlack, size: 28, isBold: true)
    private let completeImageView = UIImageView(image: UIImage(named: "congratulation"))
    private let completeButton = BrandButton(title: Constant.done, isBold: true, isFill: true)
    
    // MARK: - Life Cycle
    
    init(studyID: ID) {
        self.studyID = studyID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        NotificationCenter.default.post(name: .reloadStudyList, object: nil, userInfo: [Constant.studyID: studyID])
        
        dismiss(animated: true) {
            let linkShareMessageView = MainLinkShareMessageView()
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
        
        view.backgroundColor = .white
        
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
