//
//  YoutubeModel.swift
//  NETFLIX
//
//  Created by Mesut Aygün on 27.12.2022.
//

import Foundation


struct YoutubeSearchResult : Codable {
    let items : [VideoElement]
}

struct VideoElement : Codable {
    let id : IdVideoElement
}

struct IdVideoElement : Codable {
    let kind : String
    let videoId : String
}
