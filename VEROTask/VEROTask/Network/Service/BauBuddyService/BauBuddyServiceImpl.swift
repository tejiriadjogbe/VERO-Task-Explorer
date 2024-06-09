//
//  BauBuddyServiceImpl.swift
//  VEROTask
//
//  Created by Adjogbe  Tejiri on 09/06/2024.
//

import Foundation

class BauBuddyServiceImpl: BauBuddyService {
    let requester = HTTPClient.shared
    
    func login(data: LoginRequest, completion: @escaping (Result<LoginResponse, ErrorResponse>) -> Void) {
        requester.fetchData(url: "https://api.baubuddy.de/index.php/login", data: data, method: .post) {
            completion($0)
        }
    }
    
    func getTasks(completion: @escaping (Result<[TaskResponse], ErrorResponse>) -> Void) {
        requester.fetchData(url: "https://api.baubuddy.de/dev/index.php/v1/tasks/select", type: .bearer) {
            completion($0)
        }
    }
}
