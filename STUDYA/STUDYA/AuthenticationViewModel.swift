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
}

struct LoginViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
}
