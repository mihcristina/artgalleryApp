//
//  FavoritesManager.swift
//  ArtGalleryApp
//
//  Created by Michelli Cristina de Paulo Lima on 26/05/25.
//

import Foundation

final class FavoritesManager {
    private let favoritesKey = "favoritePhotoIDs"

    func loadFavorites() -> Set<String> {
        let ids = UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []
        return Set(ids)
    }

    func saveFavorites(_ ids: Set<String>) {
        UserDefaults.standard.set(Array(ids), forKey: favoritesKey)
    }
}
