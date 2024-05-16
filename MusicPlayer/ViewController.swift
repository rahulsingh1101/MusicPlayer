//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Rahul Singh on 15/05/24.
//

import UIKit

class ViewController: UIViewController {
    private let viewmodel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewmodel.checkUserLoginState()
    }
    
}

