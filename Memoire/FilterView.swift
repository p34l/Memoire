//
//  FilterView.swift
//  Memoire
//
//  Created by Misha Kandaurov on 23.04.2025.
//

import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var selectedType: String?
    @Binding var selectedGenres: Set<String>
    @Binding var minRating: Double
    
    var allItems: [ListItem]
    
    var availableTypes: [String] {
        Array(Set(allItems.compactMap { $0.type })).sorted()
    }
    
    var availableGenres: [String] {
        let genres = allItems
            .compactMap { $0.genre }
            .flatMap { $0.components(separatedBy: ",") }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        return Array(Set(genres)).sorted()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Type")) {
                    Picker("Choosen type", selection: $selectedType) {
                        Text("All").tag(String?.none)
                        ForEach(availableTypes, id: \.self) { type in
                            Text(type.capitalized).tag(Optional(type))
                        }
                    }
                }
                
                Section(header: Text("Genres")) {
                    ForEach(availableGenres, id: \.self) { genre in
                        Button(action: {
                            if selectedGenres.contains(genre) {
                                selectedGenres.remove(genre)
                            } else {
                                selectedGenres.insert(genre)
                            }
                        }) {
                            HStack {
                                Text(genre)
                                Spacer()
                                if selectedGenres.contains(genre) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                
                Section(header: Text("Rating")) {
                    Slider(value: $minRating, in: 0...10, step: 0.1) {
                        Text("Rating")
                    }
                    Text("Min rating: \(String(format: "%.1f", minRating))")
                }
                
                Section {
                    Button("Clear Filters") {
                        selectedType = nil
                        selectedGenres = []
                        minRating = 0
                        withAnimation {
                            dismiss()
                        }
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Filter your list")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        withAnimation {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

