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
    
    static func fetchIMDBData(for title: String, completion: @escaping (String?, String?, String?, String?, String?) -> Void) {
        let apiKey = "8b7dbf4"
        let formattedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? title
        let urlString = "https://www.omdbapi.com/?t=\(formattedTitle)&apikey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(nil, nil, nil, nil, nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard
                let data = data,
                let decoded = try? JSONDecoder().decode(IMDbResponse.self, from: data)
            else {
                completion(nil, nil, nil, nil, nil)
                return
            }
            completion(
                decoded.imdbRating,
                decoded.poster,
                decoded.genre,
                decoded.type,
                decoded.plot
            )
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
