//
//  ClientManager.swift
//  iMusic
//
//  Created by Тимур Мусаханов on 16.01.2021.
//

import Foundation
import Alamofire

class ClientManager {
    
    public class var sharedInstance: ClientManager {
        struct Singleton {
            static let instance : ClientManager = ClientManager()
        }
        return Singleton.instance
    }
    
    // MARK: - getAlbum
    func getAlbum(searchText: String,
                  onSuccess: (([Album]?) -> Void)? = nil,
                  onError: ((String) -> Void)? = nil) {
        
        guard let url = URL(string: "https://itunes.apple.com/search") else { return }
        let parameters: [String: Any] = [
            "term": "\(searchText)",
            "entity": "album",
            "limit": "30"
        ]
        
        AF.request(url, method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default).validate().responseJSON { (dataResponse) in
                    switch dataResponse.result {
                    case .success:
                        guard let data = dataResponse.data else { return }
                        guard let albums = try? SearchResponse.decode(from: data) else { return }
                        onSuccess?(albums.results)
                    case .failure(let error):
                        guard let errorMessage = ErrorResponse.sharedInstance.receiveError(error) else { return }
                        onError?(errorMessage)
                    }
                   }
    }
    
    // MARK: - getTrack
    func getTrack(collectionId: Int,
                  onSuccess: (([TrackData]?) -> Void)? = nil,
                  onError: ((String) -> Void)? = nil) {
        
        guard let url = URL(string: "https://itunes.apple.com/lookup") else { return }
        let parameters: [String: Any] = [
            "id": collectionId,
            "entity": "song"
        ]
        
        AF.request(url, method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default).validate().responseJSON { (dataResponse) in
                    switch dataResponse.result {
                    case .success:
                        guard let data = dataResponse.data else { return }
                        guard let tracks = try? Track.decode(from: data) else { return }
                        onSuccess?(tracks.results)
                    case .failure(let error):
                        guard let errorMessage = ErrorResponse.sharedInstance.receiveError(error) else { return }
                        onError?(errorMessage)
                    }
                   }
    }
    
}
