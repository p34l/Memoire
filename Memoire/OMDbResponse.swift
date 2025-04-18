//
//  OMDbResponse.swift
//  Memoire
//
//  Created by Misha Kandaurov on 18.04.2025.
//

import Foundation

struct OMDbResponse: Codable {
    let imdbRating: String
    let poster: String?
    let genre: String
    let type: String
    let plot: String

    enum CodingKeys: String, CodingKey {
        case imdbRating
        case poster = "Poster"
        case genre = "Genre"
        case type = "Type"
        case plot = "Plot"
    }
}

