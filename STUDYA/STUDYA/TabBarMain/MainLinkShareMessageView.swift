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

class MainLinkShareMessageView: RoundableView {
    
    // MARK: - Properties
    
    weak var delegate: UIViewController?
    
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
        let shareText: String = "share text test!"
        var shareObject = [Any]()
        
        shareObject.append(shareText)
        
        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)

        delegate?.present(activityViewController, animated: true, completion: nil)
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
