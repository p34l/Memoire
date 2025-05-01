//
//  IMDbService.swift
//  Memoire
//
//  Created by Misha Kandaurov on 20.04.2025.
//

import Foundation
import SwiftUI
import CoreData

struct IMDbService {
    
    static func fetchIMDBData(for title: String, completion: @escaping ([IMDbSearchItem]) -> Void) {
        var urlComponents = URLComponents(string: "https://www.omdbapi.com/")
        urlComponents?.queryItems = [
            URLQueryItem(name: "s", value: title),
            URLQueryItem(name: "apikey", value: "8b7dbf4")
        ]
        
        guard let url = urlComponents?.url else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let e = error {
                print(e)
                completion([])
                return
            }
            
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(IMDbSearchResponse.self, from: data)
                completion(decodedResponse.search)
            } catch {
                completion([])
                print("Decoding failed \(error) with response string: \(String(describing: String(data: data, encoding: .utf8)))")
            }
        }.resume()
    }
    
    static func fetchMovieDetails(imdbID: String, completion: @escaping (IMDbResponse?) -> Void) {
        let apiKey = "8b7dbf4"
        let urlString = "https://www.omdbapi.com/?i=\(imdbID)&apikey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error)
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(IMDbResponse.self, from: data)
                completion(decodedResponse)
            } catch {
                completion(nil)
            }
        }.resume()
    }

    
    static func handleFetchedData(
        title: String,
        ratingString: String?,
        posterURL: String?,
        genre: String?,
        type: String?,
        plot: String?,
        dataManager: ListItemDataManager,
        dismiss: DismissAction,
        viewContext: NSManagedObjectContext
    ) {
        DispatchQueue.main.async {
            let ratingValue = String(format: "%.1f", Double(ratingString ?? "") ?? 0.0)
                        
            dataManager.addItem(
                title: title,
                rating: ratingValue,
                posterURL: posterURL,
                genre: genre,
                type: type,
                plot: plot
            )
            dismiss()
        }
    }
}
