//
//  CustomColor.swift
//  Untitled-Study
//
//  Created by 서동운 on 2022/08/01.
//

import UIKit

enum CustomColor {
    case purple
    case black
    case placeholder
    case defaultGray
}

extension CustomColor {
    var color: UIColor {
        switch self {
            case .purple:
                return UIColor(red: 0.424, green: 0.275, blue: 0.91, alpha: 1)
            case .black:
                return UIColor(red: 0.208, green: 0.178, blue: 0.283, alpha: 1)
            case .placeholder:
                return UIColor(red: 0.827, green: 0.824, blue: 0.863, alpha: 1)
            case .defaultGray:
                return UIColor(red: 0.839, green: 0.82, blue: 0.91, alpha: 1)
        }
    }
}
