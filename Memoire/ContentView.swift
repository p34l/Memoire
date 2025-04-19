//
//  ContentView.swift
//  Memoire
//
//  Created by Misha Kandaurov on 18.04.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var items: [ListItem] = []
    @State private var showingAddScreen = false
    @State private var searchText: String = ""
    
    var filteredItems: [ListItem] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.top, 10)
                
                List {
                    ForEach(filteredItems) { item in
                        HStack(alignment: .top, spacing: 12) {
                            if let posterURL = item.posterURL,
                               let url = URL(string: posterURL) {
                                CachedAsyncImage(url: url, width: 60, height: 90)
                            } else {
                                Image(systemName: "film")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 90)
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.title)
                                    .font(.headline)
                                if let type = item.type {
                                    Text("\(type)")
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
                            
                            Spacer()
                            
                            if let plot = item.plot {
                                Text(plot)
                                    .font(.caption)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: 150, alignment: .leading)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                    .onDelete(perform: deleteItem)
                }
            }
            .navigationTitle("Memoire")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddScreen = true
                    }) {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddItemView(items: $items)
            }
        }
    }
    func deleteItem(at offsets: IndexSet) {
        let filtered = filteredItems
        for index in offsets {
            if let originalIndex = items.firstIndex(where: { $0.id == filtered[index].id }) {
                items.remove(at: originalIndex)
            }
        }
    }
}
