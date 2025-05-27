//
//  HomeView.swift
//  ArtGalleryApp
//
//  Created by Michelli Cristina de Paulo Lima on 26/05/25.
//

import UIKit

class HomeView: UIView {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blackLight
        label.text = "FAVORITOS"
        label.font = .gilroyBold(size: 14)
        return label
    }()
    
    var horizontalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 110, height: 72)
        layout.minimumLineSpacing = 8

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        return collection
    }()

    var irregularCollectionView: UICollectionView = {
        let layout = PinterestLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        return cv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HomeView: ViewCodeable {
    func buildHierarchy() {
        addSubview(titleLabel)
        addSubview(horizontalCollectionView)
        addSubview(irregularCollectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            horizontalCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            horizontalCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            horizontalCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalCollectionView.heightAnchor.constraint(equalToConstant: 72),
            
            irregularCollectionView.topAnchor.constraint(equalTo: horizontalCollectionView.bottomAnchor, constant: 10),
            irregularCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            irregularCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            irregularCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = .backgroundColor
    }
}
