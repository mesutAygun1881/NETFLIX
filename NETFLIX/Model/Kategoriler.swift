//
//  Kategoriler.swift
//  FilmApp
//
//  Created by Mesut Aygün on 13.12.2022.
//

import Foundation

class KategoriCevap : Codable {
    var kategoriler : [Kategoriler]?
}

class Kategoriler : Codable {
    var kategori_id : String?
    var kategori_ad : String?
    
    init(kategori_id: String? = nil, kategori_ad: String? = nil) {
        self.kategori_id = kategori_id
        self.kategori_ad = kategori_ad
    }
}


