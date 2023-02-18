//
//  Identifier.swift
//  STUDYA
//
//  Created by 서동운 on 2/18/23.
//

import UIKit

extension UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
}
