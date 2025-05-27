//
//  HomeViewController.swift
//  ArtGalleryApp
//
//  Created by Michelli Cristina de Paulo Lima on 26/05/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    private let viewModel = HomeViewModel()
    private var horizontalPhotos: [Photo] = []
    private var irregularPhotos: [Photo] = []

    override func loadView() {
        self.view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViews()
        setupViewModelBindings()
        fetchPhotos()
    }

    private func setupNavigation() {
        title = "Photos"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupViews() {
        
        homeView.horizontalCollectionView.dataSource = self
        homeView.irregularCollectionView.dataSource = self
        
        homeView.horizontalCollectionView.delegate = self
        homeView.irregularCollectionView.delegate = self
        
        if let layout = homeView.irregularCollectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }
    
    private func setupViewModelBindings() {
        viewModel.onIrregularPhotosLoaded = { [weak self] photos in
            self?.irregularPhotos = photos
            self?.homeView.irregularCollectionView.reloadData()
        }
        
        viewModel.onError = { error in
            print("Erro ao carregar fotos: \(error)")
        }
        viewModel.onFavoritesLoaded = { [weak self] favorites in
            self?.horizontalPhotos = favorites
            self?.homeView.horizontalCollectionView.reloadData()
        }

    }
    private func fetchPhotos() {
        viewModel.fetchIrregularPhotos()
    }

    private func updateFavorites() {
        horizontalPhotos = irregularPhotos.filter { $0.isFavorite }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == homeView.horizontalCollectionView {
            return horizontalPhotos.count
        } else if collectionView == homeView.irregularCollectionView {
            return irregularPhotos.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        
        let photo: Photo
        
        if collectionView == homeView.horizontalCollectionView {
            photo = horizontalPhotos[indexPath.item]
        } else {
            photo = irregularPhotos[indexPath.item]
        }
        
        cell.configure(with: photo.urls.regular)
        
        return cell
    }
}
extension HomeViewController: PinterestLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        
        guard collectionView == homeView.irregularCollectionView else {
            return 140
        }

        return CGFloat(arc4random_uniform(100) + 300)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == homeView.irregularCollectionView else { return }
        let photo = irregularPhotos[indexPath.item]
        viewModel.toggleFavorite(photoID: photo.id)
        viewModel.loadFavoritePhotos()
    }
}

