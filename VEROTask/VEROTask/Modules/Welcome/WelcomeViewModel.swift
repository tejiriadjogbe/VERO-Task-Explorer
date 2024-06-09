//
//  WelcomeViewModel.swift
//  VEROTask
//
//  Created by Adjogbe  Tejiri on 09/06/2024.
//

import Foundation
import Combine
import Network

class WelcomeViewModel {
    var service = BauBuddyServiceImpl()
    
    enum Input {
        case login
    }
    
    enum Output {
        case loginFailed(ErrorResponse)
        case loginSuccess
    }
    
    var output = PassthroughSubject<Output, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    func transform(input: PassthroughSubject<Input, Never>) {
        let cancellable = input.sink { [weak self] event in
            switch event {
            case .login:
                self?.login()
            }
        }
        cancellable.store(in: &cancellables)
    }
    
    func login() {
        let data = LoginRequest(username: "365", password: "1")
        service.login(data: data) {[weak self] result in
            switch result {
            case .success(let data):
                guard let token = data.oauth?.access_token else {
                    self?.output.send(.loginFailed(ErrorResponse(message: "Error Login in")))
                    return
                }
                AppStorage.token = "Bearer \(token)"
                self?.output.send(.loginSuccess)
            case .failure(let error):
                self?.output.send(.loginFailed(error))
            }
        }
    }
}
