//
//  MyPageInformationViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/25.
//

import UIKit

final class MyPageInformationViewController: UIViewController {
    
    private let data = ["개인정보처리방침", "이용약관"]
    private let contributors = ["Domb 💎", "EHD 🚀", "Ever ✨", "L 🐳", "Choisang 🌴", "Lims 🎨","Eddy 🚗"]
    
    private let tableView: UITableView = {
       
        let tableView = UITableView()
        
        tableView.register(InformationVersionTableViewCell.self, forCellReuseIdentifier: InformationVersionTableViewCell.identifier)
        tableView.register(InformationTableViewCell.self, forCellReuseIdentifier: InformationTableViewCell.identifier)
        tableView.rowHeight = 65
        tableView.separatorStyle = .none
        
        return tableView
    }()
    private let teamLabel: CustomLabel = {
        
        let label = CustomLabel(title: "만든이들 | Room#8", tintColor: .ppsGray1, size: 16, isBold: true, isNecessaryTitle: false)
        
        let title = label.text! as NSString
        let range = (title).range(of: "Room#8")
        let attribute = NSMutableAttributedString(string: title as String)
        
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.appColor(.keyColor1) , range: range)
        label.attributedText = attribute
        
        return label
    }()
    
    private lazy var contributorCollectionView: UICollectionView = getCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        title = "앱 정보"
        navigationController?.setBrandNavigation()
        
        tableView.dataSource = self
        tableView.delegate = self
        contributorCollectionView.dataSource = self
        
        view.addSubview(tableView)
        view.addSubview(teamLabel)
        view.addSubview(contributorCollectionView)
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, height: 65 * CGFloat((data.count + 1)))
        contributorCollectionView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, bottomConstant: 22, leading: view.leadingAnchor, leadingConstant: 40, trailing: view.trailingAnchor, trailingConstant: 40, height: 110)
        teamLabel.anchor(bottom: contributorCollectionView.topAnchor, bottomConstant: 12, leading: contributorCollectionView.leadingAnchor)
    }
    
    
    private func getCollectionView() -> UICollectionView {
        let flowLayout = LeftAlignedCollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.minimumInteritemSpacing = 3
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        
        return cv
    }
}

extension MyPageInformationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            return InformationVersionTableViewCell()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.identifier, for: indexPath) as? InformationTableViewCell else { return InformationTableViewCell() }
        
        cell.title = data[indexPath.row - 1]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count + 1
    }
}

extension MyPageInformationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: break
        case 1:
            navigationController?.pushViewController(TreatingPersonalDataViewController(), animated: true)
        case 2:
            navigationController?.pushViewController(AgreementViewController(), animated: true)
            
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension MyPageInformationViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contributors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoundedPurpleCell.identifier, for: indexPath) as! RoundedPurpleCell
        cell.title = contributors[indexPath.row]
        return cell
    }
}


// MARK: - InformationVersionTableViewCell
final class InformationVersionTableViewCell: UITableViewCell {
    
    private let titleLabel = CustomLabel(title: "버전 정보", tintColor: .ppsBlack, size: 16)
    private let versionValueLabel = CustomLabel(title: "1.1.0(최신)", tintColor: .ppsBlack, size: 16)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .systemBackground
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(versionValueLabel)
        
        titleLabel.anchor(leading: leadingAnchor, leadingConstant: 30)
        titleLabel.centerY(inView: self)
        versionValueLabel.anchor(trailing: trailingAnchor, trailingConstant: 30)
        versionValueLabel.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - InformationTableViewCell
final class InformationTableViewCell: UITableViewCell {
    
    internal var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    private let titleLabel = CustomLabel(title: "", tintColor: .ppsBlack, size: 16)
    private let disclosureIndicator: UIImageView = {
       
        let imageView = UIImageView(image: UIImage(named: "disclosureIndicator")?.withRenderingMode(.alwaysTemplate))
        
        imageView.tintColor = UIColor.appColor(.ppsGray1)
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(disclosureIndicator)
        
        titleLabel.anchor(leading: leadingAnchor, leadingConstant: 30)
        titleLabel.centerY(inView: self)
        disclosureIndicator.anchor(trailing: trailingAnchor, trailingConstant: 30)
        disclosureIndicator.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
