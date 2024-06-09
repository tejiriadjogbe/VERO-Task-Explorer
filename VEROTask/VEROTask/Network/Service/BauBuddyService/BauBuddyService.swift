//
//  BauBuddyService.swift
//  VEROTask
//
//  Created by Adjogbe  Tejiri on 09/06/2024.
//

import Foundation

protocol BauBuddyService {
    func login(data: LoginRequest, completion: @escaping (Result<LoginResponse, ErrorResponse>) -> Void)
    func getTasks(completion: @escaping (Result<[TaskResponse], ErrorResponse>) -> Void)
}
