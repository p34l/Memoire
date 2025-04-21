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

    var filteredItems: [ListItem] {
        let listItems = dataManager.items.map { ListItem(from: $0) } 
        if searchText.isEmpty {
            return listItems
        } else {
            return listItems.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.top, 10)
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
            // adding ItemView
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
