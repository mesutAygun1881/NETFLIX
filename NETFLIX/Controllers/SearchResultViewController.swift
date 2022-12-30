//
//  SearchResultViewController.swift
//  NETFLIX
//
//  Created by Mesut Aygün on 26.12.2022.
//

import UIKit

protocol SearchResultViewControllerProtocol : AnyObject {
    func searchCollectionViewCellTap(_ viewModel : FilmPreviewModel)
}

class SearchResultViewController: UIViewController {
    
    // MARK: PRoPERTIES
    
   public var filmler = [Filmler]()
   let viewModel = FilmlerViewModel()
    weak var delegate : SearchResultViewControllerProtocol?
    // MARK: UI
    
   public var searchCollectionView : UICollectionView = {
       let layout = UICollectionViewFlowLayout()
       layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
       layout.scrollDirection = .vertical
       let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
       collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
       return collectionView
    }()
    
    // MARK: FUNCTIONS

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(searchCollectionView)
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchCollectionView.frame = view.bounds
    }
    

   

}


// MARK: EXTENSIONS


extension SearchResultViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filmler.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let posterPath = self.filmler[indexPath.row].poster_path {
            cell.configure(with: posterPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let index = self.filmler[indexPath.row]
        guard let titleName = index.original_title ?? index.original_name else {return}
                self.viewModel.getYoutubeItems(with: titleName + " trailer") { error in
                    if let error = error {
                        print(error)
                    }
                    guard let overView = index.overview else { return}
                    guard let videoId = self.viewModel.filmlerYoutubeItems.first else { return}
                    self.delegate?.searchCollectionViewCellTap(FilmPreviewModel(title: titleName, overView: overView, youtubeView: videoId))
                }
        
        
    }
       
       
    
}



