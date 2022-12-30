//
//  KisilerViewModel.swift
//  KisilerUygulamasi
//
//  Created by Mesut Aygün on 14.12.2022.
//

import Foundation

// MARK: 4--->> REQUEST CAGIRILIR SONUC CONTROLLERDA KULLANILACAK ARRAY ICERISINE AKTARILIR

class FilmlerViewModel {
    var postId = 0
    var kategoriItems = [Kategoriler]()
    var filmlerTrendingItems = [Filmler]()
    var filmlerTvSeriesItems = [Filmler]()
    var filmlerUpcomingItems = [Filmler]()
    var filmlerPopularItems = [Filmler]()
    var filmlerTopRatedItems = [Filmler]()
    var filmlerDiscoverItems = [Filmler]()
    var filmlerSearchResultItems = [Filmler]()
    var filmlerYoutubeItems = [VideoElement]()
    func getTrendingFilmlerItems(complete : @escaping((String?)->())){
        FilmlerManager.shared.getTrendingFilmler { items, error in
            if let items = items {
                self.filmlerTrendingItems = items
            
            }
            complete(error)
        }
    }
    func getTvSeriesFilmlerItems(complete : @escaping((String?)->())){
        FilmlerManager.shared.getTvSeriesFilmler { items, error in
            if let items = items {
                self.filmlerTvSeriesItems = items
            
            }
            complete(error)
        }
    }

    func getUpcomingFilmlerItems(pagination : Int , complete : @escaping((String?)->())){
        FilmlerManager.shared.getUpcomingFilmler(pagination: pagination) { items, error in
            if let items = items {
                self.filmlerUpcomingItems = items
            
            }
            complete(error)
        }
    }
    
    func getPopularFilmlerItems(complete : @escaping((String?)->())){
        FilmlerManager.shared.getPopularFilmler { items, error in
            if let items = items {
                self.filmlerPopularItems = items
            
            }
            complete(error)
        }
    }
    
    func getTopRatedFilmlerItems(complete : @escaping((String?)->())){
        FilmlerManager.shared.getTopRatedFilmler { items, error in
            if let items = items {
                self.filmlerTopRatedItems = items
            
            }
            complete(error)
        }
    }
    
    func getDiscoverFilmlerItems(complete : @escaping((String?)->())){
        FilmlerManager.shared.getDiscoverFilmler { items, error in
            if let items = items {
                self.filmlerDiscoverItems = items
            
            }
            complete(error)
        }
    }
    
    func getSearchResultItems(with query : String , complete : @escaping((String?)->())){
        FilmlerManager.shared.getSearchResultFilmler(with: query) { items, error in
            if let items = items {
                
                self.filmlerSearchResultItems = items
            
            }
            complete(error)
        }
    }
    
    func getYoutubeItems(with query : String , complete : @escaping((String?)->())){
        FilmlerManager.shared.getSearcYoutube(with: query ) { items, error in
            if let items = items {
                
                self.filmlerYoutubeItems = [items]
            print("itemsss \(self.filmlerYoutubeItems)")
            }
            complete(error)
        }
    }

    
   /*
    func postFilmlerItems(param : String ,complete : @escaping((String?)->())){
        FilmlerManager.shared.postFilmler(param: param) { items, error in
            if let items = items {
              self.filmlerItems = items
                print("success post islem--\(param)")
            }
            print("success post islem--\(param)")
            complete(error)
           
        }
        
    }
    */
    
}
