//
//  Cover.swift
//  MangadexNotifier
//
//  Created by Gustavo Parreira on 16/06/2021.
//

import Foundation

struct CoverArtList: Decodable {
    var results: [CoverResponse]
    var limit: Int
    var offset: Int
    var total: Int
}

struct CoverResponse: Decodable {
    var result: String
    var data: Cover
    var relationships: [Relationship]
}

struct Cover: Decodable {
    static var preview: Cover {
        get {
            Cover(id: "3af671f8-e107-4f07-849a-f0ad1df3e80a",
                  type: "cover_art",
                  attributes: CoverAttributes(volume: nil,
                                              fileName: "8de5c4b3-f70a-47a2-a621-ce9b349ab591.jpg",
                                              description: nil,
                                              version: 1,
                                              createdAt: Date(),
                                              updatedAt: Date()))
        }
    }
    
    var id: String
    var type: String
    var attributes: CoverAttributes
    
    enum CoverQuality: String {
        case source = ""
        case large = ".512.jpg"
        case small = ".256.jpg"
    }
    
    func url(mangaId: String, quality: CoverQuality = .small) -> URL? {
        URL(string: "https://uploads.mangadex.org/covers/\(mangaId)/\(attributes.fileName)\(quality.rawValue)")
    }
}

struct CoverAttributes: Decodable {
    var volume: String?
    var fileName: String
    var description: String?
    var version: Int
    var createdAt: Date
    var updatedAt: Date
}
