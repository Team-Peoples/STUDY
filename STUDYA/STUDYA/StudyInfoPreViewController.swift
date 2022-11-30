//
//  StudyInfoPreViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/09/13.
//

import UIKit

class StudyInfoPreViewController: UIViewController {

    // MARK: - Properties
    
    var study: Study?
    
    /// 스터디 폼
    ///
    @IBOutlet weak var studyCategoryBackgroundView: UIView!
    @IBOutlet weak var studyCategoryLabel: UILabel!
    @IBOutlet weak var studyInfoBackgroundView: UIView!
    @IBOutlet weak var studyNameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var studyTypeLabel: UILabel!
    @IBOutlet weak var studyIntroductionLabel: UILabel!
    
    /// 스터디 규칙정보
    ///
    @IBOutlet weak var latenessTimeRuleView: UIView!
    @IBOutlet weak var latenessTimeRuleLabel: UILabel!
    
    @IBOutlet weak var absenceTimeRuleView: UIView!
    @IBOutlet weak var absenceTimeRuleLabel: UILabel!
    
    @IBOutlet weak var latenessFineRuleView: UIView!
    @IBOutlet weak var latenessFineRuleLabel: UILabel!
    
    @IBOutlet weak var absenceFineRuleView: UIView!
    @IBOutlet weak var absenceFineRuleLabel: UILabel!
    
    @IBOutlet weak var depositView: UIView!
    @IBOutlet weak var depositLabel: UILabel!
    
    
    @IBOutlet weak var latenessCountView: UIView!
    @IBOutlet weak var latenessCountLabel: UILabel!
    
    
    @IBOutlet weak var absenceCountView: UIView!
    @IBOutlet weak var absenceCountLabel: UILabel!
    
    /// 스터디 진행방식
    ///
    @IBOutlet weak var freeRuleTextView: UITextView!
    
    private let completeButton = BrandButton(title: "완료", isFill: true)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(completeButton)
        completeButton.addTarget(self, action: #selector(completeButtonDidTapped), for: .touchUpInside)
        
        setCompleteButtonConstraints()
        
        studyInfoBackgroundView.configureBorder(color: .keyColor3, width: 1, radius: 24)
        studyCategoryBackgroundView.configureBorder(color: .keyColor3, width: 1, radius: self.studyCategoryBackgroundView.frame.height / 2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureViews()
    }
    
    // MARK: - Configure Views
    
    private func configureViews() {
        
        //스터디 필수입력 정보들은 바로 label의 text로 입력해줌.
        
        studyCategoryLabel.text = study?.category
        studyNameLabel.text = study?.title
        studyIntroductionLabel.text = study?.studyDescription
        studyTypeLabel.text = OnOff(rawValue: (study?.onoff)!)?.kor
        
        // freeRule부터 확인한 이유: 따로 ui작업이 필요없기때문에 먼저 확인
        if let freeRule = study?.freeRule {
            
            freeRuleTextView.text = freeRule
            freeRuleTextView.textColor = .appColor(.ppsGray1)
        } else {
            
            freeRuleTextView.text = "스터디 진행 방식을 설정해주세요!"
            freeRuleTextView.textColor = .appColor(.ppsGray2)
        }
        
        let generalRuleLateness = study?.generalRule?.lateness
        let generalRuleAbsence = study?.generalRule?.absence
        let deposit = study?.generalRule?.deposit
        let excommunicationRule = study?.generalRule?.excommunication
        
        check(generalRuleLateness?.time, AndSetupHeightOf: latenessTimeRuleView)
        check(generalRuleAbsence?.time, AndSetupHeightOf: absenceTimeRuleView)
        
        check(generalRuleLateness?.fine, AndSetupHeightOf: latenessFineRuleView)
        check(generalRuleAbsence?.fine, AndSetupHeightOf: absenceFineRuleView)
        
        check(deposit, AndSetupHeightOf: depositView)
        
        check(excommunicationRule?.lateness, AndSetupHeightOf: latenessCountView)
        check(excommunicationRule?.absence, AndSetupHeightOf: absenceCountView)
        
        latenessTimeRuleLabel.text = "스터디 시작후 \(generalRuleLateness?.time ?? 0)분 부터 지각"
        absenceTimeRuleLabel.text = generalRuleAbsence?.time != nil ? "스터디 시작후 \(generalRuleAbsence?.time ?? 0)분 부터 결석" : "스터디에 출석하지않으면 결석"
        
        latenessFineRuleLabel.text = generalRuleLateness?.count != nil ? "지각 \(generalRuleLateness?.count ?? 0)분당 \(generalRuleLateness?.fine ?? 0)원" : "지각당 \(generalRuleLateness?.fine ?? 0)원"
        absenceFineRuleLabel.text = "결석 1회당 \(generalRuleAbsence?.fine ?? 0)원"
        
        depositLabel.text = "보증금 \(deposit ?? 0)원"
        
        latenessCountLabel.text = "\(excommunicationRule?.lateness ?? 0)번 지각 시 강퇴"
        absenceCountLabel.text  = "\(excommunicationRule?.absence ?? 0)번 결석 시 강퇴"
    }
    
    // MARK: - Actions
    
    @objc private func completeButtonDidTapped() {
        
        print(#function)
    }
    
    
    private func check(_ value: Int?, AndSetupHeightOf view: UIView) {
    
        if value != nil {
            
            view.isHidden = false
            view.snp.remakeConstraints { make in
                make.height.equalTo(16)
            }
        } else {
            
            view.isHidden = true
            view.snp.remakeConstraints { make in
                make.height.equalTo(0)
            }
        }
    }
    
    // MARK: - Setting Constraints
    
    func setCompleteButtonConstraints() {
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.centerX.equalTo(view)
        }
    }
}
