//
//  UpcomingViewController.swift
//  NETFLIX
//
//  Created by Mesut Aygün on 22.12.2022.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    // MARK: PROPERTIES
    var pagination = 1
    var paginationIndex = 1
    let viewModel = FilmlerViewModel()
    var filmler = [Filmler]()
    
    // MARK: UI ELEMENTS

    private let upcomingTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        return tableView
    }()
    
    
    // MARK: FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        upcomingTableView.dataSource = self
        upcomingTableView.delegate = self
        fetchUpcoming()
        view.addSubview(upcomingTableView)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTableView.frame = view.bounds
    }
    
    func fetchUpcoming(){
        self.viewModel.getUpcomingFilmlerItems(pagination : self.pagination) { error in
            if let error = error {
                print(error)
            }
            
            self.filmler = self.viewModel.filmlerUpcomingItems
            DispatchQueue.main.async {
                self.upcomingTableView.reloadData()
            }
        }
    }


}


// MARK: EXTENSION

extension UpcomingViewController : UITableViewDelegate , UITableViewDataSource ,UIScrollViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filmler.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as? UpcomingTableViewCell else {
            return UITableViewCell()
        }
     
        if let filmName = self.filmler[indexPath.row].original_title ?? self.filmler[indexPath.row].original_name, let posterPath = self.filmler[indexPath.row].poster_path {
         print(filmName , posterPath)
            cell.configure(with: TitleViewModel(filmName: filmName, posterUrl: posterPath))
        }
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let index = self.filmler[indexPath.row]
        guard let titleName = index.original_title ?? index.original_name else{return}
        self.viewModel.getYoutubeItems(with: titleName + " trailer") { error in
            if let error = error {
                print(error)
            }
            guard let overview = index.overview else{return}
            guard let videoId = self.viewModel.filmlerYoutubeItems.first else{return}
            DispatchQueue.main.async {
                let vc = FilmPreviewViewController()
                vc.configure(with: FilmPreviewModel(title: titleName, overView: overview, youtubeView: videoId))
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("CALLED")
        let position = scrollView.contentOffset.y
        if position > (upcomingTableView.contentSize.height - 5 - scrollView.frame.size.height) {
            print("FETCH")
            if paginationIndex == 1 {
                self.pagination = 2
                self.paginationIndex = 2
                
                DispatchQueue.main.async {
                    self.viewModel.getUpcomingFilmlerItems(pagination : self.pagination) { error in
                        if let error = error {
                            print(error)
                        }
                        
                        self.filmler.append(contentsOf: self.viewModel.filmlerUpcomingItems)
                        DispatchQueue.main.async {
                            self.upcomingTableView.reloadData()
                        }
                    }
                    
                    self.upcomingTableView.reloadData()
                    
                    
                }
            }
        }
    }
}
