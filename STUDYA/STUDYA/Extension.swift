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

extension AttributedString {
    static func custom(frontLabel: String, labelFontSize: CGFloat, labelColor: AssetColor = .ppsBlack, value: Int, valueFontSize: CGFloat, valueTextColor: AssetColor = .keyColor1, withCurrency: Bool = false) -> NSAttributedString {
        
        let mutableAttributedText: NSMutableAttributedString = NSMutableAttributedString(string: frontLabel, attributes: [.font: UIFont.systemFont(ofSize: labelFontSize), .foregroundColor: UIColor.appColor(labelColor)])
        
        let fineAttrString = NSAttributedString(string: Formatter.formatIntoDecimal(number: value), attributes: [.font: UIFont.boldSystemFont(ofSize: valueFontSize), .foregroundColor: UIColor.appColor(valueTextColor)])
        
        mutableAttributedText.append(fineAttrString)
        
        if withCurrency {
            let wonAttrString = NSAttributedString(string: " 원", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.appColor(.ppsGray1)])
            mutableAttributedText.append(wonAttrString)
        }
        
        return mutableAttributedText
    }
    
    static func custom(image: UIImage, text: String) -> NSAttributedString {
        let resizedImage = image.resize(newWidth: 20)
        let attachment = NSTextAttachment(image: resizedImage)
        let mutableAttributedText: NSMutableAttributedString = NSMutableAttributedString(attachment: attachment)
        
        let fineAttrString = NSAttributedString(string: text, attributes: [.font: UIFont.boldSystemFont(ofSize: 19), .foregroundColor: UIColor.appColor(.ppsBlack)])
        
        mutableAttributedText.append(fineAttrString)
        
        return mutableAttributedText
    }
}

extension UIImage {
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
//        print("화면 배율: \(UIScreen.main.scale)")// 배수
//        print("origin: \(self), resize: \(renderImage)")
        return renderImage
    }
}

extension UIView {
    func addDashedBorder(color: UIColor, cornerRadius: CGFloat?) {
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: cornerRadius ?? 0).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}

extension UIView {
    convenience init(backgroundColor: UIColor) {
        self.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
    }
}
