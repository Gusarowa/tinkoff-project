//
//  AuthorizationService.swift
//  TinkoffProject
//
//  Created by Лена Гусарова on 01.04.2023.
//

import Foundation
import Combine

enum AuthorizationError: Error {
    case wrongLoginOrPassword
    
}

protocol AuthorizationService {
    var isAuthorized: AnyPublisher<Bool, Never> { get }
    func signIn(login: String, password: String) async throws
    func signOut()
}
