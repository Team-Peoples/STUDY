//
//  HapticManager.swift
//  STUDYA
//
//  Created by 신동훈 on 2023/02/24.
//

import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    func hapticNotification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    // heavy, light, meduium, rigid, soft
    func hapticImpact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
