//
//  SearchResults.swift
//  ArtGalleryApp
//
//  Created by Michelli Cristina de Paulo Lima on 26/05/25.
//

import UIKit

struct SearchResults: Decodable {
    let results: [Photo]
}

struct Photo: Decodable {
    let id: String
    let urls: PhotoURLs

    var isFavorite: Bool = false

    enum CodingKeys: String, CodingKey {
        case id
        case urls
    }
}

struct PhotoURLs: Decodable {
    let small: String
    let regular: String
}
