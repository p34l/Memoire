//
//  IMDbResponse.swift
//  Memoire
//
//  Created by Misha Kandaurov on 18.04.2025.
//

import Foundation

struct IMDbSearchResponse: Codable {
    let search: [IMDbSearchItem]
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}

struct IMDbSearchItem: Codable {
    let title: String
    let imdbID: String
    let poster: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case imdbID
        case poster = "Poster"
    }
}

struct IMDbResponse: Codable {
    let imdbRating: String
    let imdbID: String
    let title: String
    let poster: String?
    let genre: String
    let type: String
    let plot: String
    
    enum CodingKeys: String, CodingKey {
        case imdbRating
        case imdbID
        case poster = "Poster"
        case genre = "Genre"
        case type = "Type"
        case plot = "Plot"
        case title = "Title"
    }
}

