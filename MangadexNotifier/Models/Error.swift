//
//  Error.swift
//  MangadexNotifier
//
//  Created by Gustavo Parreira on 15/06/2021.
//

import Foundation

enum MangaError: Error {
    case noCover
    case noManga
}

struct MangadexError: Identifiable, Decodable {
    static var preview: MangadexError {
        get {
            MangadexError(id: "1",
                          status: 404,
                          title: "Not Found",
                          detail: "404 - Not Found")
        }
    }
    
    var id: String
    var status: Int
    var title: String
    var detail: String
}
