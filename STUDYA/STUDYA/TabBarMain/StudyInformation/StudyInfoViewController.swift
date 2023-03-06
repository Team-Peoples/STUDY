//
//  StudyInfoViewController.swift
//  STUDYA
//
//  Created by 서동운 on 11/9/22.
//

import UIKit

final class StudyInfoViewController: SwitchableViewController {
    
    // MARK: - Properties
    
    static let identifier = "StudyInfoViewController"
    
    var studyID: ID?
    
    private let studyViewModel = StudyViewModel()
    
    /// 스터디 폼
    @IBOutlet weak var studyCategoryBackgroundView: UIView!
    @IBOutlet weak var studyCategoryLabel: UILabel!
    @IBOutlet weak var studyInfoBackgroundView: UIView!
    @IBOutlet weak var studyNameLabel: UILabel!
    @IBOutlet weak var studyOwnerNicknameLabel: UILabel!
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
    
    @IBOutlet weak var studyLeaveOrCloseButton: UIButton!
    
    private lazy var separateLineBetweenTimeAndFineSection = UIView(backgroundColor: .appColor(.ppsGray2))
    private lazy var separateLineBetweenFineAndDepositSection = UIView(backgroundColor: .appColor(.ppsGray2))
    
    private lazy var toastMessage = ToastMessage(message: "초대 링크가 복사되었습니다.", messageColor: .whiteLabel, messageSize: 12, image: "copy-check")
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studyViewModel.study.id = studyID
        
        studyViewModel.bind { [self] study in
            configureViews(study)
        }
        
        getStudyInfo()
        navigationItem.title = isSwitchOn ? "관리자 모드" : "스터디 이름"
        navigationController?.navigationBar.titleTextAttributes = isSwitchOn ? [.foregroundColor: UIColor.white] : [.foregroundColor: UIColor.black]
        addNotification()
        configureView()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        syncSwitchReverse(isSwitchOn)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    @objc private func studyInfoShouldUpdate() {
        getStudyInfo()
    }
    
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
        
