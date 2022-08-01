//
//  Color.swift
//  Untitled-Study
//
//  Created by 신동훈 on 2022/07/31.
//

import UIKit

enum AssetColor {
    case purple
}

extension UIColor {
    
    static func appColor(_ name: AssetColor) -> UIColor {
        switch name {
        case .purple:
            return UIColor(red: 108/255, green: 70/255, blue: 232/255, alpha: 1)
        }
    }
}
