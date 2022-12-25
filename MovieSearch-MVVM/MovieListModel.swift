//
//  MovieListModel.swift
//  MovieSearch-MVVM
//
//  Created by Kiran Sonne on 19/10/22.
//

import Foundation
struct MovieListModel: Codable {
    let search: [Search]
    let totalResults: String
    let response: String
    
    enum CodingKeys: String,CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}
struct Search: Codable {
    let title,year, imdbID: String
    let type: TypeEnum
    let poster: String
    var posterURL: URL? {
        return URL(string: poster)
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
    
    
    
}
enum TypeEnum: String, Codable {
    case movie = "movie"
    case series = "series"
}
