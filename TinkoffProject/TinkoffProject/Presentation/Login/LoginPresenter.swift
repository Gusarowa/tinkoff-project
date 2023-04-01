//
//  LoginPresenter.swift
//  TinkoffProject
//
//  Created by Лена Гусарова on 01.04.2023.
//

import UIKit

class LoginPresenter {
    var authorizationService: AuthorizationService = MockAuthorizationService.shared
    
    weak var view: LoginViewController?
    
    @MainActor
    func logIn(login: String, password: String) {
        view?.showLoader()
        Task {
            do {
                try await authorizationService.signIn(login: login, password: password)
                 view?.hideLoader()
            } catch {
                self.view?.show(error: error)
                self.view?.hideLoader()
            }
        }
    }
}
