///
//  Color.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/07/31.
//

import UIKit

enum AssetColor: String {
    case keyColor3, brandMilky, keyColor2, keyColor1, ppsGray2, ppsGray1, ppsBlack, background, subColor1, subColor2, subColor3, ppsGray3, kakao, kakaoBrown, naver, whiteLabel, cancel, attendedMain, lateMain, absentMain, allowedMain, dimming, background2
}

extension UIColor {
    
    static func appColor(_ name: AssetColor) -> UIColor {
        switch name {
        case .keyColor3:
            return UIColor(named: AssetColor.keyColor3.rawValue)!
        case .brandMilky:
            return UIColor(named: AssetColor.brandMilky.rawValue)!
        case .keyColor2:
            return UIColor(named: AssetColor.keyColor2.rawValue)!
        case .keyColor1:
            return UIColor(named: AssetColor.keyColor1.rawValue)!
        case .ppsGray2:
            return UIColor(named: AssetColor.ppsGray2.rawValue)!
        case .ppsGray1:
            return UIColor(named: AssetColor.ppsGray1.rawValue)!
        case .ppsBlack:
            return UIColor(named: AssetColor.ppsBlack.rawValue)!
        case .background:
            return UIColor(named: AssetColor.background.rawValue)!
        case .subColor1:
            return UIColor(named: AssetColor.subColor1.rawValue)!
        case .subColor2:
            return UIColor(named: AssetColor.subColor2.rawValue)!
        case .subColor3:
            return UIColor(named: AssetColor.subColor3.rawValue)!
        case .ppsGray3:
            return UIColor(named: AssetColor.ppsGray3.rawValue)!
        case .kakao:
            return UIColor(red: 254/255, green: 229/255, blue: 0, alpha: 1)
        case .kakaoBrown:
            return UIColor(red: 60/255, green: 30/255, blue: 30/255, alpha: 1)
        case .naver:
            return UIColor(red: 3/255, green: 199/255, blue: 90/255, alpha: 1)
        case .whiteLabel:
            return white
        case .cancel:
            return UIColor(named: AssetColor.cancel.rawValue)!
        case .attendedMain:
            return UIColor(named: AssetColor.attendedMain.rawValue)!
        case .lateMain:
            return UIColor(named: AssetColor.lateMain.rawValue)!
        case .absentMain:
            return UIColor(named: AssetColor.absentMain.rawValue)!
        case .allowedMain:
            return UIColor(named: AssetColor.allowedMain.rawValue)!
        case .dimming:
            return UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        case .background2:
            return UIColor(named: AssetColor.background2.rawValue)!
        }
    }
}
