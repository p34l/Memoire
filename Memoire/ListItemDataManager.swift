//
//  ListItemDataManager.swift
//  Memoire
//
//  Created by Misha Kandaurov on 20.04.2025.
//

import CoreData

class ListItemDataManager: ObservableObject {
    let container: NSPersistentContainer
    @Published var items: [ListItemEntity] = []
    
    init() {
        container = PersistenceController.shared.container 
        fetchItems()
    }
    
    func fetchItems() {
        let request: NSFetchRequest<ListItemEntity> = ListItemEntity.fetchRequest()
        do {
            items = try container.viewContext.fetch(request)
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }
    
    func addItem(
        title: String,
        rating: String,
        posterURL: String?,
        genre: String?,
        type: String?,
        plot: String?
    ) {
        let newItem = ListItemEntity(context: container.viewContext)
        newItem.id = UUID()
        newItem.title = title
        newItem.rating = rating
        newItem.posterURL = posterURL
        newItem.genre = genre
        newItem.type = type
        newItem.plot = plot
        
        saveContext()
    }
    
    func deleteItem(_ item: ListItemEntity) {
        container.viewContext.delete(item)
        saveContext()
    }
    
    
    private func saveContext() {
        do {
            try container.viewContext.save()
            fetchItems()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
