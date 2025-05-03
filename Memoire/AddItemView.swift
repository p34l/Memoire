//
//  Untitled.swift
//  Memoire
//
//  Created by Misha Kandaurov on 18.04.2025.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var dataManager: ListItemDataManager
    
    @State private var title: String = ""
    @State private var searchResults: [IMDbSearchItem] = []
    @State private var selectedMovie: IMDbSearchItem?
    @State private var showClearButton: Bool = false
    @State private var searchDebounceTimer: Timer? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Add New")
                    .font(.largeTitle.bold())
                    .padding(.top)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                HStack {
                    TextField("Enter movie title", text: $title)
                        .padding(.horizontal)
                        .frame(height: 45)
                        .background(Color(.systemGray6)) 
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                        .foregroundColor(.primary)
                        .onChange(of: title) { newValue in
                            searchDebounceTimer?.invalidate()
                            
                            searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                                searchMovies()
                            }
                        }
                }
                .padding([.leading, .trailing], 8)
                
                
                
                if !searchResults.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Search Results")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            if showClearButton {
                                Spacer()
                                Button("Clear Search") {
                                    clearSearch()
                                }
                                .padding(.trailing, 16)
                            }
                        }
                        
                        List(searchResults, id: \.imdbID) { movie in
                            Button(action: {
                                selectedMovie = movie
                                if let selectedMovie = selectedMovie {
                                    IMDbService.fetchMovieDetails(imdbID: selectedMovie.imdbID) { movies in
                                        if let movie = movies {
                                            IMDbService.handleFetchedData(
                                                title: movie.title,
                                                ratingString: movie.imdbRating,
                                                posterURL: movie.poster,
                                                genre: movie.genre,
                                                type: movie.type,
                                                plot: movie.plot,
                                                dataManager: dataManager,
                                                dismiss: dismiss,
                                                viewContext: dataManager.container.viewContext
                                            )
                                        }
                                    }
                                }
                            }) {
                                HStack {
                                    if let poster = movie.poster, let url = URL(string: poster) {
                                        AsyncImage(url: url) { image in
                                            image.resizable()
                                                .scaledToFill()
                                                .frame(width: 50, height: 75)
                                                .cornerRadius(8)
                                        } placeholder: {
                                            Color.gray.frame(width: 50, height: 75)
                                                .cornerRadius(8)
                                        }
                                    }
                                    Text(movie.title)
                                        .padding(.leading, 8)
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func searchMovies() {
        IMDbService.fetchIMDBData(for: title) { movies in
            if !movies.isEmpty {
                searchResults = movies
                showClearButton = true
            } else {
                searchResults = []
            }
        }
    }
    
    private func clearSearch() {
        title = ""
        searchResults = []
        showClearButton = false
    }
    
    
}
