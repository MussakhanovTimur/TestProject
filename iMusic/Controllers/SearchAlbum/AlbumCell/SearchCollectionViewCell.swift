//
//  SearchCollectionViewCell.swift
//  iMusic
//
//  Created by Тимур Мусаханов on 16.01.2021.
//

import UIKit
import SDWebImage

class SearchCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "searchCollectionViewCell"
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.shadowRadius = 9
        imageView.layer.shadowOpacity = 0.3
        imageView.layer.shadowOffset = CGSize(width: 5, height: 8)
        return imageView
    }()
    
    private var albumNameLabel: UILabel?
    private var artistNameLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        albumNameLabel = generateLabel(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        artistNameLabel = generateLabel(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
        
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImageView.image = nil
    }
    
    private func setupConstraints() {
        guard let albumNameLabel = albumNameLabel else { return }
        guard let artistNameLabel = artistNameLabel else { return }
        
        addSubview(albumImageView)
        addSubview(albumNameLabel)
        addSubview(artistNameLabel)
        
        // albumImageView constraints
        NSLayoutConstraint.activate([
            albumImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            albumImageView.topAnchor.constraint(equalTo: topAnchor),
            albumImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            albumImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -35)
        ])
        
        // albumNameLabel constraints
        NSLayoutConstraint.activate([
            albumNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            albumNameLabel.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 5),
            albumNameLabel.trailingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: -5)
        ])
        
        // artistNameLabel constraints
        NSLayoutConstraint.activate([
            artistNameLabel.leadingAnchor.constraint(equalTo: albumImageView.leadingAnchor),
            artistNameLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor),
            artistNameLabel.trailingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: -5)
        ])
    }
    
    private func generateLabel(_ textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }
    
    func configureCell(album: Album) {
        albumNameLabel?.text = album.collectionName
        artistNameLabel?.text = album.artistName
        
        guard let stringImage = album.artworkUrl100 else { return }
        guard let imageUrl = URL(string: stringImage) else { return }
        albumImageView.sd_setImage(with: imageUrl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
