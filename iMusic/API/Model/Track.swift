//
//  Track.swift
//  iMusic
//
//  Created by Тимур Мусаханов on 18.01.2021.
//

import Foundation

struct Track: Decodable {
    var results: [TrackData]?
}

struct TrackData: Decodable {
    var trackName: String?
}
