//
//  ViewCodable.swift
//  ArtGalleryApp
//
//  Created by Michelli Cristina de Paulo Lima on 26/05/25.
//

import Foundation

protocol ViewCodeable {
    func buildHierarchy()
    func setupConstraints()
    func setupAdditionalConfiguration()
    func setupView()
}

extension ViewCodeable {
    func setupView() {
        buildHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }
}
