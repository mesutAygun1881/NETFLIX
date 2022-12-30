//
//  DownloadsViewController.swift
//  NETFLIX
//
//  Created by Mesut Aygün on 22.12.2022.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    
    // MARK: PROPERTIES
    let viewModel = FilmlerViewModel()
    var filmler = [FilmItem]()
    // MARK: UI ELEMENTS

    private let downloadTableView : UITableView = {
        let table = UITableView()
        table.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        return table
    }()
    
    // MARK: FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Download"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        downloadTableView.delegate = self
        downloadTableView.dataSource = self
        
        view.addSubview(downloadTableView)
        self.fetchFilmsforStorage()
        
        //collectiontableview cell de UIMenu de downloada basildiginda fetch yaparak tum filmler cagirilir
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchFilmsforStorage()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.downloadTableView.frame = view.bounds
    }
    
    private func fetchFilmsforStorage(){
        DataPersistenceManager.shared.fetchFilmManager { result in
            switch result {
            case .success(let titles):
                self.filmler = titles
                DispatchQueue.main.async {
                    self.downloadTableView.reloadData()
                }
               
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
   

}


extension DownloadsViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.filmler.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = downloadTableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as? UpcomingTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: TitleViewModel(filmName: (self.filmler[indexPath.row].original_name ?? self.filmler[indexPath.row].original_title)!, posterUrl: self.filmler[indexPath.row].poster_path ?? ""))
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
    
    //tablodan silme islemi 
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete :
            DataPersistenceManager.shared.deleteFilmManager(model: self.filmler[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                }
               
            }
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
