//
//  StudyInfoViewController.swift
//  STUDYA
//
//  Created by 서동운 on 11/9/22.
//

import UIKit
import SnapKit

final class StudyInfoViewController: SwitchableViewController {
    
    // MARK: - Properties
    
    var studyID: ID?
    
    private var studyViewModel = StudyViewModel()
    
    /// 스터디 폼
    @IBOutlet weak var studyCategoryBackgroundView: UIView!
    @IBOutlet weak var studyCategoryLabel: UILabel!
    @IBOutlet weak var studyInfoBackgroundView: UIView!
    @IBOutlet weak var studyNameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var studyTypeLabel: UILabel!
    @IBOutlet weak var studyIntroductionLabel: UILabel!
    @IBOutlet weak var studyformEditButton: UIButton!
    
    /// 스터디 규칙정보
    @IBOutlet weak var studyGeneralRuleBackgroundView: UIView!
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
    
    @IBOutlet weak var generalRuleEditButton: UIButton!
    
    /// 스터디 진행방식
    ///
    @IBOutlet weak var freeRuleTextView: UITextView!
    @IBOutlet weak var freeRuleEditButton: UIButton!
    
    @IBOutlet weak var studyExitButton: UIButton!
    
    private lazy var toastMessage = ToastMessage(message: "초대 링크가 복사되었습니다.", messageColor: .whiteLabel, messageSize: 12, image: "copy-check")
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studyViewModel.bind { [self] study in
            configureViews(study)
        }
        
        configureView()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        guard let studyID = studyID else { return }
        
