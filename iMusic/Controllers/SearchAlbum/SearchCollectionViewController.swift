//
//  SearchCollectionViewController.swift
//  iMusic
//
//  Created by Тимур Мусаханов on 16.01.2021.
//

import UIKit
import CoreData

class SearchCollectionViewController: UICollectionViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    private var albums: [Album] = [] {
        didSet {
            albums.sort(by: { $0.collectionName ?? "" < $1.collectionName ?? "" })
        }
    }
    private var timer: Timer?
    private var searchHistory: [String] = []
    private var albumDetailVC: AlbumDetailTableViewController?

    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(SearchCollectionViewCell.self,
                                forCellWithReuseIdentifier: SearchCollectionViewCell.reuseId)
        definesPresentationContext = true
        setupSerchBar()
        getSearchText()
        if let history  = UserDefaults.standard.object(forKey: "searchHistory") as? [String] {
            searchHistory = history
        }
    }
    
    private func setupSerchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Альбомы"
        searchController.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        searchBar(searchController.searchBar, textDidChange: "Red")
    }
    
    private func getAlbumDetailVC() -> AlbumDetailTableViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let albumDetailVC = storyboard.instantiateViewController(withIdentifier: "albumDetailVC") as? AlbumDetailTableViewController
        return albumDetailVC
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.reuseId, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
    
        let album = albums[indexPath.item]
        cell.configureCell(album: album)
    
        return cell
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        albumDetailVC = getAlbumDetailVC()
        guard let albumDetailVC = albumDetailVC else { return }
        let album = albums[indexPath.item]
        albumDetailVC.album = album
        
        navigationController?.pushViewController(albumDetailVC, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name(rawValue: "searchAlbum"),
                                                  object: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let marginWidth = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - marginWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// MARK: - UISearchBarDelegate
extension SearchCollectionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { [weak self] _ in
            ClientManager.sharedInstance.getAlbum(searchText: searchText) { [weak self] (result) in
                self?.saveSearchHistoryUserDefaults(searchText)
                
//                for CoreData operation
//                self?.saveSearchHistoryToCoreData(searchText)
                
                guard let result = result else { return }
                self?.albums = result
                self?.collectionView.reloadData()
            } onError: { [weak self] (error) in
                self?.presentErrorAlertController(withTitle: error)
            }

        })
        
    }
}

// MARK: - saveSearchHistoryToUserDefaults
extension SearchCollectionViewController {
    private func saveSearchHistoryUserDefaults(_ searchText: String) {
        guard searchText != "" else { return }
        
        for (i, text) in searchHistory.enumerated() {
            if text == searchText {
                searchHistory.remove(at: i)
            }
        }
        searchHistory.insert(searchText, at: 0)
        if searchHistory.count == 11 {
            searchHistory.removeLast()
        }
        UserDefaults.standard.set(searchHistory, forKey: "searchHistory")
    }
}

// MARK: - saveSearchHistoryToCoreData
//for the perspective of storing large amounts of data
extension SearchCollectionViewController {
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    private func saveSearchHistoryToCoreData(_ searchText: String) {
        guard searchText != "" else { return }
        let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "History", in: context) else { return }
        
        let historyObject = History(entity: entity, insertInto: context)
        historyObject.title = searchText
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

// MARK: - getSearchText
extension SearchCollectionViewController {
    private func getSearchText() {
        NotificationCenter.default.addObserver(self, selector: #selector(setupSearchText(notification:)),
                                               name: Notification.Name(rawValue: "searchAlbum"),
                                               object: nil)
    }
    
    @objc private func setupSearchText(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let searchText = userInfo["searchText"] as? String else { return }
        searchController.searchBar.text = searchText
        searchBar(searchController.searchBar, textDidChange: searchText)
        albumDetailVC?.comeBack()
    }
}
