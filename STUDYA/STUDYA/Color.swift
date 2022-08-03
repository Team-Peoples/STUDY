///
//  Color.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/07/31.
//

import UIKit

enum AssetColor: String {
    case purple, black, placeholder, defaultGray, brandLight, brandMedium, brandThick, descriptionGeneral, subTitleGeneral, titleGeneral
}

extension UIColor {
    
    static func appColor(_ name: AssetColor) -> UIColor {
        switch name {
        case .purple:
            return UIColor(red: 108/255, green: 70/255, blue: 232/255, alpha: 1)
        case .black:
            return UIColor(red: 0.208, green: 0.178, blue: 0.283, alpha: 1)
        case .placeholder:
            return UIColor(red: 0.827, green: 0.824, blue: 0.863, alpha: 1)
        case .defaultGray:
            return UIColor(red: 0.839, green: 0.82, blue: 0.91, alpha: 1)
        case .brandLight:
            return UIColor(named: AssetColor.brandLight.rawValue)!
        case .brandMedium:
            return UIColor(named: AssetColor.brandMedium.rawValue)!
        case .brandThick:
            return UIColor(named: AssetColor.brandThick.rawValue)!
        case .descriptionGeneral:
            return UIColor(named: AssetColor.descriptionGeneral.rawValue)!
        case .subTitleGeneral:
            return UIColor(named: AssetColor.subTitleGeneral.rawValue)!
        case .titleGeneral:
            return UIColor(named: AssetColor.titleGeneral.rawValue)!
            
        }
    }
}
