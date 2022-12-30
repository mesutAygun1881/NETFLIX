//
//  HeroHeaderUIView.swift
//  NETFLIX
//
//  Created by Mesut Aygün on 24.12.2022.
//

import UIKit



class HeroHeaderUIView: UIView {
    let viewModel = FilmlerViewModel()
    var filmler = [Filmler]()
  static let identifier = "HeroHeaderUIView"
    // MARK: UI Elements
   private let heroImageView : UIImageView = {
        let image = UIImageView()
       image.contentMode = .scaleAspectFill
       image.clipsToBounds = true
       image.image = UIImage(named: "heroImage")
       return image
    }()
    
    
    private let playButton : UIButton = {
       let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action:#selector(goToPlay), for: .touchUpInside)
        return button
    }()
    
    private let downloadButton : UIButton = {
       let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let categoriesLabel : UILabel = {
       let label = UILabel()
        label.text = "Categories"
        label.textColor = .white
        label.backgroundColor = .systemBackground
        label.layer.opacity = 0.5
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.isUserInteractionEnabled = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        addSubview(heroImageView)
        
        addGradient()
        
        addSubview(playButton)
        addSubview(downloadButton)
        addSubview(categoriesLabel)
        applyConstraint()
        categoriesLabel.isUserInteractionEnabled = true
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        categoriesLabel.addGestureRecognizer(labelTap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    //gradient fonksiyonu
    private func addGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor ,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    @objc func labelTapped(_ sender : Any){
       
       configureCategories()
    }
   
    
    @objc func goToPlay(_ sender : UIButton){
       
       print("aaa")
        let vc = HomeViewController()
        vc.goToPlay()
    
    }
    
  
    private func applyConstraint(){
        playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70).isActive = true
        playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70).isActive = true
        downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50).isActive = true
        downloadButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        categoriesLabel.topAnchor.constraint(equalTo: heroImageView.topAnchor, constant: 20).isActive = true
        categoriesLabel.centerXAnchor.constraint(equalTo: heroImageView.centerXAnchor).isActive = true
        categoriesLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        categoriesLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    // home view controllerdan alinan veriyi gostermek icin kullanilan function
    func configure(with model : Filmler?){
        guard let filmler = model else {return}
        self.filmler = [filmler]
     
        guard let poster = model?.poster_path else {return}
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(poster)") else{return}
        DispatchQueue.global().async {
            
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                self.heroImageView.image = UIImage(data: data!)
            }
        }
      
     
        
    }
    func configureCategories(){
        
        let vc = HomeViewController()
        vc.gestureHero()
    }

}
