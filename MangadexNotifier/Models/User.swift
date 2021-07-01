//
//  User.swift
//  MangadexNotifier
//
//  Created by Gustavo Parreira on 15/06/2021.
//

import Foundation

struct UserResponse: Decodable {
    var result: Result
    var data: User
}

struct User: Decodable {
    var id: String
    var type: String
    var attributes: UserAttributes
}

struct UserAttributes: Decodable {
    var username: String
    var version: Int
}
