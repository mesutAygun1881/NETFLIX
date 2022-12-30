//
//  NetworkManager.swift
//  KisilerUygulamasi
//
//  Created by Mesut Aygün on 13.12.2022.
//

import Foundation


// MARK: 2--->> BURADA NETWORK ICIN GEREKLI FONKSIYONLAR GENERIC TYPE OLARAK TANIMLANDI URLSESSION and DATA TASK

class NetworkManager{
    
    static let shared = NetworkManager()
    
    
    // MARK: GET
    func request<T: Codable>(type : T.Type , url : String , method : HTTPMethods , completion : @escaping((Result<T, ErrorTypes>)->())){
        let session = URLSession.shared
        
        if let url = URL(string: url){
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
            
            let dataTask = session.dataTask(with: request) { data, response, error in
                if let _ = error {
                    completion(.failure(.generalError))
                }else if let data = data {
                    self.handleResponse(data: data) { response in
                        completion(response)
                        print("success")
                    }
                }else{
                    completion(.failure(.invalidUrl))
                }
            }
            dataTask.resume()
            
        }
            
    }
    
    
    // MARK: POST
    func requestPost<T: Codable>(type : T.Type , url : String , method : HTTPMethods ,param : String, completion : @escaping((Result<T, ErrorTypes>)->())){
        let session = URLSession.shared
        
        if let url = URL(string: url){
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            let postString = "kategori_id=\(param)"
            request.httpBody = postString.data(using: .utf8)
            
            let dataTask = session.dataTask(with: request) { data, response, error in
                if let _ = error {
                    completion(.failure(.generalError))
                }else if let data = data {
                    self.handleResponse(data: data) { response in
                        completion(response)
                        print("success")
                       
                    }
                }else{
                    completion(.failure(.invalidUrl))
                }
            }
            dataTask.resume()
            
        }
            
    }
    
    
    fileprivate func handleResponse<T: Codable>(data : Data , completion : @escaping((Result<T, ErrorTypes>)->())){
        do{
            let result = try JSONDecoder().decode(T.self, from: data)
            completion(.success(result))
        }catch{
            completion(.failure(.invalidData))
        }
    }
}