        getStudyInfo(studyID)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        syncSwitchReverse(isSwitchOn)
    }
    
    // MARK: - Actions
    
    @IBAction func linkTouched(_ sender: UIButton) {
        
        UIPasteboard.general.string = sender.titleLabel?.text
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) { [self] in
            
            toastMessage.snp.updateConstraints { make in
                make.bottom.equalTo(view).offset(-100)
            }
            
            sender.isUserInteractionEnabled = false
            view.layoutIfNeeded()
        } completion: { _ in
            
            UIView.animate(withDuration: 1, delay: 3, options: .curveLinear) {
                self.toastMessage.alpha = 0
            } completion: {[self] _ in
                
                toastMessage.snp.updateConstraints { make in
                    make.bottom.equalTo(view).offset(50)
                }
                toastMessage.alpha = 0.9
                sender.isUserInteractionEnabled = true
            }
        }
    }
    
    @IBAction func studyInfoEditButtonDidTapped(_ sender: Any) {
        
        let editingStudyFormVC = EditingStudyFormViewController()
        let vc = UINavigationController(rootViewController: editingStudyFormVC)
        
        editingStudyFormVC.studyViewModel = studyViewModel
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func generalRuleEditButtonDidTapped(_ sender: Any) {

        let studygeneralRuleVC = EditingStudyGeneralRuleViewController()
        studygeneralRuleVC.studyViewModel = studyViewModel
        
        let vc = UINavigationController(rootViewController: studygeneralRuleVC)
        
        vc.navigationBar.backgroundColor = .appColor(.keyColor1)
        vc.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.appColor(.whiteLabel)]
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true)
    }
    
    @IBAction func freeRuleEditButtonEditButtonDidTapped(_ sender: Any) {
        
        let studyFreeRuleVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditingStudyFreeRuleViewController") as! EditingStudyFreeRuleViewController
        studyFreeRuleVC.studyViewModel = studyViewModel

        let vc = UINavigationController(rootViewController: studyFreeRuleVC)
        
        vc.navigationBar.backgroundColor = .appColor(.keyColor1)
        vc.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.appColor(.whiteLabel)]
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true)
    }
    
    @IBAction func studyExitButtonDidTapped(_ sender: UIButton) {
        switch sender.title(for: .normal) {
        case "스터디 탈퇴":
            let vcToPresent = StudyExitViewController(task: .exit)

            vcToPresent.presentingVC = self
            if let sheet = vcToPresent.sheetPresentationController {
                
                sheet.detents = [ .custom { _ in return 300 } ]
                
                sheet.preferredCornerRadius = 24
            }
            present(vcToPresent, animated: true, completion: nil)
        case "스터디 종료":
            let vcToPresent = StudyExitViewController(task: .close)
            vcToPresent.studyID = studyID
            vcToPresent.studyName = studyViewModel.study.studyName
            vcToPresent.presentingVC = self
            if let sheet = vcToPresent.sheetPresentationController {
                
                sheet.detents = [ .custom { _ in return 300 } ]
                
                sheet.preferredCornerRadius = 24
            }
            present(vcToPresent, animated: true, completion: nil)
        default:
            return
        }
    }
    
    override func extraWorkWhenSwitchToggled() {
        print("isSwitchOn: ", isSwitchOn)
        print("isManager: ", isManager)
        studyformEditButton.isHidden = !isSwitchOn
        generalRuleEditButton.isHidden = !isSwitchOn
        freeRuleEditButton.isHidden = !isSwitchOn
        
        isSwitchOn ? studyExitButton.setTitle("스터디 종료", for: .normal) : studyExitButton.setTitle("스터디 탈퇴", for: .normal)
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
    
    // MARK: - Networking
    
    private func getStudyInfo(_ studyID: ID) {
        Network.shared.getStudy(studyID: studyID) { result in
            switch result {
            case .success(let studyOverall):
                self.studyViewModel.study = studyOverall.study
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    // MARK: - Configure Views
    
    private func configureViews(_ study: Study) {
        
        //스터디 필수입력 정보들은 바로 label의 text로 입력해줌.
        if let rawValue = study.category {
            studyCategoryLabel.text = StudyCategory(rawValue: rawValue)?.rawValueWithKorean
        }
        studyNameLabel.text = study.studyName
        studyIntroductionLabel.text = study.studyIntroduction
        
        let studyOn = study.studyOn
        let studyOff = study.studyOff
        
        switch (studyOn, studyOff) {
        case (true, true):
            studyTypeLabel.text = OnOff.onoff.kor
        case (false, true):
            studyTypeLabel.text = OnOff.off.kor
        case (true, false):
            studyTypeLabel.text = OnOff.on.kor
        case (false, false):
            studyTypeLabel.text = nil
        }
        
        if let freeRule = study.freeRule {
            
            freeRuleTextView.text = freeRule
            freeRuleTextView.textColor = .appColor(.ppsGray1)
        } else {
            
            freeRuleTextView.text = "스터디 진행 방식을 설정해주세요!"
            freeRuleTextView.textColor = .appColor(.ppsGray2)
        }
        
        let generalRuleLateness = study.generalRule?.lateness
        let generalRuleAbsence = study.generalRule?.absence
        let deposit = study.generalRule?.deposit
        let excommunicationRule = study.generalRule?.excommunication
        
        check(generalRuleLateness?.time, AndSetupHeightOf: latenessTimeRuleView)
        check(generalRuleAbsence?.time, AndSetupHeightOf: absenceTimeRuleView)
        
        if (generalRuleLateness?.time != nil || generalRuleAbsence?.time != nil) && (generalRuleLateness?.fine != nil || generalRuleAbsence?.fine != nil) {
            let separateLine = UIView(backgroundColor: .appColor(.ppsGray2))
            studyGeneralRuleBackgroundView.addSubview(separateLine)
            
            separateLine.snp.makeConstraints { make in
                make.top.equalTo(absenceTimeRuleView.snp.bottom).offset(10)
                make.height.equalTo(1)
                make.leading.trailing.equalTo(studyGeneralRuleBackgroundView).inset(40)
            }
        }
        
        check(generalRuleLateness?.fine, AndSetupHeightOf: latenessFineRuleView)
        check(generalRuleAbsence?.fine, AndSetupHeightOf: absenceFineRuleView)
        
        if (generalRuleLateness?.fine != nil || generalRuleAbsence?.fine != nil) && deposit != nil {
            let separateLine = UIView(backgroundColor: .appColor(.ppsGray2))
            studyGeneralRuleBackgroundView.addSubview(separateLine)
            
            separateLine.snp.makeConstraints { make in
                make.top.equalTo(absenceFineRuleView.snp.bottom).offset(10)
                make.height.equalTo(1)
                make.leading.trailing.equalTo(studyGeneralRuleBackgroundView).inset(40)
            }
        }
        
        check(deposit, AndSetupHeightOf: depositView)
        
        check(excommunicationRule?.lateness, AndSetupHeightOf: latenessCountView)
        check(excommunicationRule?.absence, AndSetupHeightOf: absenceCountView)
        
        latenessTimeRuleLabel.text = "스터디 시작후 \(generalRuleLateness?.time ?? 0)분 부터 지각"
        absenceTimeRuleLabel.text = generalRuleAbsence?.time != nil ? "스터디 시작후 \(generalRuleAbsence?.time ?? 0)분 부터 결석" : "스터디에 출석하지않으면 결석"
        
        latenessFineRuleLabel.text = generalRuleLateness?.count != nil ? "지각 \(generalRuleLateness?.count ?? 0)분당 \(generalRuleLateness?.fine ?? 0)원" : "지각당 \(Formatter.formatIntoDecimal(number: generalRuleLateness?.fine ?? 0) ?? "0")원"
        absenceFineRuleLabel.text = "결석 1회당 \(Formatter.formatIntoDecimal(number: generalRuleAbsence?.fine ?? 0) ?? "0")원"
        
        depositLabel.text = "보증금 \(Formatter.formatIntoDecimal(number: deposit ?? 0) ?? "0")원"
        
        latenessCountLabel.text = "\(excommunicationRule?.lateness ?? 0)번 지각 시 강퇴"
        absenceCountLabel.text  = "\(excommunicationRule?.absence ?? 0)번 결석 시 강퇴"
    }
    
    private func configureView() {
        studyInfoBackgroundView.configureBorder(color: .keyColor3, width: 1, radius: 24)
        studyCategoryBackgroundView.configureBorder(color: .keyColor3, width: 1, radius: self.studyCategoryBackgroundView.frame.height / 2)
        
        view.addSubview(toastMessage)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        toastMessage.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.width.equalTo(view.frame.width - 14)
            make.height.equalTo(42)
            make.bottom.equalTo(view).offset(50)
        }
    }
}
