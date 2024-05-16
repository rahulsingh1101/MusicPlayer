//
//  LoginViewModel.swift
//  MusicPlayer
//
//  Created by Rahul Singh on 17/05/24.
//

import Foundation
import GoogleSignIn

final class LoginViewModel {
    func checkUserLoginState() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            let access_token = user?.accessToken.tokenString
            GoogleDriveManager.shared.access_token = access_token
            if error != nil {
                // Show the app's signed-out state.
                self.showLoginScreen()
            } else if user == nil {
                self.showLoginScreen()
            } else {
                self.promptDrivePermission(user: user)
            }
        }
    }
    
    private func showLoginScreen() {
        let loginViewController = LoginController()
        loginViewController.isModalInPresentation = true
        if let controller = AppDelegate.getTopController() {
            controller.present(loginViewController, animated: true)
        }
    }
    
    fileprivate func promptDrivePermission(user: GIDGoogleUser?) {
        let driveScope = "https://www.googleapis.com/auth/drive.readonly"
        let grantedScopes = user?.grantedScopes
        if grantedScopes == nil || !grantedScopes!.contains(driveScope) {
            // Request additional Drive scope.
            let additionalScopes = ["https://www.googleapis.com/auth/drive.readonly"]
            guard let currentUser = GIDSignIn.sharedInstance.currentUser else {
                return
            }
            
            if let vc = AppDelegate.getTopController() {
                currentUser.addScopes(additionalScopes, presenting: vc) { signInResult, error in
                    // Check if the user granted access to the scopes you requested.
                    if let error {
                        print("debug :: addScopes error ::\(error)")
                    } else if signInResult != nil {
                        self.showHomeScreen()
                    }
                }
            }
        } else {
            showHomeScreen()
        }
    }
    
    private func showHomeScreen() {
        let homeViewController = HomeViewController() // Replace with your home view controller
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.navigationBar.isHidden = false // Show navigation bar if needed
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        keyWindow?.rootViewController = navigationController
        keyWindow?.makeKeyAndVisible()
    }
}
