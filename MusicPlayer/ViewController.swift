//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Rahul Singh on 15/05/24.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now()+4) {
            print("debug :: drive read executed")
            executeTasks()
        }
    }

    @objc private func signInButtonTapped(sender: UIControl) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            if let error {
                print("debug :: login error ::\(error)")
            } else {
                let user = signInResult?.user
            }
        }
    }
}

