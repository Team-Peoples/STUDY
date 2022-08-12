///
//  Color.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/07/31.
//

import UIKit

enum AssetColor: String {
    case brandLight, brandMedium, brandDark, descriptionGeneral, subTitleGeneral, titleGeneral,background, kakao, kakaoBrown, naver
}

extension UIColor {
    
    static func appColor(_ name: AssetColor) -> UIColor {
        switch name {
            case .brandLight:
                return UIColor(named: AssetColor.brandLight.rawValue)!
            case .brandMedium:
                return UIColor(named: AssetColor.brandMedium.rawValue)!
            case .brandDark:
                return UIColor(named: AssetColor.brandDark.rawValue)!
            case .descriptionGeneral:
                return UIColor(named: AssetColor.descriptionGeneral.rawValue)!
            case .subTitleGeneral:
                return UIColor(named: AssetColor.subTitleGeneral.rawValue)!
            case .titleGeneral:
                return UIColor(named: AssetColor.titleGeneral.rawValue)!
            case .background:
                return UIColor(named: AssetColor.background.rawValue)!
            case .kakao:
                return UIColor(red: 254/255, green: 229/255, blue: 0, alpha: 1)
            case .kakaoBrown:
                return UIColor(red: 60/255, green: 30/255, blue: 30/255, alpha: 1)
            case .naver:
                return UIColor(red: 3/255, green: 199/255, blue: 90/255, alpha: 1)
        }
    }
}
