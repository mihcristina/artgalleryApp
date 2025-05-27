//
//  HomeViewModel.swift
//  ArtGalleryApp
//
//  Created by Michelli Cristina de Paulo Lima on 26/05/25.
//

import Foundation

final class HomeViewModel {

    private let session: URLSession
    private let apiKey: String
    private let favoritesManager = FavoritesManager()
    var onIrregularPhotosLoaded: (([Photo]) -> Void)?
    var onFavoritesLoaded: (([Photo]) -> Void)?
    private(set) var photos: [Photo] = []
    var onPhotosLoaded: (([Photo]) -> Void)?
    var onError: ((Error) -> Void)?

    init(session: URLSession = .shared) {
        self.session = session
        guard let key = Bundle.main.object(forInfoDictionaryKey: "UNSPLASH_API_KEY") as? String else {
            fatalError("API Key not found in Info.plist")
        }
        self.apiKey = key
    }
    
    func fetchIrregularPhotos(query: String = "people", page: Int = 1, perPage: Int = 20) {
        fetchPhotos(query: query, page: page, perPage: perPage) { [weak self] photos in
            self?.onIrregularPhotosLoaded?(photos)
        }
    }

    func fetchPhotos(query: String, page: Int = 1, perPage: Int = 20, completion: @escaping ([Photo]) -> Void) {
        let urlString = "https://api.unsplash.com/search/photos?page=\(page)&per_page=\(perPage)&query=\(query)&client_id=\(apiKey)"
        guard let url = URL(string: urlString) else { return }

        session.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.onError?(error)
                }
                return
            }

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode(SearchResults.self, from: data)

                let favoriteIDs = self?.favoritesManager.loadFavorites() ?? []
                var markedPhotos = result.results
                for i in 0..<markedPhotos.count {
                    if favoriteIDs.contains(markedPhotos[i].id) {
                        markedPhotos[i].isFavorite = true
                    }
                }

                DispatchQueue.main.async {
                    self?.photos = markedPhotos
                    completion(markedPhotos) // <-- usamos a closure passada como parâmetro aqui!
                }

            } catch {
                DispatchQueue.main.async {
                    self?.onError?(error)
                }
            }
        }.resume()
    }

    func toggleFavorite(photoID: String) {
        guard let index = photos.firstIndex(where: { $0.id == photoID }) else { return }
        photos[index].isFavorite.toggle()

        let favorites = Set(photos.filter { $0.isFavorite }.map { $0.id })
        favoritesManager.saveFavorites(favorites)
        
        onPhotosLoaded?(photos)
    }

    func loadFavoritePhotos() {
        let ids = favoritesManager.loadFavorites()
        let favoritePhotos = photos.filter { ids.contains($0.id) }
        onFavoritesLoaded?(favoritePhotos)
    }

}
