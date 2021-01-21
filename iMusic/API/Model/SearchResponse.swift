//
//  SearchResponse.swift
//  iMusic
//
//  Created by Тимур Мусаханов on 16.01.2021.
//

import Foundation

struct SearchResponse: Decodable {
    var results: [Album]?
}

struct Album: Codable {
    var collectionId: Int?
    var artistName: String?
    var collectionName: String?
    var artworkUrl100: String?
    var releaseDate: String?
    var primaryGenreName: String?
}
