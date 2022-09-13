//
//  EmailPasswordViewController.swift
//  LogIn
//
//  Created by Felicia Alamorean on 07.09.2022.
//

import UIKit
import FirebaseAuth

class EmailPasswordViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var emailPasswordTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var confirmButtonBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var errorMessage: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
 
    // MARK: - Properties
    
    var userEmail: String?
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupObservers()
    }
    
    // MARK: - IBActions
    
    @IBAction func didTabConfirmButton(_ sender: UIButton) {
        guard let password = emailPasswordTextField.text, let email = userEmail else {
            return
        }
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            if let error = error as? NSError {
                
                self.displayError(withCode: error.code)
            } else {
                self.performSegue(withIdentifier: "showHomePage", sender: self.self)
            }
        }
    }
    
    // MARK: - Methods
    
    func displayError(withCode: Int) {
        errorMessage.isHidden = false
        switch withCode {
        case AuthErrorCode.userNotFound.rawValue:
            errorMessageLabel.text = "Could not find an user with this email"
        case AuthErrorCode.wrongPassword.rawValue:
            errorMessageLabel.text = "Your password is wrong"
        default:
            break
        }
    }
    
    func setupLabel() {
        let regularAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 18)]
        let semiboldAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 18, weight: .semibold)]
        
        let attributedString = NSMutableAttributedString(string: "Enter password for\n", attributes: regularAttributes)
        let semiboldAttrString = NSAttributedString(string: userEmail ?? "", attributes: semiboldAttributes)
        attributedString.append(semiboldAttrString)
        descriptionLabel.attributedText = attributedString
    }
    
    func setupErrorMessage() {
        errorMessage.isHidden = true
        errorMessage.layer.cornerRadius = 12
        errorMessage.backgroundColor = UIColor(red: 0.729, green: 0.003, blue: 0.003, alpha: 1)
    }
    
    func setupErrorMessageLabel() {
        errorMessageLabel.alpha = 1
        errorMessageLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        errorMessageLabel.textColor = .white
    }
    
    func setupDescriptionLabel() {
        descriptionLabel.textColor = UIColor(red: 0.031, green: 0.11, blue: 0.204, alpha: 1)
    }
    
    func setupEmailPasswordTextField() {
        emailPasswordTextField.delegate = self
        emailPasswordTextField.isSecureTextEntry = true
    }
    
    func setupConfirmButton() {
        confirmButton.layer.cornerRadius = 24
        confirmButton.alpha = 0.8
        confirmButton.isEnabled = false
        confirmButton.backgroundColor = UIColor(red: 0.031, green: 0.11, blue: 0.204, alpha: 1)
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    func setupActivityIndicator() {
        activityIndicator.isHidden = true
    }
    
    func setupView() {
        setupErrorMessage()
        setupErrorMessageLabel()
        setupDescriptionLabel()
        setupEmailPasswordTextField()
        setupConfirmButton()
        setupActivityIndicator()
        
        setupLabel()
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            confirmButtonBottomContraint.constant = keyboardSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        confirmButtonBottomContraint.constant = 24
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension EmailPasswordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let password = textField.text {
            confirmButton.alpha = password.count >= 8 ? 1 : 0.8
            confirmButton.isEnabled = password.count >= 8 ? true : false
        }
        if errorMessage.isHidden == false {
            errorMessage.isHidden = true
        }
        return true
    }
}

