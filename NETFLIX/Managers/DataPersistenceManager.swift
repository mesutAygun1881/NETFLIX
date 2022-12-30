//
//  DataPersistenceManager.swift
//  NETFLIX
//
//  Created by Mesut Aygün on 28.12.2022.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    
    static let shared = DataPersistenceManager()
    
     
    // MARK: DOWNLOAD FILM  1
    func downloadFilmManager(model : Filmler , completion : @escaping (Result<Void , Error>)-> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let filmItem = FilmItem(context: context)
        filmItem.original_title = model.original_title
        filmItem.overview = model.overview
        filmItem.original_name = model.original_name
        filmItem.poster_path = model.poster_path
        filmItem.id = Int64(model.id)
        filmItem.vote_count = Int64(model.vote_count)
        filmItem.media_type = model.media_type
        
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            print(error.localizedDescription)
            completion(.failure(DataBaseError.failedToSaveDownload))
        }
        
    }
    
    
    // MARK: Download Favorites FILM  1
    func downloadFavoritesFilmManager(model : Filmler , completion : @escaping (Result<Void , Error>)-> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let favoritesFilm = FavoritesFilm(context : context)
        favoritesFilm.original_title = model.original_title
        favoritesFilm.overview = model.overview
        favoritesFilm.original_name = model.original_name
        favoritesFilm.poster_path = model.poster_path
        favoritesFilm.id = Int64(model.id)
        favoritesFilm.vote_count = Int64(model.vote_count)
        favoritesFilm.media_type = model.media_type
        
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            print(error.localizedDescription)
            completion(.failure(DataBaseError.failedToSaveDownload))
        }
        
    }
    
    
    // MARK: FETCH FILM 2
    func fetchFilmManager(completion : @escaping (Result<[FilmItem] , Error>)-> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request : NSFetchRequest<FilmItem>
        request = FilmItem.fetchRequest()
        
        do{
            let films = try context.fetch(request)
            completion(.success(films))
        }catch{
            completion(.failure(DataBaseError.failedToSaveFetch))
        }
    }
    // MARK: FETCH FILM 2
    func fetchFavoritesFilmManager(completion : @escaping (Result<[FavoritesFilm] , Error>)-> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request : NSFetchRequest<FavoritesFilm>
        request = FavoritesFilm.fetchRequest()
        
        do{
            let films = try context.fetch(request)
            completion(.success(films))
        }catch{
            completion(.failure(DataBaseError.failedToSaveFetch))
        }
    }
    
    // MARK: DELETE FILM 3
    func deleteFilmManager(model : FilmItem , completion : @escaping (Result<Void , Error>)-> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DataBaseError.failedToSaveDelete))
        }
    }
    // MARK: DELETE Favorites FILM 3
    func deleteFavoriteFilmManager(model : FavoritesFilm , completion : @escaping (Result<Void , Error>)-> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DataBaseError.failedToSaveDelete))
        }
    }

    
    
    enum DataBaseError : Error {
        case failedToSaveDownload
        case failedToSaveFetch
        case failedToSaveDelete
    }
}
