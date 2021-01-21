//
//  HistoryTableViewController.swift
//  iMusic
//
//  Created by Тимур Мусаханов on 16.01.2021.
//

import UIKit
import CoreData

class HistoryTableViewController: UITableViewController {
    
    private var searchHistoryArray: [String] = []
    
//    for CoreData operation
//    private var searchHistoryArray: [History] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getSearchHistoryToUserDefaults()
        
//        for CoreData operation
//        getSearchHistoryToCoreData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "historyCell")
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)

        let history = searchHistoryArray[indexPath.row]
        cell.textLabel?.text = history
        
//        for CoreData operation
//        cell.textLabel?.text = history.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        for CoreData operation
//        guard let searchText = searchHistoryArray[indexPath.row].title else { return }
//        let searchData = ["searchText": searchText]
        
        let searchData = ["searchText": searchHistoryArray[indexPath.row]]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "searchAlbum"),
                                        object: nil,
                                        userInfo: searchData)
        tabBarController?.selectedIndex = 0
    }
}

// MARK: - getSearchHistory
extension HistoryTableViewController {
    private func getSearchHistoryToUserDefaults() {
        if let history  = UserDefaults.standard.object(forKey: "searchHistory") as? [String] {
            searchHistoryArray = history
            tableView.reloadData()
        }
    }
    
//    for CoreData operation
//    private func getContext() -> NSManagedObjectContext {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        return appDelegate.persistentContainer.viewContext
//    }
//
//    private func getSearchHistoryToCoreData() {
//        let context = getContext()
//        let fetchRequest: NSFetchRequest<History> = History.fetchRequest()
//
//        do {
//            searchHistoryArray = try context.fetch(fetchRequest)
//            searchHistoryArray.reverse()
//            tableView.reloadData()
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//    }
}
