//
//  HomeViewController.swift
//  VeroCaseStudy
//
//  Created by Mac on 8.02.2023.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView? = UICollectionView()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.backgroundColor = .systemBlue
        controller.searchBar.tintColor = .white
        controller.searchBar.searchTextField.backgroundColor = .white.withAlphaComponent(0.3)
        controller.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search in App", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        return controller
    }()
    
    private let scanButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "scan"), for: .normal)
        button.tintColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 32
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapScan), for: .touchUpInside)
        return button
    }()
    
    private lazy var viewModel = HomeViewModel()
    
    var refresher: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        makeUI()
        makeCollectionView()
        makeSearchController()
        makeScanButton()
        viewModel.delegate = self
        viewModel.fetchHomeData()
        addRefresher()
    }

    
    
    private func makeUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "BauBuddy"
        
    }
    
    
    private func makeSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
    }

    private func makeCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(HomeTaskCollectionViewCell.self, forCellWithReuseIdentifier: HomeTaskCollectionViewCell.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .clear
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.isPrefetchingEnabled = false
        layout.minimumInteritemSpacing = 2
        view.addSubview(collectionView!)
        NSLayoutConstraint.activate([
            collectionView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            collectionView!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func makeScanButton() {
        view.addSubview(scanButton)
        view.bringSubviewToFront(scanButton)
        
        NSLayoutConstraint.activate([
            scanButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            scanButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            scanButton.widthAnchor.constraint(equalToConstant: 64),
            scanButton.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    private func addRefresher() {
        self.refresher = UIRefreshControl()
            self.collectionView!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.label
            self.refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
            self.collectionView!.addSubview(refresher)
    }
    
    //OBJ-C Functions
    
    @objc func loadData() {
        self.collectionView!.refreshControl?.beginRefreshing()
        viewModel.fetchHomeData()
        self.refresher.endRefreshing()
      
     }
    
    @objc private func didTapScan() {
        let vc = ScanViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func tasksLoaded() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getHomeDataCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let taskObj = viewModel.getTask(at: indexPath.row)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTaskCollectionViewCell.identifier, for: indexPath) as? HomeTaskCollectionViewCell else { return UICollectionViewCell() }
            DispatchQueue.main.async {
                cell.set(task: taskObj!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  16
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/2, height: 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
    }

}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let text = searchBar.text else { return }
        viewModel.updateSearchResults(text: text)
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    
}

extension HomeViewController: ScanViewControllerDelegate {
    func didScannedText(scanText: String) {
        let searchBar = searchController.searchBar
        searchBar.becomeFirstResponder()
        searchBar.text = scanText
    }

}
