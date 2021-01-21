//
//  AlbumDetailTableViewController.swift
//  iMusic
//
//  Created by Тимур Мусаханов on 16.01.2021.
//

import UIKit

class AlbumDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.layer.cornerRadius = 5
            setShadow(shadowView)
        }
    }
    @IBOutlet weak var albumImageView: UIImageView! {
        didSet {
            albumImageView.contentMode = .scaleAspectFill
            albumImageView.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var albumReleaseLabel: UILabel!
    var album: Album?
    private var footerView = FooterView()
    private var tracks: [TrackData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = footerView
        footerView.showLoader()
        configureView(album)
        loadTracks(album)
    }
    
    private func configureView(_ album: Album?) {
        guard let album = album else { return }
        albumNameLabel.text = album.collectionName
        let year = getYear(album.releaseDate)
        albumReleaseLabel.text = "\(album.primaryGenreName ?? "") - \(year)"
        
//        alternative way
//        DispatchQueue.global().async {
//            guard let stringImage = album.artworkUrl100 else { return }
//            guard let imageUrl = URL(string: stringImage) else { return }
//            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
//
//            DispatchQueue.main.async {
//                self.albumImageView.image = UIImage(data: imageData)
//            }
//        }
        
        guard let stringImage = album.artworkUrl100 else { return }
        guard let imageUrl = URL(string: stringImage) else { return }
        albumImageView.sd_setImage(with: imageUrl)
    }
    
    func comeBack() {
        navigationController?.popViewController(animated: false)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath)

        if indexPath.row == 0 {
            cell.textLabel?.text = ""
        } else {
            let track = tracks[indexPath.row]
            cell.textLabel?.text = "\(indexPath.row). \(track.trackName ?? "")"
        }

        return cell
    }
    
    deinit {
        print("deinit - \(AlbumDetailTableViewController.self)")
    }

}

// MARK: - loadTracks
extension AlbumDetailTableViewController {
    private func loadTracks(_ album: Album?) {
        guard let id = album?.collectionId else { return }
        ClientManager.sharedInstance.getTrack(collectionId: id) { [weak self] (tracks) in
            guard let tracks = tracks else { return }
            self?.footerView.hideLoader()
            self?.tracks = tracks
            self?.tableView.reloadData()
        } onError: { [weak self] (error) in
            self?.presentErrorAlertController(withTitle: error)
            self?.footerView.hideLoader()
        }

    }
}
