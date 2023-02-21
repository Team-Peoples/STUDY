//
//  TokenAuthenticator.swift
//  STUDYA
//
//  Created by 서동운 on 12/25/22.
//

import Foundation
import Alamofire

struct TokenAuthenticationCredential: AuthenticationCredential {
    var requiresRefresh: Bool = false
    
    let accessToken: String
    let refreshToken: String
}

class TokenAuthenticator: Authenticator {
    
    typealias Credential = TokenAuthenticationCredential
    
    func apply(_ credential: Credential, to urlRequest: inout URLRequest) {
       
        urlRequest.headers.add(.bearerAccessToken(credential.accessToken))
        urlRequest.headers.add(.bearerRefreshToken(credential.refreshToken))
    }
    
    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: Credential) -> Bool {
       
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
            case .success:
                let accessToken = KeyChain.read(key: Constant.accessToken) ?? ""
                let refreshToken = KeyChain.read(key: Constant.refreshToken) ?? ""
                print("리프레시 성공 후 api 재요청 시작","🔥")
                completion(.success(TokenAuthenticationCredential(accessToken: accessToken, refreshToken: refreshToken)))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}

extension AuthenticationInterceptor<TokenAuthenticator> {
    
    convenience init() {
        let authenticator = TokenAuthenticator()
        let credential = TokenAuthenticationCredential(accessToken: KeyChain.read(key: Constant.accessToken) ?? "", refreshToken: KeyChain.read(key: Constant.refreshToken) ?? "")
        
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