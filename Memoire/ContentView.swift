//
//  ContentView.swift
//  Memoire
//
//  Created by Misha Kandaurov on 18.04.2025.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var dataManager = ListItemDataManager()
    @State private var showingAddScreen = false
    @State private var searchText: String = ""
    @State private var selectedType: String? = nil
    @State private var selectedGenres: Set<String> = []
    @State private var minRating: Double = 0
    @State private var showingFilter = false
    
    var filteredItems: [ListItem] {
        let listItems = dataManager.items.map { ListItem(from: $0) }
        
        return listItems.filter { item in
            let matchesSearch = searchText.isEmpty || item.title.lowercased().contains(searchText.lowercased())
            let matchesType = selectedType == nil || item.type == selectedType
            
            let itemGenres = item.genre?
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) } ?? []
            
            let matchesGenres = selectedGenres.isEmpty || !selectedGenres.isDisjoint(with: itemGenres)
            
            let ratingValue = Double(item.rating) ?? 0
            let matchesRating = ratingValue >= minRating
            
            return matchesSearch && matchesType && matchesGenres && matchesRating
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredItems, id: \.id) { item in
                    ItemRow(item: item)
                        .padding(.vertical, 6)
                }
                .onDelete { indexSet in
                    indexSet.map { dataManager.items[$0] }.forEach { item in
                        dataManager.deleteItem(item)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showingFilter = true
                    }) {
                        Label("Filter", systemImage: "line.3.horizontal.decrease")
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Memoire")
                        .font(.title)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showingAddScreen = true
                    }) {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingFilter) {
                FilterView(
                    selectedType: $selectedType,
                    selectedGenres: $selectedGenres,
                    minRating: $minRating, 
                    allItems: dataManager.items.map { ListItem(from: $0) }
                )
            }
            .sheet(isPresented: $showingAddScreen) {
                AddItemView(dataManager: dataManager)
            }
        }
    }
    
    struct ItemRow: View {
        var item: ListItem
        
        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                posterView
                itemDetails
                Spacer()
                plotText
            }
        }
        
        private var posterView: some View {
            Group {
                if let posterURL = item.posterURL, let url = URL(string: posterURL) {
                    CachedAsyncImage(url: url, width: 60, height: 90)
                } else {
                    Image(systemName: "film")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 90)
                        .foregroundColor(.gray)
                        .cornerRadius(8)
                }
            }
        }
        
        private var itemDetails: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                if let type = item.type {
                    Text(type)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                if let genre = item.genre {
                    Text(genre)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Text("⭐️ \(item.rating)/10")
                    .font(.caption)
            }
        }
        
        private var plotText: some View {
            Group {
                if let plot = item.plot {
                    Text(plot)
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: 150, alignment: .leading)
                }
            }
        }
    }
}
