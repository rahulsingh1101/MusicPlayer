//
//  HomeVieweModel.swift
//  MusicPlayer
//
//  Created by Rahul Singh on 16/05/24.
//

import Foundation
import CodableDataModel
import GoogleSignIn

struct Item {
    let mimeType: String
    let name: String
}

protocol ItemsViewModelDelegate: AnyObject {
    func updateUI()
}

class ItemsViewModel {
    private var items: [Item] = []
    weak var delegate: ItemsViewModelDelegate?

    init() {
        // Fetch items from API or any other data source
        // For simplicity, let's add some dummy data
        validateData()
    }
    
    private func validateData() {
        if items.isEmpty {
            // call Drive API
            GoogleDriveManager.shared.fetchFilesFromDrive { [weak self] result in
                guard let self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let success):
                        let files = success.files
                        self.items = files.compactMap({ files in
                            Item(mimeType: files.mimeType, name: files.name)
                        })
                        if GoogleDriveManager.shared.access_token != nil {
                            self.items.append(.init(mimeType: "logout", name: "Logout"))
                        }
                        self.delegate?.updateUI()
                    case .failure(let failure):
                        print("debug :: view model error ::\(failure)")
                    }
                }
            }
        }
    }

    func numberOfItems() -> Int {
        return items.count
    }

    func item(at index: Int) -> Item {
        return items[index]
    }
    
    func itemSelected(at index: IndexPath) {
        let item = items[index.row]
        if item.mimeType == "logout" {
            GIDSignIn.sharedInstance.signOut()
            showLoginScreen()
        }
    }
    
    private func showLoginScreen() {
        let loginViewController = LoginController()
        loginViewController.isModalInPresentation = true
        if let controller = AppDelegate.getTopController() {
            controller.present(loginViewController, animated: true)
        }
    }
}
