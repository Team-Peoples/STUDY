//
//  TreatingPersonalDataViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/25.
//

import UIKit

class TreatingPersonalDataViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    fileprivate let titleLabel = CustomLabel(title: "개인정보처리방침", tintColor: .ppsBlack, size: 16, isBold: true, isNecessaryTitle: false)
    fileprivate let descriptionView: UITextView = {
       
        let view = UITextView(frame: .zero)
        view.isScrollEnabled = false
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.appColor(.ppsBlack)
        view.text = "개인정보처리방침, 혹은 개인정보보호정책(Privacy Policy)은 어떤 당사자가 고객의 개인정보를 어떻게 수집, 사용, 공개, 관리하는지를 밝히는 선언 또는 법적 문서를 말한다. 개인 정보는 이름 · 주소 · 생년월일 · 혼인여부 · 연락처 · ID번호 및 유효기간 · 재정정보 · 신용정보 · 의료기록 등 개인이 여행하거나, 매매계약을 체결하는 등의 상황에 있어서, 개인을 식별할 수 있는 정보들을 말한다.[1]어떤 개인정보들이 수집되고, 그것이 비밀로 유지되는지, 협력업체들과 공유하는지 또 다른 회사들에 어떻게 양도되는지 하는 등에 대하여 밝혀 놓고 있다. \n\n개인정보처리방침, 혹은 개인정보보호정책(Privacy Policy)은 어떤 당사자가 고객의 개인정보를 어떻게 수집, 사용, 공개, 관리하는지를 밝히는 선언 또는 법적 문서를 말한다. 개인 정보는 이름 · 주소 · 생년월일 · 혼인여부 · 연락처 · ID번호 및 유효기간 · 재정정보 · 신용정보 · 의료기록 등 개인이 여행하거나, 매매계약을 체결하는 등의 상황에 있어서, 개인을 식별할 수 있는 정보들을 말한다.[1]어떤 개인정보들이 수집되고, 그것이 비밀로 유지되는지, 협력업체들과 공유하는지 또 다른 회사들에 어떻게 양도되는지 하는 등에 대하여 밝혀 놓고 있다.\n\n개인정보처리방침, 혹은 개인정보보호정책(Privacy Policy)은 어떤 당사자가 고객의 개인정보를 어떻게 수집, 사용, 공개, 관리하는지를 밝히는 선언 또는 법적 문서를 말한다. 개인 정보는 이름 · 주소 · 생년월일 · 혼인여부 · 연락처 · ID번호 및 유효기간 · 재정정보 · 신용정보 · 의료기록 등 개인이 여행하거나, 매매계약을 체결하는 등의 상황에 있어서, 개인을 식별할 수 있는 정보들을 말한다.[1]어떤 개인정보들이 수집되고, 그것이 비밀로 유지되는지, 협력업체들과 공유하는지 또 다른 회사들에 어떻게 양도되는지 하는 등에 대하여 밝혀 놓고 있다.\n\n개인정보처리방침, 혹은 개인정보보호정책(Privacy Policy)은 어떤 당사자가 고객의 개인정보를 어떻게 수집, 사용, 공개, 관리하는지를 밝히는 선언 또는 법적 문서를 말한다. 개인 정보는 이름 · 주소 · 생년월일 · 혼인여부 · 연락처 · ID번호 및 유효기간 · 재정정보 · 신용정보 · 의료기록 등 개인이 여행하거나, 매매계약을 체결하는 등의 상황에 있어서, 개인을 식별할 수 있는 정보들을 말한다.[1]어떤 개인정보들이 수집되고, 그것이 비밀로 유지되는지, 협력업체들과 공유하는지 또 다른 회사들에 어떻게 양도되는지 하는 등에 대하여 밝혀 놓고 있다.\n\n개인정보처리방침, 혹은 개인정보보호정책(Privacy Policy)은 어떤 당사자가 고객의 개인정보를 어떻게 수집, 사용, 공개, 관리하는지를 밝히는 선언 또는 법적 문서를 말한다. 개인 정보는 이름 · 주소 · 생년월일 · 혼인여부 · 연락처 · ID번호 및 유효기간 · 재정정보 · 신용정보 · 의료기록 등 개인이 여행하거나, 매매계약을 체결하는 등의 상황에 있어서, 개인을 식별할 수 있는 정보들을 말한다.[1]어떤 개인정보들이 수집되고, 그것이 비밀로 유지되는지, 협력업체들과 공유하는지 또 다른 회사들에 어떻게 양도되는지 하는 등에 대하여 밝혀 놓고 있다.\n\n개인정보처리방침, 혹은 개인정보보호정책(Privacy Policy)은 어떤 당사자가 고객의 개인정보를 어떻게 수집, 사용, 공개, 관리하는지를 밝히는 선언 또는 법적 문서를 말한다. 개인 정보는 이름 · 주소 · 생년월일 · 혼인여부 · 연락처 · ID번호 및 유효기간 · 재정정보 · 신용정보 · 의료기록 등 개인이 여행하거나, 매매계약을 체결하는 등의 상황에 있어서, 개인을 식별할 수 있는 정보들을 말한다.[1]어떤 개인정보들이 수집되고, 그것이 비밀로 유지되는지, 협력업체들과 공유하는지 또 다른 회사들에 어떻게 양도되는지 하는 등에 대하여 밝혀 놓고 있다.\n\n개인정보처리방침, 혹은 개인정보보호정책(Privacy Policy)은 어떤 당사자가 고객의 개인정보를 어떻게 수집, 사용, 공개, 관리하는지를 밝히는 선언 또는 법적 문서를 말한다. 개인 정보는 이름 · 주소 · 생년월일 · 혼인여부 · 연락처 · ID번호 및 유효기간 · 재정정보 · 신용정보 · 의료기록 등 개인이 여행하거나, 매매계약을 체결하는 등의 상황에 있어서, 개인을 식별할 수 있는 정보들을 말한다.[1]어떤 개인정보들이 수집되고, 그것이 비밀로 유지되는지, 협력업체들과 공유하는지 또 다른 회사들에 어떻게 양도되는지 하는 등에 대하여 밝혀 놓고 있다.\n\n이용약관, 혹은 개인정보보호정책(Privacy Policy)은 어떤 당사자가 고객의 개인정보를 어떻게 수집, 사용, 공개, 관리하는지를 밝히는 선언 또는 법적 문서를 말한다. 개인 정보는 이름 · 주소 · 생년월일 · 혼인여부 · 연락처 · ID번호 및 유효기간 · 재정정보 · 신용정보 · 의료기록 등 개인이 여행하거나, 매매계약을 체결하는 등의 상황에 있어서, 개인을 식별할 수 있는 정보들을 말한다.[1]어떤 개인정보들이 수집되고, 그것이 비밀로 유지되는지, 협력업체들과 공유하는지 또 다른 회사들에 어떻게 양도되는지 하는 등에 대하여 밝혀 놓고 있다."
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "앱 정보"
        
        setScrollView()
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionView)
        
        titleLabel.anchor(top: containerView.topAnchor, topConstant: 13, leading: containerView.leadingAnchor, leadingConstant: 30)
        descriptionView.anchor(top: titleLabel.bottomAnchor, topConstant: 40, bottom: containerView.bottomAnchor, bottomConstant: 110, leading: containerView.leadingAnchor, leadingConstant: 30, trailing: containerView.trailingAnchor, trailingConstant: 30)
    }
    
    private func setScrollView() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(scrollView)
        
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor)
        scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
        
        scrollView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.greaterThanOrEqualTo(safeArea.snp.height)
            make.width.equalTo(scrollView.snp.width)
        }
    }
}

