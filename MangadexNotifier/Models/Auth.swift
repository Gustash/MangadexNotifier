//
//  Auth.swift
//  MangadexNotifier
//
//  Created by Gustavo Parreira on 15/06/2021.
//

import Foundation

struct LoginData: Encodable {
    var username: String = ""
    var password: String = ""
}

struct RefreshData: Encodable {
    var token: String
}

struct AuthResponse: Decodable {
    var result: Result
    var token: AuthToken?
    var errors: [MangadexError]?
    var message: String?
}

struct AuthToken: Decodable {
    var session: String
    var refresh: String
}
