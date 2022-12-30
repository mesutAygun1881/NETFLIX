//
//  SearchViewController.swift
//  NETFLIX
//
//  Created by Mesut Aygün on 22.12.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: PROPERTIES
    
    var filmler = [Filmler]()
    let viewModel = FilmlerViewModel()
    // MARK: UI

    private let discoverTableView : UITableView = {
        let table = UITableView()
        table.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        return table
    }()
    
    private let searchBar : UISearchController = {
        let searchBar = UISearchController(searchResultsController: SearchResultViewController())
        searchBar.searchBar.placeholder = "Search Movie or Tv Show"
        searchBar.searchBar.searchBarStyle = .minimal
        return searchBar
    }()
  
    // MARK: FUNC
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Discover"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchBar
        navigationController?.navigationBar.tintColor = .white
        
     
        discoverTableView.delegate = self
        discoverTableView.dataSource = self
        // Do any additional setup after loading the view.
        view.addSubview(discoverTableView)
        searchBar.searchBar.showsBookmarkButton = true
        searchBar.searchBar.setImage(UIImage(systemName: "line.3.horizontal"), for: .bookmark, state: .highlighted)
        
        self.viewModel.getDiscoverFilmlerItems { error in
            if let error = error {
                print(error)
            }
            self.filmler = self.viewModel.filmlerDiscoverItems
            DispatchQueue.main.async {
                self.discoverTableView.reloadData()
            }
        }
        
        searchBar.searchResultsUpdater = self
    }
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
  print("basildi")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTableView.frame = view.bounds
    }
    



}


// MARK: EXTENSION

extension SearchViewController : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filmler.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = discoverTableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as? UpcomingTableViewCell else {
            return UITableViewCell()
        }
        
        guard let filmAdi = self.filmler[indexPath.row].original_name ?? self.filmler[indexPath.row].original_title , let posterPath = self.filmler[indexPath.row].poster_path else{
            return UITableViewCell()
        }
        
        cell.configure(with: TitleViewModel(filmName: filmAdi, posterUrl: posterPath))
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let index = self.filmler[indexPath.row]
        guard let titleName = index.original_title ?? index.original_name else {return}
        let vc = FilmPreviewViewController()
                self.viewModel.getYoutubeItems(with: titleName + " trailer") { error in
                    if let error = error {
                        print(error)
                    }
                    guard let overview = index.overview else { return}
                    guard let videoId = self.viewModel.filmlerYoutubeItems.first else {return}
                    DispatchQueue.main.async {
                        
                        vc.configure(with: FilmPreviewModel(title: titleName, overView: overview, youtubeView: videoId))
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}



    // MARK: SEARCH BAR EXTENSION
extension SearchViewController : UISearchResultsUpdating , SearchResultViewControllerProtocol {
    func searchCollectionViewCellTap(_ viewModel: FilmPreviewModel) {
        DispatchQueue.main.async {
            
            let vc = FilmPreviewViewController()
            vc.configure(with: viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text , !query.trimmingCharacters(in: .whitespaces).isEmpty , query.trimmingCharacters(in: .whitespaces).count >= 3 ,
              let resultsController = searchController.searchResultsController as? SearchResultViewController else {
                              return
                          }
        
        
        self.viewModel.getSearchResultItems(with: query) { error in
            if let error = error {
                print(error)
            }
            DispatchQueue.main.async {
                resultsController.filmler = self.viewModel.filmlerSearchResultItems
             
                resultsController.searchCollectionView.reloadData()
                resultsController.delegate = self
                
            }
        }
    }
    
    
}
