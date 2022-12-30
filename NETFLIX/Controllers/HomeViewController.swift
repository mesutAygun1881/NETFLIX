//
//  HomeViewController.swift
//  NETFLIX
//
//  Created by Mesut Aygün on 22.12.2022.
//

import UIKit

enum Sections : Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case Toprated = 4

}

class HomeViewController: UIViewController {
    
    // MARK: PROPERTIES
    private var randomHeaderView : Filmler?
    private var headerView : HeroHeaderUIView?
    let sectionTitles : [String] = ["Trending Movies" , "Popular" , "Trending Tv" , "Upcoming Movies","Top Rated"]
    var filmPreview = [FilmPreviewModel]()
    let viewModel = FilmlerViewModel()
    var pagination = 1
    
    // MARK: UI ELEMENTS
    
    private let homeFeedTable : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()

  
    

// MARK:    FUNCTIONS
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        //ana sayfada tableview header olusturuldu
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        
        view.addSubview(homeFeedTable)
        
        configureNavigationBar()
        
        randomyHeaderView()
   

    }
    
    public func goToPlay(){
      let vc = FilmPreviewViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)

        
        
     
       
    }
   
    
    // header view icin random film gosterimi configure ile uiheaderview e datayi gonderiyoruz
     func randomyHeaderView(){
        self.viewModel.getPopularFilmlerItems { [self] error in
            if let error = error {
                print(error)
            }
          
            self.randomHeaderView = self.viewModel.filmlerPopularItems.randomElement()
            print("RANDOMM \(randomHeaderView)")
        
            guard let random = self.randomHeaderView else {return}
            guard let header = self.headerView else {return}
            
            guard let title = random.original_name ?? random.original_title else {return}
            guard let overView = random.overview else {return}
            self.headerView?.configure(with: random)
            
           
          
            //youtube api
            self.viewModel.getYoutubeItems(with: title + " trailer") {error in
                if let error = error {
                    print("errorsss \(error)")
                }

            
                guard let film = self.viewModel.filmlerYoutubeItems.first else {return}
              
                let viewModel = FilmPreviewModel(title: title , overView: overView, youtubeView: film)
                print("basarili \(viewModel)")
               
               
            }
           
        }
    }
    public func gestureHero(){
        print("gesture")
    }
    @objc func randomysHeaderView(){
       
            
                        print("RANDOMM \(randomHeaderView)")
           
            guard let random = self.randomHeaderView else {return}
            guard let header = self.headerView else {return}
            
            guard let title = random.original_name ?? random.original_title else {return}
            guard let overView = random.overview else {return}
          
            //youtube api
            self.viewModel.getYoutubeItems(with: title + " trailer") {error in
                if let error = error {
                    print("errorsss \(error)")
                }

            
                guard let film = self.viewModel.filmlerYoutubeItems.first else {return}
               
                let viewModel = FilmPreviewModel(title: title , overView: overView, youtubeView: film)
                print("basarili \(viewModel)")
                DispatchQueue.main.async {
                    let vc = FilmPreviewViewController()
                    vc.configure(with: viewModel)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
               
            }
           
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        homeFeedTable.frame = view.bounds
    }
    
    private func configureNavigationBar(){
        
        var image = UIImage(named: "netflix_logo")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        //navigation butonlari
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self,action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: #selector(randomysHeaderView))
        ]
        navigationController?.navigationBar.tintColor = .white
    }
}

// MARK: EXTENSION TABLEVIEW
extension HomeViewController : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else{
            
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        // MARK: section lara geldiginde datayi cagiracak 1.sectionda ise trending cagirp gerekli aarrayde veriyi depolayacak ve tableViewcell deki configure fonksiyonu ile oraya filmler verisini gonderecek
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            self.viewModel.getTrendingFilmlerItems { error in
                if let error = error {
                    print(error)
                }
                print(self.viewModel.filmlerTrendingItems)
                cell.configure(with: self.viewModel.filmlerTrendingItems)
               
            }
        case Sections.Popular.rawValue:
            self.viewModel.getPopularFilmlerItems { error in
                if let error = error {
                    print(error)
                }
             
                print(self.viewModel.filmlerPopularItems)
                cell.configure(with: self.viewModel.filmlerPopularItems)
            }
        case Sections.TrendingTv.rawValue:
            self.viewModel.getTvSeriesFilmlerItems { error in
                if let error = error {
                    print(error)
                }
             
                print(self.viewModel.filmlerTvSeriesItems)
                cell.configure(with: self.viewModel.filmlerTvSeriesItems)
            }

        case Sections.Toprated.rawValue:
            self.viewModel.getTopRatedFilmlerItems { error in
                if let error = error {
                    print(error)
                }
             
                print(self.viewModel.filmlerTopRatedItems)
                cell.configure(with: self.viewModel.filmlerTopRatedItems)
            }

            
        case Sections.Upcoming.rawValue:
            self.viewModel.getUpcomingFilmlerItems(pagination : self.pagination) { error in
                if let error = error {
                    print(error)
                }
             
                print(self.viewModel.filmlerUpcomingItems)
                cell.configure(with: self.viewModel.filmlerUpcomingItems)
            }

        default:
            return UITableViewCell()
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    //header da ne yazacagini belirleyen method
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
   
    
    //header texti ozellestirme
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizedFirstLetter()
        
    }
    
    //bu fonksiyonla navigation bar scroll oldugunda ki davranis seklini belirliyoruz.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
  
}


// buradan pushViewController ile FilmPreviewControllere geciyoruz collection icinde resme tiklandiginda configure ile veriyi aktardik delegate icindeki viewModel de verimiz mevcut
//cell icindeki veriyi almak icin protocol kullandik

extension HomeViewController : CollectionViewTableViewCellDelegate {
    func collectionViewCellDidTap(_ cell: CollectionViewTableViewCell, viewModel: FilmPreviewModel) {
        DispatchQueue.main.async { [weak self] in
            
            let vc = FilmPreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}


    
    
        

        
       
    
    
    

