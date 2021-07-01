//
//  Chapter.swift
//  MangadexNotifier
//
//  Created by Gustavo Parreira on 15/06/2021.
//

import Foundation

struct FeedResponse: Decodable {
    var results: [ChapterResponse]
    var limit: Int
    var offset: Int
    var total: Int
}

struct ChapterResponse: Decodable {
    var mangaId: String {
        get throws {
            guard let mangaId = relationships?.first(where: { $0.type == .manga })?.id else {
                throw MangaError.noManga
            }
            
            return mangaId
        }
    }
    
    var result: Result
    var data: Chapter
    var relationships: [Relationship]?
}

struct Chapter: Identifiable, Decodable {
    static var previews: [Chapter] {
        get {
            [Chapter(id: "909ce891-fce9-4e58-b966-f3b649197dfc",
                     type: "chapter",
                     attributes: ChapterAttributes(title: "One Piece",
                                                   volume: nil,
                                                   chapter: nil,
                                                   translatedLanguage: "en",
                                                   hash: "",
                                                   data: [],
                                                   dataSaver: [],
                                                   uploader: "a95471f0-5149-4569-bd82-3327fd1fa36e",
                                                   version: 1,
                                                   createdAt: Date(),
                                                   updatedAt: Date(),
                                                   publishAt: Date())),
             Chapter(id: "700d439a-b3e2-47be-8528-2d8c5ceaf037",
                     type: "chapter",
                     attributes: ChapterAttributes(title: "One Piece",
                                                   volume: "Volume 1",
                                                   chapter: nil,
                                                   translatedLanguage: "en",
                                                   hash: "",
                                                   data: [],
                                                   dataSaver: [],
                                                   uploader: "4d91f378-8984-45b0-b839-3f21806e8daf",
                                                   version: 1,
                                                   createdAt: Date(),
                                                   updatedAt: Date(),
                                                   publishAt: Date())),
             Chapter(id: "7f7a03fc-4c8a-4d1f-9bcd-b62a7a04ab2b",
                     type: "chapter",
                     attributes: ChapterAttributes(title: "One Piece",
                                                   volume: nil,
                                                   chapter: "Chapter 1",
                                                   translatedLanguage: "en",
                                                   hash: "",
                                                   data: [],
                                                   dataSaver: [],
                                                   uploader: "2d3418bd-08be-4680-9a10-5bb310d94d3f",
                                                   version: 1,
                                                   createdAt: Date(),
                                                   updatedAt: Date(),
                                                   publishAt: Date())),
             Chapter(id: "53209c65-057d-46b4-b37e-dc339427382c",
                     type: "chapter",
                     attributes: ChapterAttributes(title: "One Piece",
                                                   volume: "Volume 1",
                                                   chapter: "Chapter 1",
                                                   translatedLanguage: "en",
                                                   hash: "",
                                                   data: [],
                                                   dataSaver: [],
                                                   uploader: "c369bead-cea6-4d8c-a3b5-1b7b8a508d1e",
                                                   version: 1,
                                                   createdAt: Date(),
                                                   updatedAt: Date(),
                                                   publishAt: Date()))]
        }
    }
    
    var id: String
    var type: String
    var attributes: ChapterAttributes
}

struct ChapterAttributes: Decodable {
    var title: String
    var volume: String?
    var chapter: String?
    var translatedLanguage: String
    var hash: String
    var data: [String]
    var dataSaver: [String]
    var uploader: String?
    var version: Int
    var createdAt: Date
    var updatedAt: Date
    var publishAt: Date
}
