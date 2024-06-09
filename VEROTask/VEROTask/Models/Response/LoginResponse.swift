//
//  LoginResponse.swift
//  VEROTask
//
//  Created by Adjogbe  Tejiri on 09/06/2024.
//

import Foundation

public struct LoginResponse: Codable {
    public var oauth: LoginOauth?
}

public struct LoginOauth: Codable {
    public var access_token: String?
    public var expires_in: Int?
    public var token_type: String?
    public var refresh_token: String?
    public var scope: String?
}
