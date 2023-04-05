//
//  MainLinkShareMessageView.swift
//  STUDYA
//
//  Created by 서동운 on 12/10/22.
//

import UIKit
import KakaoSDKShare
import KakaoSDKTemplate
import LinkPresentation

protocol LinkShareable: AnyObject, MainViewController {
    
}

class MainLinkShareMessageView: RoundableView {
    
    // MARK: - Properties
    
    weak var delegate: LinkShareable?
    
    private let titleLabel = CustomLabel(title: "스터디 링크를 공유할래요!", tintColor: .keyColor2, size: 16, isBold: true)
    private let subTitleLabel = CustomLabel(title: "링크 공유를 통해 멤버를 초대해 보세요☺️", tintColor: .background, size: 12)
    private let disclosureIcon = UIImageView(image: UIImage(named: "smallDisclosureIndicator"))
    private let linkShareButton = UIButton()
    private let closeButton: UIButton = {
        
        let button = UIButton()
        let image = UIImage(named: "close")?.withTintColor(.white)
        
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    // MARK: - Initialization
    init() {
        super.init(cornerRadius: 24)
        
        linkShareButton.addTarget(self, action: #selector(linkShareRegionTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonDidTapped), for: .touchUpInside)
        
        configureViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func linkShareRegionTapped() {
        
        guard let view = delegate?.view else { return }
        
        guard let nickname = UserDefaults.standard.value(forKey: Constant.nickname) as? String else { return }
        guard let studyName = UserDefaults.standard.value(forKey: Constant.currentStudyName) as? String else { return }
        guard let studyID = UserDefaults.standard.value(forKey: Constant.currentStudyID) as? ID else { return }

        DynamicLinkBuilder().getURL(studyID: studyID) { [weak self] dynamicLinkURL, array, error in
            guard let link = dynamicLinkURL?.absoluteString else {
                print("Failed to generate dynamic link URL: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
            let shareText = """
                    "\(nickname)"님이 "\(studyName)"에 초대했어요!
                    
                    아래 링크를 통해 스터디에
                    참여하실 수 있어요 👇🏼
                    
                    참여 링크: "\(link)"
                    
                    어떤 모임이든! 피플즈에서 쉽게 모이고 간편하게 관리해요 📚
                    """
            
            let activityViewController = UIActivityViewController(activityItems : [shareText], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = view
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            activityViewController.popoverPresentationController?.permittedArrowDirections = []
            
            self?.delegate?.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @objc private func closeButtonDidTapped() {
        self.removeFromSuperview()
    }
    
    
    // MARK: - Configure
    
    private func configureViews() {
        backgroundColor = .appColor(.ppsBlack)
        
        addSubview(titleLabel)
        addSubview(disclosureIcon)
        addSubview(subTitleLabel)
        addSubview(closeButton)
        addSubview(linkShareButton)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self).inset(14)
            make.leading.equalTo(self).inset(20)
        }
        disclosureIcon.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.leading.equalTo(titleLabel.snp.trailing).offset(2)
            make.height.equalTo(10)
            make.width.equalTo(5)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel)
            make.bottom.equalTo(self).inset(14)
        }
        closeButton.snp.makeConstraints { make in
            make.height.width.equalTo(14)
            make.trailing.equalTo(self).inset(20)
            make.centerY.equalTo(self)
        }
        linkShareButton.snp.makeConstraints { make in
            make.top.leading.equalTo(titleLabel)
            make.trailing.bottom.equalTo(subTitleLabel)
        }
    }
}
