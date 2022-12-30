//
//  NetworkHelper.swift
//  KisilerUygulamasi
//
//  Created by Mesut Aygün on 13.12.2022.
//

import Foundation
import UIKit

// MARK: 1--->> BURADA NETWORK ICIN GEREKLI OLAN YARDIMCI ELEMANLAR TANIMLANDI

enum HTTPMethods : String {
    case get = "GET"
    case post = "POST"
}




enum ErrorTypes : String , Error {
    case invalidData = "Invalid Data"
    case invalidUrl = "Invalid URL"
    case generalError = "An error happened"
}

class NetworkHelper {
    static let shared = NetworkHelper()
    
    let baseUrlTrending = "https://api.themoviedb.org/3/trending/movie/day?api_key=694aa3177ab6b128445b9b97f0b270e1"
    let baseUrlTvSeries = "https://api.themoviedb.org/3/trending/tv/day?api_key=694aa3177ab6b128445b9b97f0b270e1"
    let baseUrlUpcomingSeries = "https://api.themoviedb.org/3/movie/upcoming?api_key=694aa3177ab6b128445b9b97f0b270e1&language=en-US&page="
    let baseUrlPopularSeries = "https://api.themoviedb.org/3/movie/popular?api_key=694aa3177ab6b128445b9b97f0b270e1&language=en-US&page=1"
    let baseUrlTopRatedSeries = "https://api.themoviedb.org/3/movie/top_rated?api_key=694aa3177ab6b128445b9b97f0b270e1&language=en-US&page=1"
    let baseUrlDiscover = "https://api.themoviedb.org/3/discover/movie?api_key=694aa3177ab6b128445b9b97f0b270e1&language=en-US&sort_by=popularity.desc&include_adult=true&include_video=false&page=1&with_watch_monetization_types=flatrate"
    
    let baseUrlSearchWithQuery = "https://api.themoviedb.org/3/search/movie?api_key=694aa3177ab6b128445b9b97f0b270e1&query="
    let baseUrlYoutube = "https://youtube.googleapis.com/youtube/v3/search?"
    /*
    let baseUrlYouTubeWithQuery = "https://youtube.googleapis.com/youtube/v3/search?q=harry%20potter&key=AIzaSyAwurtNDmu2BoanC-rsHGo9yNQq8oha-H8"
    */
    let api_key = "694aa3177ab6b128445b9b97f0b270e1"
    let header = ["Auth" : "Bearer"]
    
    let youtube_API_KEY = "AIzaSyDZcW_qTYfjRUewXOmE4Jtgrs4-mlq3ixg"
    
    func saveToken(token : String){
        
    }
    
  
}



// MARK: QUERIE EXTENSION

extension URL {
    func withQueries(_ queries : [String : String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map {URLQueryItem(name: $0.0, value: $0.1)}
        return components?.url
    }
}
