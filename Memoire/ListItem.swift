//
//  Memoire.swift
//  Memoire
//
//  Created by Misha Kandaurov on 18.04.2025.
//

import SwiftUI

struct ListItem: Identifiable, Codable {
    let id: UUID
    let title: String
    let type: String?
    let rating: String
    let posterURL: String?
    let genre: String?
    let plot: String?
    
    init(from entity: ListItemEntity) {
        self.id = entity.id ?? UUID()
        self.title = entity.title ?? ""
        self.rating = entity.rating ?? "0.0"  
        self.type = entity.type
        self.genre = entity.genre
        self.plot = entity.plot
        self.posterURL = entity.posterURL
    }
}
