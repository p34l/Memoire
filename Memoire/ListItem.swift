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
    let dateAdded: Date
    let posterURL: String?
    let genre: String?
    let plot: String?

}

