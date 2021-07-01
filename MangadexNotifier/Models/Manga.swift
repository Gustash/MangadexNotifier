//
//  Manga.swift
//  MangadexNotifier
//
//  Created by Gustavo Parreira on 15/06/2021.
//

import Foundation

struct MangaFeedResponse: Decodable {
    var results: [ChapterResponse]
    var limit: Int
    var offset: Int
    var total: Int
}

struct MangaList: Decodable {
    var results: [MangaResponse]
    var limit: Int
    var offset: Int
    var total: Int
}

struct MangaResponse: Decodable {
    var coverId: String {
        get throws {
            guard let coverId = relationships?.first(where: { $0.type == .cover_art })?.id else {
                throw MangaError.noCover
            }
            
            return coverId
        }
    }
    
    var result: Result
    var data: Manga
    var relationships: [Relationship]?
}

struct Manga: Decodable {
    static var preview: Manga {
        get {
            Manga(id: "25525f44-90dd-44ae-8457-d7b74b447156",
                  type: "manga",
                  attributes: MangaAttributes(title: ["en": "One Piece"],
                                              altTitles: [],
                                              description: ["en": "The great adventure!"],
                                              isLocked: false,
                                              links: [:],
                                              originalLanguage: "jp",
                                              lastVolume: nil,
                                              lastChapter: nil,
                                              publicationDemographic: nil,
                                              status: nil,
                                              year: nil,
                                              contentRating: nil,
                                              tags: [],
                                              version: 1,
                                              createdAt: Date(),
                                              updatedAt: Date()))
        }
    }
    
    var id: String
    var type: String
    var attributes: MangaAttributes
}

enum ContentRating: String, Decodable {
    case safe
    case suggestive
    case erotica
    case pornographic
}

enum MangaStatus: String, Decodable {
    case ongoing
    case completed
    case hiatus
    case cancelled
}

enum PublicationDemographic: String, Decodable {
    case shounen
    case shoujo
    case josei
    case seinen
}

struct MangaAttributes: Decodable {
    var title: LocalizedString
    var altTitles: [LocalizedString]
    var description: LocalizedString
    var isLocked: Bool! = false
    var links: Dictionary<String, String>
    var originalLanguage: String
    var lastVolume: String?
    var lastChapter: String?
    var publicationDemographic: PublicationDemographic?
    var status: MangaStatus?
    var year: Int?
    var contentRating: ContentRating?
    var tags: [Tag]
    var version: Int
    var createdAt: Date
    var updatedAt: Date
}

struct Tag: Decodable {
    var id: String
    var type: String
    var attributes: TagAttributes
}

struct TagAttributes: Decodable {
    var name: LocalizedString
    // FIXME: Check what the actual type should be for this
//    var description: [LocalizedString]
    var group: String
    var version: Int
}
