//
//  AuthenticationViewModel.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/01.
//

import UIKit

protocol formViewModel {
    func formUpdate()
}

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
    var backgroundColor: UIColor { get }
    var titleColor: UIColor { get }
}

struct LoginViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var backgroundColor: UIColor {
        return formIsValid ? UIColor.appColor(.purple) : .white
    }
    
    var titleColor: UIColor {
        return formIsValid ? .white : UIColor.appColor(.purple)
    }
}

//struct RegistrationViewModel: AuthenticationViewModel {
//    var formIsValid: Bool {
//        return email?.isEmpty == false &&
//                password?.isEmpty == false &&
//                fullname?.isEmpty == false &&
//                username?.isEmpty == false
//
//    }
//
//    var backgroundColor: UIColor {
//        return formIsValid ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
//    }
//
//    var titleColor: UIColor {
//        return formIsValid ? .white : .white.withAlphaComponent(0.6)
//    }
//
//    var email: String?
//    var password: String?
//    var fullname: String?
//    var username: String?
//}

