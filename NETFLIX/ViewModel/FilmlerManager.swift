//
//  KisilerManager.swift
//  KisilerUygulamasi
//
//  Created by Mesut Aygün on 14.12.2022.
//

import Foundation


// MARK: 3--->> BURADA NETWORK DA TANIMLANAN REQUEST ISTEKLERI YAPILIR GELEN CEVAP ITEMS A AKTARILIR

class FilmlerManager {
    
    static let shared = FilmlerManager()
    
    func getTrendingFilmler(complete : @escaping(([Filmler]? , String?)->())){
        
        
        let url = "\(NetworkHelper.shared.baseUrlTrending)"
        print(url)
        NetworkManager.shared.request(type: FilmCevap.self, url: url, method: .get) { response in
            switch response {
            case .success(let items):
                complete(items.results , nil)
                
            case .failure(let error):
                complete(nil , error.rawValue)
            }
        }
    }
    
    func getTvSeriesFilmler(complete : @escaping(([Filmler]? , String?)->())){
        
        
        let url = "\(NetworkHelper.shared.baseUrlTvSeries)"
        print(url)
        NetworkManager.shared.request(type: FilmCevap.self, url: url, method: .get) { response in
            switch response {
            case .success(let items):
                complete(items.results , nil)
                
            case .failure(let error):
                complete(nil , error.rawValue)
            }
        }
    }
    func getUpcomingFilmler(pagination : Int ,complete : @escaping(([Filmler]? , String?)->())){
        
        
        let url = "\(NetworkHelper.shared.baseUrlUpcomingSeries + "\(pagination)")"
        print(url)
        NetworkManager.shared.request(type: FilmCevap.self, url: url, method: .get) { response in
            switch response {
            case .success(let items):
                complete(items.results , nil)
                
            case .failure(let error):
                complete(nil , error.rawValue)
            }
        }
    }
    
    func getPopularFilmler(complete : @escaping(([Filmler]? , String?)->())){
        
        
        let url = "\(NetworkHelper.shared.baseUrlPopularSeries)"
        print(url)
        NetworkManager.shared.request(type: FilmCevap.self, url: url, method: .get) { response in
            switch response {
            case .success(let items):
                complete(items.results , nil)
                
            case .failure(let error):
                complete(nil , error.rawValue)
            }
        }
    }

    
    func getTopRatedFilmler(complete : @escaping(([Filmler]? , String?)->())){
        
        
        let url = "\(NetworkHelper.shared.baseUrlTopRatedSeries)"
        print(url)
        NetworkManager.shared.request(type: FilmCevap.self, url: url, method: .get) { response in
            switch response {
            case .success(let items):
                complete(items.results , nil)
                
            case .failure(let error):
                complete(nil , error.rawValue)
            }
        }
    }
    
    func getDiscoverFilmler(complete : @escaping(([Filmler]? , String?)->())){
        
        
        let url = "\(NetworkHelper.shared.baseUrlDiscover)"
        print(url)
        NetworkManager.shared.request(type: FilmCevap.self, url: url, method: .get) { response in
            switch response {
            case .success(let items):
                complete(items.results , nil)
                
            case .failure(let error):
                complete(nil , error.rawValue)
            }
        }
    }
    
    func getSearchResultFilmler(with query : String , complete : @escaping(([Filmler]? , String?)->())){
        
        guard let querys = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        let url = "\(NetworkHelper.shared.baseUrlSearchWithQuery + querys)"
        print("ssssss-> \(url)")
        NetworkManager.shared.request(type: FilmCevap.self, url: url, method: .get) { response in
            switch response {
            case .success(let items):
                complete(items.results , nil)
                
            case .failure(let error):
                complete(nil , error.rawValue)
            }
        }
    }
    
  
    func getSearcYoutube(with query : String , complete : @escaping((VideoElement? , String?)->())){
        
        guard let querys = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        let url = "\(NetworkHelper.shared.baseUrlYoutube)q=\(querys)&key=\(NetworkHelper.shared.youtube_API_KEY)"
        print("ssssss-> \(url)")
        NetworkManager.shared.request(type: YoutubeSearchResult.self, url: url, method: .get) { response in
            switch response {
            case .success(let items):
                complete(items.items.first , nil)
                
            case .failure(let error):
                complete(nil , error.rawValue)
            }
        }
    }

    
    /*
    func postFilmler(param : String ,complete : @escaping(([Filmler]? , String?)->())){
        
        
        let url = "\(NetworkHelper.shared.baseUrl)filmler_by_kategori_id.php"
        print(url)
        NetworkManager.shared.requestPost(type: FilmCevap.self, url: url, method: .post, param: param) { response in
            switch response {
            case .success(let items):
                complete(items.filmler , nil)
                print("urlsss - \(url)")
                print("param - \(param)")
            case .failure(let error):
                print("param - \(param)")
                complete(nil , error.rawValue)
            }
        }
    }
    */
    
     
}