        editingStudyFormVC.studyViewModel.study = studyViewModel.study
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func generalRuleEditButtonDidTapped(_ sender: Any) {

        let studygeneralRuleVC = EditingStudyGeneralRuleViewController()
        studygeneralRuleVC.studyViewModel.study = studyViewModel.study
        
        let vc = UINavigationController(rootViewController: studygeneralRuleVC)
        
        vc.navigationBar.backgroundColor = .appColor(.keyColor1)
        vc.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.appColor(.whiteLabel)]
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true)
    }
    
    @IBAction func freeRuleEditButtonEditButtonDidTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: EditingStudyFreeRuleViewController.identifier, bundle: nil)
        let studyFreeRuleVC = storyboard.instantiateViewController(withIdentifier: EditingStudyFreeRuleViewController.identifier) as! EditingStudyFreeRuleViewController
        studyFreeRuleVC.studyViewModel.study = studyViewModel.study

        let vc = UINavigationController(rootViewController: studyFreeRuleVC)
        
        vc.navigationBar.backgroundColor = .appColor(.keyColor1)
        vc.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.appColor(.whiteLabel)]
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true)
    }
    
    @IBAction func studyLeaveOrCloseButtonDidTapped(_ sender: UIButton) {
        switch sender.title(for: .normal) {
        case UserTaskInStudyInfo.leave.translatedKorean:
            if isManager {
                let vcToPresent = StudyInfoBottomSheetViewController(task: .resignMaster)
                
                vcToPresent.presentingVC = self
                if let sheet = vcToPresent.sheetPresentationController {
                    
                    sheet.detents = [ .custom { _ in return 300 } ]
                    
                    sheet.preferredCornerRadius = 24
                }
                present(vcToPresent, animated: true, completion: nil)
            } else {
                let vcToPresent = StudyInfoBottomSheetViewController(task: .leave)
                
                vcToPresent.presentingVC = self
                if let sheet = vcToPresent.sheetPresentationController {
                    
                    sheet.detents = [ .custom { _ in return 300 } ]
                    
                    sheet.preferredCornerRadius = 24
                }
                present(vcToPresent, animated: true, completion: nil)
            }
        case UserTaskInStudyInfo.ownerClose.translatedKorean:
            let vcToPresent = StudyInfoBottomSheetViewController(task: .ownerClose)
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
        
        navigationItem.title = isSwitchOn ? "관리자 모드" : "스터디 이름"
        
        print("isSwitchOn: ", isSwitchOn)
        print("isManager: ", isManager)
        studyformEditButton.isHidden = !isSwitchOn
        generalRuleEditButton.isHidden = !isSwitchOn
        freeRuleEditButton.isHidden = !isSwitchOn
        
        isSwitchOn ? studyLeaveOrCloseButton.setTitle(UserTaskInStudyInfo.ownerClose.translatedKorean, for: .normal) : studyLeaveOrCloseButton.setTitle(UserTaskInStudyInfo.leave.translatedKorean, for: .normal)
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(studyInfoShouldUpdate), name: .studyInfoShouldUpdate, object: nil)
    }
    
    // MARK: - Networking
    
    private func getStudyInfo() {
        
        studyViewModel.getStudyInfo()
    }
    
    // MARK: - Configure Views
    
    private func configureViews(_ study: Study) {
        
        if let studyCategory = study.category {
            let studyCategoryTranslatedKorean = StudyCategory(rawValue: studyCategory)?.translatedKorean
            studyCategoryLabel.text = studyCategoryTranslatedKorean
        }
        
        studyNameLabel.text = study.studyName
        studyIntroductionLabel.text = study.studyIntroduction
        studyOwnerNicknameLabel.text = study.ownerNickname
        
        setupStudyOnOffLabel(study)
        
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
        
        adjustHeight(of: latenessTimeRuleView, accordingTo: generalRuleLateness?.time)
        adjustHeight(of: absenceTimeRuleView, accordingTo: generalRuleAbsence?.time)
        adjustHeight(of: latenessFineRuleView, accordingTo: generalRuleLateness?.fine)
        adjustHeight(of: absenceFineRuleView, accordingTo: generalRuleAbsence?.fine)
        adjustHeight(of: depositView, accordingTo: deposit)
        adjustHeight(of: latenessCountView, accordingTo: excommunicationRule?.lateness)
        adjustHeight(of: absenceCountView, accordingTo: excommunicationRule?.absence)
        
        separateLineBetweenTimeAndFineSection.isHidden = study.timeSectionIsFilled && study.fineSectionIsFilled ? false : true
        separateLineBetweenFineAndDepositSection.isHidden = study.fineSectionIsFilled && study.depositSectionIsFilled ? false: true
        
        /// Time
        latenessTimeRuleLabel.text = "스터디 시작후 \(generalRuleLateness?.time ?? 0)분 부터 지각"
        absenceTimeRuleLabel.text = generalRuleAbsence?.time != nil ? "스터디 시작후 \(generalRuleAbsence?.time ?? 0)분 부터 결석" : "스터디에 출석하지않으면 결석"
        
        /// Fine
        let perLateMinute = generalRuleLateness?.count
        let latenessFine = generalRuleLateness?.fine
        let absenceFine = generalRuleAbsence?.fine
        
        if latenessFine == 0 {
            latenessFineRuleLabel.text = nil
        } else {
            let latenessFineFormattedDecimal = NumberFormatter.decimalNumberFormatter.string(from: latenessFine ?? 0)
            
            if let perLateMinute {
                latenessFineRuleLabel.text = "지각 \(perLateMinute)분당 \(latenessFineFormattedDecimal!)원 "
            } else {
                latenessFineRuleLabel.text = "지각당 \(latenessFineFormattedDecimal!)원"
            }
        }
        
        if absenceFine == 0 {
            absenceFineRuleLabel.text = nil
        } else {
            let absenceFineFormattedDecimal = NumberFormatter.decimalNumberFormatter.string(from: generalRuleAbsence?.fine ?? 0)
            absenceFineRuleLabel.text = "결석 1회당 \(absenceFineFormattedDecimal!)원"
        }
        
        /// Deposit
        if let deposit = deposit, deposit == 0 {
            depositLabel.text = nil
        } else {
            depositLabel.text = "보증금 \(NumberFormatter.decimalNumberFormatter.string(from: deposit ?? 0)!)원"
        }
        
        /// excommunicationRule
        latenessCountLabel.text = "\(excommunicationRule?.lateness ?? 0)번 지각 시 강퇴"
        absenceCountLabel.text  = "\(excommunicationRule?.absence ?? 0)번 결석 시 강퇴"
    }
    
    private func configureView() {
        studyInfoBackgroundView.configureBorder(color: .keyColor3, width: 1, radius: 24)
        studyCategoryBackgroundView.configureBorder(color: .keyColor3, width: 1, radius: self.studyCategoryBackgroundView.frame.height / 2)
        
        studyGeneralRuleBackgroundView.addSubview(separateLineBetweenTimeAndFineSection)
        studyGeneralRuleBackgroundView.addSubview(separateLineBetweenFineAndDepositSection)
        view.addSubview(toastMessage)
    }
    
    private func setupStudyOnOffLabel(_ study: Study) {
        let studyOn = study.studyOn
        let studyOff = study.studyOff
        
        switch (studyOn, studyOff) {
        case (true, true):
            studyTypeLabel.text = OnOff.onoff.translatedKorean
        case (false, true):
            studyTypeLabel.text = OnOff.off.translatedKorean
        case (true, false):
            studyTypeLabel.text = OnOff.on.translatedKorean
        case (false, false):
            studyTypeLabel.text = nil
        }
    }
    
    // MARK: - Setting Constraints
    
    private func adjustHeight(of view: UIView, accordingTo value: Int?) {
        
        if value == nil || value == 0 {
            view.isHidden = true
            view.snp.remakeConstraints { make in
                make.height.equalTo(0)
            }
        } else {
            view.isHidden = false
            view.snp.remakeConstraints { make in
                make.height.equalTo(16)
            }
        }
    }
    
    private func setConstraints() {
        separateLineBetweenTimeAndFineSection.snp.makeConstraints { make in
            make.top.equalTo(absenceTimeRuleView.snp.bottom).offset(10)
            make.height.equalTo(1)
            make.leading.trailing.equalTo(studyGeneralRuleBackgroundView).inset(40)
        }
        separateLineBetweenFineAndDepositSection.snp.makeConstraints { make in
            make.top.equalTo(absenceFineRuleView.snp.bottom).offset(10)
            make.height.equalTo(1)
            make.leading.trailing.equalTo(studyGeneralRuleBackgroundView).inset(40)
        }
        toastMessage.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.width.equalTo(view.frame.width - 14)
            make.height.equalTo(42)
            make.bottom.equalTo(view).offset(50)
        }
    }
}
