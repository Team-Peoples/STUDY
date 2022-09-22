//
//  CreatingStudyRuleCompleteViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/09/13.
//

import UIKit

class CreatingStudyRuleCompleteViewController: UIViewController {

    @IBOutlet weak var studyCategoryBackgroundView: UIView!
    @IBOutlet weak var studyCategoryLabel: UILabel!
    
    @IBOutlet weak var studyInfoBackgroundView: UIView!
    @IBOutlet weak var studyNameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var studyTypeLabel: UILabel!
    @IBOutlet weak var studyIntroductionLabel: UILabel!
    
    @IBOutlet weak var studyRuleBackgroundView: UIView!
    
    @IBOutlet weak var attendanceRuleLabel: UILabel!
    @IBOutlet weak var excommunicationRuleLabel: UILabel!
    @IBOutlet weak var freeRuleTitleLabel: UILabel!
    @IBOutlet weak var freeRuleTextView: UITextView!
    
    @IBOutlet weak var attendanceRuleContentsHeight: NSLayoutConstraint!
    @IBOutlet weak var excommunocationRuleContentsHeight: NSLayoutConstraint!
    
    class Rule: UIView {
        
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
    
    var isFilled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studyInfoBackgroundView.configureBorder(color: .keyColor3, width: 1, radius: 24)
        studyCategoryBackgroundView.configureBorder(color: .keyColor3, width: 1, radius: self.studyCategoryBackgroundView.frame.height / 2)
        
        if isFilled {
            let latenessRule = Rule(text: "스터디 시작후 01분 부터 지각")
            configure(latenessRule, constrainsWith: attendanceRuleLabel, offset: 4)
            
            let absenceRule = Rule(text: "스터디 시작후 30분 부터 결석")
            configure(absenceRule, constrainsWith: latenessRule, offset: 4)
            
            let latenessFineRule = Rule(text: "지각 20분당 1,000원")
            configure(latenessFineRule, constrainsWith: absenceRule, offset: 20)
            
            let absenceFineRule = Rule(text: "결석 1회당 50,000원")
            configure(absenceFineRule, constrainsWith: latenessFineRule, offset: 4)
            
            let depositRule = Rule(text: "보증금 50,000원")
            configure(depositRule, constrainsWith: absenceFineRule, offset: 20)
            
            /// DashLine 추가하기
            
            attendanceRuleContentsHeight.constant = 166
            
            let latenessCountRule = Rule(text: " 50번 지각 시 강퇴")
            configure(latenessCountRule, constrainsWith: excommunicationRuleLabel, offset: 4)
            
            let absenceCountRule = Rule(text: " 5번 결석 시 강퇴")
            configure(absenceCountRule, constrainsWith: latenessCountRule, offset: 4)
            
            excommunocationRuleContentsHeight.constant = 90
            
            freeRuleTextView.text = "자유 형식입니다\n상자와 좌우 20px의 여백을 유지하고 자동 줄바꿈\n글자 수 제한은 없습니다.마지막 줄 아래와 상자 사이에 30px의 여백을 만들어주세요."
            freeRuleTextView.textColor = .appColor(.ppsGray1)
           
        }
    }
    
    private func configure(_ view: Rule, constrainsWith standard: UIView, offset: CGFloat) {
        
        studyRuleBackgroundView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.top.equalTo(standard.snp.bottom).offset(offset)
            make.leading.equalTo(standard)
            make.height.equalTo(16)
        }
    }
}