final class AgreementViewController: TreatingPersonalDataViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "이용약관"
        descriptionView.text = "이용약관, 혹은 개인정보보호정책(Privacy Policy)은 어떤 당사자가 고객의 개인정보를 어떻게 수집, 사용, 공개, 관리하는지를 밝히는 선언 또는 법적 문서를 말한다. 개인 정보는 이름 · 주소 · 생년월일 · 혼인여부 · 연락처 · ID번호 및 유효기간 · 재정정보 · 신용정보 · 의료기록 등 개인이 여행하거나, 매매계약을 체결하는 등의 상황에 있어서, 개인을 식별할 수 있는 정보들을 말한다.[1]어떤 개인정보들이 수집되고, 그것이 비밀로 유지되는지, 협력업체들과 공유하는지 또 다른 회사들에 어떻게 양도되는지 하는 등에 대하여 밝혀 놓고 있다. \n\n이용약관, 혹은 개인정보보호정책(Privacy Policy)은 어떤 당사자가 고객의 개인정보를 어떻게 수집, 사용, 공개, 관리하는지를 밝히는 선언 또는 법적 문서를 말한다. 개인 정보는 이름 · 주소 · 생년월일 · 혼인여부 · 연락처 · ID번호 및 유효기간 · 재정정보 · 신용정보 · 의료기록 등 개인이 여행하거나, 매매계약을 체결하는 등의 상황에 있어서, 개인을 식별할 수 있는 정보들을 말한다.[1]어떤 개인정보들이 수집되고, 그것이 비밀로 유지되는지, 협력업체들과 공유하는지 또 다른 회사들에 어떻게 양도되는지 하는 등에 대하여 밝혀 놓고 있다.\n\n이용약관, 혹은 개인정보보호정책(Privacy Policy)은 어떤 당사자가 고객의 개인정보를 어떻게 수집, 사용, 공개, 관리하는지를 밝히는 선언 또는 법적 문서를 말한다. 개인 정보는 이름 · 주소 · 생년월일 · 혼인여부 · 연락처 · ID번호 및 유효기간 · 재정정보 · 신용정보 · 의료기록 등 개인이 여행하거나, 매매계약을 체결하는 등의 상황에 있어서, 개인을 식별할 수 있는 정보들을 말한다.[1]어떤 개인정보들이 수집되고, 그것이 비밀로 유지되는지, 협력업체들과 공유하는지 또 다른 회사들에 어떻게 양도되는지 하는 등에 대하여 밝혀 놓고 있다.\n\n이용약관, 혹은 개인정보보호정책(Privacy Policy)은 어떤 당사자가 고객의 개인정보를 어떻게 수집, 사용, 공개, 관리하는지를 밝히는 선언 또는 법적 문서를 말한다. 개인 정보는 이름 · 주소 · 생년월일 · 혼인여부 · 연락처 · ID번호 및 유효기간 · 재정정보 · 신용정보 · 의료기록 등 개인이 여행하거나, 매매계약을 체결하는 등의 상황에 있어서, 개인을 식별할 수 있는 정보들을 말한다.[1]어떤 개인정보들이 수집되고, 그것이 비밀로 유지되는지, 협력업체들과 공유하는지 또 다른 회사들에 어떻게 양도되는지 하는 등에 대하여 밝혀 놓고 있다.\n\n이용약관, 혹은 개인정보보호정책(Privacy Policy)은 어떤 당사자가 고객의 개인정보를 어떻게 수집, 사용, 공개, 관리하는지를 밝히는 선언 또는 법적 문서를 말한다. 개인 정보는 이름 · 주소 · 생년월일 · 혼인여부 · 연락처 · ID번호 및 유효기간 · 재정정보 · 신용정보 · 의료기록 등 개인이 여행하거나, 매매계약을 체결하는 등의 상황에 있어서, 개인을 식별할 수 있는 정보들을 말한다.[1]어떤 개인정보들이 수집되고, 그것이 비밀로 유지되는지, 협력업체들과 공유하는지 또 다른 회사들에 어떻게 양도되는지 하는 등에 대하여 밝혀 놓고 있다.\n\n이용약관, 혹은 개인정보보호정책(Privacy Policy)은 어떤 당사자가 고객의 개인정보를 어떻게 수집, 사용, 공개, 관리하는지를 밝히는 선언 또는 법적 문서를 말한다. 개인 정보는 이름 · 주소 · 생년월일 · 혼인여부 · 연락처 · ID번호 및 유효기간 · 재정정보 · 신용정보 · 의료기록 등 개인이 여행하거나, 매매계약을 체결하는 등의 상황에 있어서, 개인을 식별할 수 있는 정보들을 말한다.[1]어떤 개인정보들이 수집되고, 그것이 비밀로 유지되는지, 협력업체들과 공유하는지 또 다른 회사들에 어떻게 양도되는지 하는 등에 대하여 밝혀 놓고 있다.\n\n이용약관, 혹은 개인정보보호정책(Privacy Policy)은 어떤 당사자가 고객의 개인정보를 어떻게 수집, 사용, 공개, 관리하는지를 밝히는 선언 또는 법적 문서를 말한다. 개인 정보는 이름 · 주소 · 생년월일 · 혼인여부 · 연락처 · ID번호 및 유효기간 · 재정정보 · 신용정보 · 의료기록 등 개인이 여행하거나, 매매계약을 체결하는 등의 상황에 있어서, 개인을 식별할 수 있는 정보들을 말한다.[1]어떤 개인정보들이 수집되고, 그것이 비밀로 유지되는지, 협력업체들과 공유하는지 또 다른 회사들에 어떻게 양도되는지 하는 등에 대하여 밝혀 놓고 있다.\n\n이용약관, 혹은 개인정보보호정책(Privacy Policy)은 어떤 당사자가 고객의 개인정보를 어떻게 수집, 사용, 공개, 관리하는지를 밝히는 선언 또는 법적 문서를 말한다. 개인 정보는 이름 · 주소 · 생년월일 · 혼인여부 · 연락처 · ID번호 및 유효기간 · 재정정보 · 신용정보 · 의료기록 등 개인이 여행하거나, 매매계약을 체결하는 등의 상황에 있어서, 개인을 식별할 수 있는 정보들을 말한다.[1]어떤 개인정보들이 수집되고, 그것이 비밀로 유지되는지, 협력업체들과 공유하는지 또 다른 회사들에 어떻게 양도되는지 하는 등에 대하여 밝혀 놓고 있다."
    }
}
