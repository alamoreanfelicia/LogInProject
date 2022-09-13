//
//  HomePageViewController.swift
//  LogIn
//
//  Created by Felicia Alamorean on 08.09.2022.
//

import UIKit
import FirebaseAuth

class HomePageViewController: UIViewController {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var logOutButton: UIButton!
    
    @IBAction func signOutEmail(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            performSegue(withIdentifier: "presentWelcomeScreen", sender: self)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    
    // MARK: - Methods
    
    func setupLogOut() {
        logOutButton.alpha = 0
        logOutButton.layer.cornerRadius = 24
        logOutButton.backgroundColor = UIColor(red: 0.031, green: 0.11, blue: 0.204, alpha: 1)
        logOutButton.setTitle("LogOut", for: .normal)
        logOutButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    func setupView() {
        logOutButton.layer.cornerRadius = 24
    }

}
