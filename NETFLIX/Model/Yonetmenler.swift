//
//  Yonetmenler.swift
//  FilmApp
//
//  Created by Mesut Aygün on 15.12.2022.
//

import Foundation


class Yonetmenler : Codable {
    
    var yonetmen_id : String?
    var yonetmen_ad : String?
    
    init(yonetmen_id : String , yonetmen_ad : String){
        self.yonetmen_ad = yonetmen_ad
        self.yonetmen_id = yonetmen_id 
    }
}
