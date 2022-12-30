//
//  CollectionViewTableViewCell.swift
//  NETFLIX
//
//  Created by Mesut Aygün on 22.12.2022.
//

import UIKit


// bu protokolun amaci collection icinde tiklanildiginda homeviewcontrollerdan filmpreviewcontrollera veriyi aktarmak icin kullandik,didSelectItem da kullanicaz
protocol CollectionViewTableViewCellDelegate : AnyObject {
    func collectionViewCellDidTap(_ cell : CollectionViewTableViewCell , viewModel : FilmPreviewModel)
}

class CollectionViewTableViewCell: UITableViewCell {

    
    // MARK: PROPERTIES
 static let identifier = "CollectionViewTableViewCell"
    private var filmler : [Filmler] = [Filmler]()
    
    let viewModel = FilmlerViewModel()
    
    //protokol delegate
    weak var delegate : CollectionViewTableViewCellDelegate?
    
    
   // MARK: UI ELEMENTS
    
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    
    // MARK: FUNC
  
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    
    // MARK: bu homeviewcontrollerdan filmleri almak icin kullandigimiz fonksiyon cellforrow da cagiriliyor
    public func configure(with filmler : [Filmler]){
        self.filmler = filmler
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func downloadFilmAt(indexPath : IndexPath){
        let index = filmler[indexPath.row]
        DataPersistenceManager.shared.downloadFilmManager(model: index) { result in
            switch result {
            case .success():
               print("success")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}



// MARK: EXTENSIONS COLLLECTIONVIEW

extension CollectionViewTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filmler.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        // MARK: burada filmlerden posterpath i cekerek collectionviewcelle gonderiyoruz orada tanimlanan configure fonksiyonu ile veriyi gonderdik
        guard let model = filmler[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        cell.configure(with: model)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let index = filmler[indexPath.row]
        guard let titleName = index.original_title ?? index.original_name else {
            return
        }
        //youtube api
        self.viewModel.getYoutubeItems(with: titleName + " trailer") {[weak self] error in
            if let error = error {
                print(error)
            }
        guard let overView = index.overview else {return}
        
        guard let strongSelf = self else {return}
            
            let viewModel = FilmPreviewModel(title: titleName , overView: overView, youtubeView: self!.viewModel.filmlerYoutubeItems.first!)
            
            self?.delegate?.collectionViewCellDidTap(strongSelf, viewModel: viewModel)
           
            
          
           
        }
    }
    //collection view icerisinde resme tiklandiginda UIMenu acilir
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let downloadAction = UIAction(title: "Download", image: UIImage(systemName: "square.and.arrow.down")) { action in
            // Perform action 1
          let index =  self.filmler[indexPath.row]
            DataPersistenceManager.shared.downloadFilmManager(model: index) { result in
                switch result {
                case .success():
                    //download a basildiginda downloadviewcontrollerda tekrar fetch islemi yapilir
                    NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                case .failure(let error):
                    print(error)
                }
            }
        }
        let favoritesAction = UIAction(title: "Add Favorites", image: UIImage(systemName: "star.fill")) { action in
            // Perform action 2
            print("favorites tapped")
            let index =  self.filmler[indexPath.row]
            DataPersistenceManager.shared.downloadFavoritesFilmManager(model: index) { result in
                switch result {
                case .success():
                    NotificationCenter.default.post(name: NSNotification.Name("favorites"), object: nil)
                case .failure(let error):
                    print(error)
                }
            }
        }
        let menu = UIMenu(title: "", children: [downloadAction, favoritesAction])
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            return menu
        })
        return configuration
    }

}
