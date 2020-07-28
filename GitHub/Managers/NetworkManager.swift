//
//  NetworkManager.swift
//  GitHub
//
//  Created by Vlad on 7/22/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = "https:/api.github.com/users/"
    let cache = NSCache<NSString, UIImage>()
       
    private init(){}
    
    func getFollower(for username: String, page: Int, completed: @escaping(Result<[Follower],GFError>) -> Void) {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url,completionHandler: { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let followers = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            } catch {
                completed(.failure(.invalidData))
            }
        })
        
        task.resume()
    }
    
    func getUserInfo(for username: String, completed: @escaping(Result<User,GFError>) -> Void) {
           let endpoint = baseURL + "\(username)"
           
           guard let url = URL(string: endpoint) else {
               completed(.failure(.invalidUsername))
               return
           }
           
           let task = URLSession.shared.dataTask(with: url,completionHandler: { data, response, error in
               if let _ = error {
                   completed(.failure(.unableToComplete))
                   return
               }
               
               guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                   completed(.failure(.invalidResponse))
                   return
               }
               
               guard let data = data else {
                   completed(.failure(.invalidData))
                   return
               }
               
               do{
                   let decoder = JSONDecoder()
                   decoder.keyDecodingStrategy = .convertFromSnakeCase
                   
                   let user = try decoder.decode(User.self, from: data)
                   completed(.success(user))
               } catch {
                   completed(.failure(.invalidData))
               }
           })
           
           task.resume()
       }
    
    func downloadImage(url : String, completed: @escaping (UIImage?)->Void) {
        let cacheKey = NSString(string: url)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            guard error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completed(nil)
                    return }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
}
