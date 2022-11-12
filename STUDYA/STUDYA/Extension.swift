//
//  Extension.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/10/23.
//

import UIKit

extension CALayer {
    func applySketchShadow(
        color: UIColor,
        alpha: Float,
        x: CGFloat,
        y: CGFloat,
        blur: CGFloat,
        spread: CGFloat
    ) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / UIScreen.main.scale
        if spread == 0 {
            shadowPath = nil
        } else {
            let rect = bounds.insetBy(dx: -spread, dy: -spread)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
