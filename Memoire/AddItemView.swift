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
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter name", text: $title)
                }
            }
            .navigationTitle("Add New")  
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        IMDBService.fetchIMDBData(for: title) { ratingString, posterURL, genre, type, plot in
                            IMDBService.handleFetchedData(
                                title: title,
                                ratingString: ratingString,
                                posterURL: posterURL,
                                genre: genre,
                                type: type,
                                plot: plot,
                                dataManager: dataManager,
                                dismiss: dismiss,
                                viewContext: dataManager.container.viewContext
                            )
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
