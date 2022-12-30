//
//  FIlmPreviewViewController.swift
//  NETFLIX
//
//  Created by Mesut Aygün on 27.12.2022.
//

import UIKit
import WebKit

class FilmPreviewViewController: UIViewController {
    
    // MARK: PROPERTIES
    
    
    // MARK: UI ELEMENTS

    private let webView : WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Avatar"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let overViewLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Avatar is the best movie ever to watch as a kid."
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    private let downloadButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        return button
    }()
    
    
    // MARK: FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overViewLabel)
        view.addSubview(downloadButton)
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        self.webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        self.webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        self.webView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 4).isActive = true
        
        self.titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 10).isActive = true
        
        
        self.overViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        self.overViewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        self.overViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        self.downloadButton.topAnchor.constraint(equalTo: overViewLabel.bottomAnchor, constant: 25).isActive = true
        self.downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        downloadButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        downloadButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    
    // MARK: configure ile home view controllerda collectionlar icindeki film resime tiklandiginda videoId title ve overview almak icin bu fonksiyonu olusturduk tum datayi tek tek yazmak yerine FilmPreviewModel olusturduk
    func configure(with model : FilmPreviewModel) {
        self.titleLabel.text = model.title
        self.overViewLabel.text = model.overView
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else{
            return
        }
        webView.load(URLRequest(url: url))
    }
}
