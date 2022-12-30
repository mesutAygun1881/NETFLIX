//
//  TitleCollectionViewCell.swift
//  NETFLIX
//
//  Created by Mesut Aygün on 25.12.2022.
//

import UIKit

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    private let posterImageView : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    // MARK: collectionviewden resim posterpath verisini almak icin kullandigimiz fonksiyon
    public func configure(with model : String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else{return}
        DispatchQueue.global().async {
            
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                self.posterImageView.image = UIImage(data: data!)
            }
        }
    }
    
    
}
