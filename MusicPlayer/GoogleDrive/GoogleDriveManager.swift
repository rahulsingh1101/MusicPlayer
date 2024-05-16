//
//  GoogleDriveManager.swift
//  MusicPlayer
//
//  Created by Rahul Singh on 15/05/24.
//

import Foundation
import GoogleAPIClientForREST
import GTMSessionFetcher
import CodableDataModel
import NetworkModule

class GoogleDriveManager {
    static let shared = GoogleDriveManager()
    private let service = GTLRDriveService()
    var access_token: String?
    
    private init() { }
    
    func fetchFilesFromDrive() {
        guard let accessToken = access_token else {
            print("Access token not available")
            return
        }
        let header = ["Authorization": "Bearer \(accessToken)"]
        let getRequest = GetRequest<DriveModel>(url: URL(string: Endpoints().retrieve_all_files)!, headers: header)
        let apiClient = NetworkClient()
        apiClient.performRequest(getRequest) { result in
            switch result {
            case .success(let response):
                print("GET request succeeded with response: \(response)")
            case .failure(let error):
                print("GET request failed with error: \(error)")
            }
        }
    }
}
