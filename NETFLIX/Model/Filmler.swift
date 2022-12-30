//
//  Filmler.swift
//  FilmApp
//
//  Created by Mesut Aygün on 13.12.2022.
//

import Foundation

class FilmCevap : Codable {
  
    let results: [Filmler]
   
    
   
}
class Filmler : Codable {
    let id: Int
     let media_type: String?
     let original_name: String?
     let original_title: String?
     let poster_path: String?
     let overview: String?
     let vote_count: Int
     let release_date: String?
     let vote_average: Double
}


