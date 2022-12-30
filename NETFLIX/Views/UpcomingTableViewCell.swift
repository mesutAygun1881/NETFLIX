//
//  UpcomingTableViewCell.swift
//  NETFLIX
//
//  Created by Mesut Aygün on 26.12.2022.
//

import UIKit

class UpcomingTableViewCell: UITableViewCell {
    
    // MARK: PROPERTIES
    
    static let identifier = "UpcomingTableViewCell"
    private var filmler = [Filmler]()
    
    // MARK: UI
    
    private let upcomingImageView : UIImageView = {
        let image = UIImageView()
 
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
        return image
    }()
    private let upcomingLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
    
        return label
    }()
    private let upcomingPlayButon : UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(upcomingLabel)
        contentView.addSubview(upcomingImageView)
        contentView.addSubview(upcomingPlayButon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: FUNCTION
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //image
        upcomingImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        upcomingImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        upcomingImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        upcomingImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        //label
        upcomingImageView.heightAnchor.constraint(equalToConstant: 125).isActive = true
        upcomingLabel.leadingAnchor.constraint(equalTo: upcomingImageView.trailingAnchor, constant: 25).isActive = true
        upcomingLabel.centerYAnchor.constraint(equalTo: upcomingImageView.centerYAnchor).isActive = true
        upcomingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60).isActive = true
        
        //button
        upcomingPlayButon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor , constant: -10).isActive = true
        upcomingPlayButon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
       
        
    }
    
    func configure(with filmler : TitleViewModel){
       
     
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(filmler.posterUrl)") else{return}
            DispatchQueue.global().async {
                
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.upcomingImageView.image = UIImage(data: data!)
                    self.upcomingLabel.text = filmler.filmName
                }
            }
        
    }
}
