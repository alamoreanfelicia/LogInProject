//
//  ViewController.swift
//  LogIn
//
//  Created by Felicia Alamorean on 06.09.2022.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateKeyframes(withDuration: 2, delay: 1) { [weak self] in
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/4) {
                self?.titleLabel.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 1/4, relativeDuration: 1/4) {
                self?.descriptionLabel.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 2/4, relativeDuration: 1/4) {
                self?.loginButton.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 3/4, relativeDuration: 1/4) {
                self?.registerButton.alpha = 1
            }
        }
    }
    
    func setupWelcomeLabel() {
        titleLabel.text = "Welcome"
        titleLabel.font = UIFont.systemFont(ofSize: 42, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.031, green: 0.11, blue: 0.204, alpha: 1)
    }
    
    func setupDescriptionLabel() {
        descriptionLabel.text = "In order to continue, please create an account or login using an existing one"
        descriptionLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        descriptionLabel.textColor = UIColor(red: 0.031, green: 0.11, blue: 0.204, alpha: 1)
    }
    
    func setupLogInButton() {
        loginButton.layer.cornerRadius = 24
        loginButton.backgroundColor = UIColor(red: 0.031, green: 0.11, blue: 0.204, alpha: 1)
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    func setupRegisterButton() {
        registerButton.layer.cornerRadius = 24
        registerButton.backgroundColor = UIColor(red: 0.031, green: 0.11, blue: 0.204, alpha: 1)
        registerButton.setTitle("Register", for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }

    func setupViews() {
        setupWelcomeLabel()
        setupDescriptionLabel()
        setupLogInButton()
        setupRegisterButton()
    }
}

