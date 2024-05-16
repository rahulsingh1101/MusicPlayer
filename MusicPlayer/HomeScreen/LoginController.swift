//
//  LoginController.swift
//  MusicPlayer
//
//  Created by Rahul Singh on 17/05/24.
//

import UIKit
import GoogleSignIn

final class LoginController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let signInButton = GIDSignInButton()
        signInButton.addTarget(self, action: #selector(signInButtonTapped(sender:)), for: .touchUpInside)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signInButton)
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            signInButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            signInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            signInButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        let signOutButton = UIButton()
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.backgroundColor = .brown
        view.addSubview(signOutButton)
        NSLayoutConstraint.activate([
            signOutButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 30),
            signOutButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            signOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            signOutButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc private func signInButtonTapped(sender: UIControl) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            if let error {
                print("debug :: login error ::\(error)")
            } else {
                let user = signInResult?.user
                GoogleDriveManager.shared.access_token = user?.accessToken.tokenString
                self.dismiss(animated: true) {
                    self.showHomeScreen()
                }
            }
        }
    }
    
    private func userHasGrantedDrivepermission(user: GIDGoogleUser?) -> Bool {
        let driveScope = "https://www.googleapis.com/auth/drive.readonly"
        let grantedScopes = user?.grantedScopes
        if grantedScopes == nil || !grantedScopes!.contains(driveScope) {
            return false
        } else {
            return true
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
