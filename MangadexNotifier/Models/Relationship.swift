//
//  Relationship.swift
//  MangadexNotifier
//
//  Created by Gustavo Parreira on 16/06/2021.
//

import Foundation

enum RelationshipType: String, Decodable {
    case manga
    case chapter
    case cover_art
    case author
    case artist
    case scanlation_group
    case tag
    case user
    case custom_list
}

struct Relationship: Decodable {
    var id: String
    var type: RelationshipType
}
