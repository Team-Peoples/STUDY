//
//  TokenAuthenticator.swift
//  STUDYA
//
//  Created by EHDOMB on 12/25/22.
//

import Foundation
import Alamofire

struct TokenAuthenticationCredential: AuthenticationCredential {
    let accessToken: String
    let refreshToken: String
    let expiredAt: Date

    // refresh가 필요하다고 true를 리턴 (false를 리턴하면 refresh 필요x)
    var requiresRefresh: Bool { return false }
}

class TokenAuthenticator: Authenticator {
    
    typealias Credential = TokenAuthenticationCredential
    
    func apply(_ credential: Credential, to urlRequest: inout URLRequest) {
        print(#function)
        urlRequest.headers.add(.bearerAccessToken(credential.accessToken))
        urlRequest.headers.add(.bearerRefreshToken(credential.refreshToken))
    }
    
    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: Credential) -> Bool {
        print(#function)
        let bearerAccessToken = HTTPHeader.bearerAccessToken(credential.accessToken).value
        let bearerRefreshToken = HTTPHeader.bearerRefreshToken(credential.refreshToken).value
        return urlRequest.headers["AccessToken"] == bearerAccessToken && urlRequest.headers["RefreshToken"] == bearerRefreshToken
    }
    
    func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: Error) -> Bool {
        return response.statusCode == 403
    }
    
    func refresh(_ credential: Credential, for session: Alamofire.Session, completion: @escaping (Result<Credential, Error>) -> Void) {
        print("토큰 리프레시 요청")
        Network.shared.refreshToken { result in
            switch result {
            case .success(_):
                completion(.success(credential))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}

extension AuthenticationInterceptor<TokenAuthenticator> {
    
    convenience init() {
        let authenticator = TokenAuthenticator()
        let credential = TokenAuthenticationCredential(accessToken: KeyChain.read(key: Const.accessToken) ?? "", refreshToken: KeyChain.read(key: Const.refreshToken) ?? "", expiredAt: Date(timeIntervalSinceNow: 60 * 120))
        
        self.init(authenticator: authenticator, credential: credential)
    }
}

// MARK: - Helpers

extension HTTPHeader {
    
    public static func bearerAccessToken(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "AccessToken", value: "Bearer \(value)")
    }
    
    public static func bearerRefreshToken(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "RefreshToken", value: "Bearer \(value)")
    }
}
