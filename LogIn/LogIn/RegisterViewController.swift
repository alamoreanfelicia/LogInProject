//
//  RegisterViewController.swift
//  LogIn
//
//  Created by Felicia Alamorean on 09.09.2022.
//

import UIKit

class RegisterViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var registerNextButton: UIButton!
    @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
    
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupObservers()
    }
    
    // MARK: - Methods
    
    func isValidFirstName() -> Bool {
        return firstNameTextField.text?.isEmpty == false
    }

    func isValidLastName() -> Bool {
        return lastNameTextField.text?.isEmpty == false
    }

    func isValidCompanyName() -> Bool {
        return companyTextField.text?.isEmpty == false
    }
    
    func setupFirstNameTextFiled() {
        firstNameTextField.delegate = self
        firstNameTextField.backgroundColor = .white
    }
    
    func setupLastNameTextFiled() {
        lastNameTextField.delegate = self
        lastNameTextField.backgroundColor = .white
    }
    
    func setupCompanyTextFiled() {
        companyTextField.delegate = self
        companyTextField.backgroundColor = .white
    }
    
    func setupRegisterNextButton() {
        registerNextButton.layer.cornerRadius = 24
        registerNextButton.alpha = 0.8
        registerNextButton.isEnabled = false
        registerNextButton.backgroundColor = UIColor(red: 0.031, green: 0.11, blue: 0.204, alpha: 1)
        registerNextButton.setTitle("Next", for: .normal)
        registerNextButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    func setupViews() {
        setupFirstNameTextFiled()
        setupLastNameTextFiled()
        setupCompanyTextFiled()
        setupRegisterNextButton()
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            nextButtonBottomConstraint.constant = keyboardSize.height
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        nextButtonBottomConstraint.constant = 24
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        registerNextButton.alpha = isValidFirstName() && isValidLastName() && isValidCompanyName() ? 1 : 0.8
        registerNextButton.isEnabled = isValidFirstName() && isValidLastName() && isValidCompanyName() ? true : false
        return true
    }
}
