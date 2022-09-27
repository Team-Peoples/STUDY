//
//  CreatingStudyCompleteViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/09/13.
//

import UIKit

class CreatingStudyCompleteViewController: UIViewController {

    // MARK: - Properties
    
    var study: Study?
    
    /// 스터디 필수정보
    @IBOutlet weak var studyCategoryBackgroundView: UIView!
    @IBOutlet weak var studyCategoryLabel: UILabel!
    @IBOutlet weak var studyInfoBackgroundView: UIView!
    @IBOutlet weak var studyNameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var studyTypeLabel: UILabel!
    @IBOutlet weak var studyIntroductionLabel: UILabel!
    
    /// 스터디 선택정보
    @IBOutlet weak var studyRuleBackgroundView: UIView!
    @IBOutlet weak var attendanceRuleLabel: UILabel!
    @IBOutlet weak var excommunicationRuleLabel: UILabel!
    @IBOutlet weak var freeRuleTitleLabel: UILabel!
    @IBOutlet weak var freeRuleTextView: UITextView!
    
    @IBOutlet weak var attendanceRuleContentsHeight: NSLayoutConstraint!
    @IBOutlet weak var excommunocationRuleContentsHeight: NSLayoutConstraint!
    
    private let completeButton = CustomButton(title: "완료", isFill: true)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(completeButton)
        completeButton.addTarget(self, action: #selector(completeButtonDidTapped), for: .touchUpInside)
        
        setCompleteButtonConstraints()
        
        studyInfoBackgroundView.configureBorder(color: .keyColor3, width: 1, radius: 24)
        studyCategoryBackgroundView.configureBorder(color: .keyColor3, width: 1, radius: self.studyCategoryBackgroundView.frame.height / 2)
        
        //스터디 필수입력 정보들은 바로 label의 text로 입력해줌.
        
        studyCategoryLabel.text = study?.category
        studyNameLabel.text = study?.title
        studyIntroductionLabel.text = study?.studyDescription
        studyTypeLabel.text = OnOff(rawValue: (study?.onoff)!)?.kor
        
        // freeRule부터 확인한 이유: 따로 ui작업이 필요없기때문에 먼저 확인
        if let freeRule = study?.freeRule {
            
            freeRuleTextView.text = freeRule
            freeRuleTextView.textColor = .appColor(.ppsGray1)
        }
        
        let latenessTime = study?.generalRule?.lateness?.time
        let latenessFine = study?.generalRule?.lateness?.fine
        let perLateTime = study?.generalRule?.lateness?.count
        let absenceTime = study?.generalRule?.absence?.time
        let absenceFine = study?.generalRule?.absence?.fine
        let deposit = study?.generalRule?.deposit
        let LatenessCount = study?.generalRule?.excommunication?.lateness
        let AbsenceCount = study?.generalRule?.excommunication?.absence
        
        let latenessTimeRuleHeight: CGFloat = latenessTime != nil ? 16 : 0
        let latenessFineRuleHeight: CGFloat = latenessFine != nil && perLateTime != nil ? 16 : 0
        let absenceFineRuleHeight: CGFloat = absenceFine != nil  ? 16 : 0
        let depositRuleHeight: CGFloat = deposit != nil ? 16 : 0
        let LatenessCountRuleHeight: CGFloat = LatenessCount != nil ? 16 : 0
        let AbsenceCountRuleHeight: CGFloat = AbsenceCount != nil ? 16 :0
        
        let latenessTimeRule = RuleView(text: "스터디 시작후 \(latenessTime ?? 0)분 부터 지각")
        let absenceTimeRule = absenceTime != nil ? RuleView(text: "스터디 시작후 \(absenceTime ?? 0)분 부터 결석") : RuleView(text: "스터디에 출석하지않으면 결석")
        let latenessFineRule = RuleView(text: "지각 \(perLateTime ?? 0)분당 \(latenessFine ?? 0)원")
        let absenceFineRule = RuleView(text: "결석 1회당 \(absenceFine ?? 0)원")
        let depositRule = RuleView(text: "보증금 \(deposit ?? 0)원")
        
        configure(latenessTimeRule, constrainsWith: attendanceRuleLabel, offset: 4, height: latenessTimeRuleHeight)
        configure(absenceTimeRule, constrainsWith: latenessTimeRule, offset: 4, height: 16)
        configure(latenessFineRule, constrainsWith: absenceTimeRule, offset: 20, height: latenessFineRuleHeight)
        configure(absenceFineRule, constrainsWith: latenessFineRule, offset: 4, height: absenceFineRuleHeight)
        configure(depositRule, constrainsWith: absenceFineRule, offset: 20, height: depositRuleHeight)
            
        /// DashLine  나중에 추가하기
        
        attendanceRuleContentsHeight.constant = 50 + latenessTimeRuleHeight + 16 + latenessFineRuleHeight + absenceFineRuleHeight + depositRuleHeight + 20
        
        
        let latenessCountRule = RuleView(text: "\(LatenessCount ?? 0)번 지각 시 강퇴")
        configure(latenessCountRule, constrainsWith: excommunicationRuleLabel, offset: 4, height: LatenessCountRuleHeight)
            
        let absenceCountRule = RuleView(text: " \(AbsenceCount ?? 0)번 결석 시 강퇴")
        configure(absenceCountRule, constrainsWith: latenessCountRule, offset: 4, height: AbsenceCountRuleHeight)
            
        excommunocationRuleContentsHeight.constant = 50 + LatenessCountRuleHeight + AbsenceCountRuleHeight
    }
    
    // MARK: - Actions
    
    @objc private func completeButtonDidTapped() {
        
        print(#function)
    }
    
    // MARK: - Configure UI
    
    private func configure(_ view: RuleView, constrainsWith standard: UIView, offset: CGFloat, height: CGFloat) {
        
        studyRuleBackgroundView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.top.equalTo(standard.snp.bottom).offset(offset)
            make.leading.equalTo(standard)
            make.height.equalTo(height)
        }
        
        if height == 0 {
            view.isHidden = true
        }
    }
    
    func setCompleteButtonConstraints() {
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.centerX.equalTo(view)
        }
    }
}

// MARK: - RuleView

class RuleView: UIView {
    
    let squre = UIView()
    let label = UILabel()
    
    init(text: String) {
        super.init(frame: .zero)
        
        addSubview(label)
        addSubview(squre)
        
        squre.backgroundColor = .appColor(.ppsBlack)
        squre.layer.cornerRadius = 1
        
        label.text = text
        label.textColor = .appColor(.ppsGray1)
        label.font = UIFont.boldSystemFont(ofSize: 12)
        
        label.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.trailing.equalTo(self)
        }
        squre.snp.makeConstraints { make in
            make.width.height.equalTo(6)
            make.leading.equalTo(self)
            make.centerY.equalTo(self)
            make.trailing.equalTo(label.snp.leading).offset(-4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
