//
//  NetworkService.swift
//  ArtGalleryApp
//
//  Created by Michelli Cristina de Paulo Lima on 26/05/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingFailed
    case requestFailed(Error)
}

class NetworkService {
    static let shared = NetworkService()
    private init() {}

    func request<T: Decodable>(
        urlString: String,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }

        task.resume()
    }
}
