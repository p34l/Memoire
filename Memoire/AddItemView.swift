//
//  Untitled.swift
//  Memoire
//
//  Created by Misha Kandaurov on 18.04.2025.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var items: [ListItem]
    
    @State private var title: String = ""
    @State private var dateAdded: Date = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter name", text: $title)
                }
            }
            .navigationTitle("Add New")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        fetchIMDBData(for: title) { ratingString, posterURL, genre, type, plot in
                            DispatchQueue.main.async {
                                let ratingValue = String(format: "%.1f", Double(ratingString ?? "") ?? 0)
                                
                                let newItem = ListItem(
                                    id: UUID(),
                                    title: title,
                                    type: type,
                                    rating: ratingValue,
                                    dateAdded: Date(),
                                    posterURL: posterURL,
                                    genre: genre,
                                    plot: plot
                                )
                                items.append(newItem)
                                dismiss()
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    func fetchIMDBData(for title: String, completion: @escaping (String?, String?, String?, String?, String?) -> Void) {
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
                let decoded = try? JSONDecoder().decode(OMDbResponse.self, from: data)
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
}
