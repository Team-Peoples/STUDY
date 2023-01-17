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
        
        let fineAttrString = NSAttributedString(string: Formatter.formatIntoDecimal(number: value) ?? "", attributes: [.font: UIFont.boldSystemFont(ofSize: valueFontSize), .foregroundColor: UIColor.appColor(valueTextColor)])
        
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
    convenience init(backgroundColor: UIColor, alpha: CGFloat = 1) {
        self.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
        self.alpha = alpha
        
    }
}

extension Int {
    func toString() -> String {
        return String(self)
    }
}

extension String {
    func checkOnlyNumbers() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[0-9]$", options: .caseInsensitive)
            
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) { return true }
        } catch {
            print(error.localizedDescription)
            
            return false
        }
        return false
    }
    
    func toInt() -> Int? {
        return Int(self)
    }
    
    func convertedEnglish() -> String {
        switch self {
        case "매일": return "everyDay"
        case "매주": return "everyWeek"
        case "2주 마다": return "everyTwoWeek"
        case "매달": return "everyMonth"
        default: return ""
        }
    }
}

extension UITableView {
    
    public func cellsForRows(at section: Int) -> [UITableViewCell] {
        let numberOfRows = self.numberOfRows(inSection: section)
        let indexPaths = (0...numberOfRows).map { IndexPath(row: $0, section: section)
        }
        /// indexPath에서 오류 발생시 nil 처리하여 cell을 반환하지 않는다.
        let cells = indexPaths.compactMap { indexPath in
            let cell = self.cellForRow(at: indexPath)
            return cell
        }
        
        return cells
    }
}

extension Calendar {
    
    static let shared = Self.current
    
    func weekday(_ weekday: Int?) -> String {
        switch weekday {
        case 1: return "일"
        case 2: return "월"
        case 3: return "화"
        case 4: return "수"
        case 5: return "목"
        case 6: return "금"
        case 7: return "토"
        default: return ""
        }
    }
}

extension Date {
    func convertToMinuteDateComponents() -> DateComponents {
        Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)

    func convertToDateComponents() -> DateComponents {
        Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .weekday], from: self)
    }
    
    func convertedToDateComponents(_ components: Set<Calendar.Component>) -> DateComponents {
        Calendar.current.dateComponents(components, from: self)
    }
    
    func convertToDayDateComponents() -> DateComponents {
        Calendar.current.dateComponents([.year, .month, .day], from: self)
    }
    
    func convertToDashedString() -> DashedDate {
        DateFormatter.dashedDateFormatter.string(from: self)
    }
    
    func convertToDottedString() -> DottedDate {
        DateFormatter.dottedDateFormatter.string(from: self)
    }
}

extension DateComponents {
    func convertToDate() -> Date? {
        Calendar.current.date(from: self)
    }
    
    func getAlldaysDateComponents() -> [DateComponents] {
        let calendar = Calendar.current
        let range = calendar.maximumRange(of: .day)!
        let yearComponents = self.year
        let monthComponents = self.month
    
        var days = [DateComponents]()
        for i in range {
            var dateComponents = DateComponents(year: yearComponents, month: monthComponents)
            dateComponents.day = i
            days.append(dateComponents)
        }
        return days
    }
}

extension UINavigationController {
    var backButtonImage: UIImage? {
        UIImage(named: "back")?.withAlignmentRectInsets(UIEdgeInsets(top: 0.0, left: -12.0, bottom: 0.0, right: 0.0))
    }
    
    func setBrandNavigation() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.topItem?.title = ""
        
        navigationBar.backIndicatorImage = backButtonImage
        navigationBar.backIndicatorTransitionMaskImage = backButtonImage
    }
}

extension URLRequest {
    func debug() {
        print("\(self.httpMethod ?? "") \(self.url)")
        let str = String(decoding: self.httpBody ?? Data(), as: UTF8.self)
        print("BODY \n \(str)")
        print("HEADERS \n \(self.allHTTPHeaderFields)")
    }
}
