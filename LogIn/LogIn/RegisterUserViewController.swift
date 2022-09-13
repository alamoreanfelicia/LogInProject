//
//  RegisterUserViewController.swift
//  LogIn
//
//  Created by Felicia Alamorean on 12.09.2022.
//

import UIKit
import FirebaseAuth

class RegisterUserViewController: UIViewController {
    
    // MARK: - IBOutlets


    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var registerUserButton: UIButton!
    @IBOutlet weak var registerButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var registerActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var registerErrorMessage: UIView!
    @IBOutlet weak var registerErrorMessageLabel: UILabel!
    
    // MARK: - IBActions
    
    @IBAction func didTabRegisterButton(_ sender: UIButton) {
        guard let password = passwordTextField.text, let email = emailTextField.text else {
            return
        }
        
        registerActivityIndicator.startAnimating()
        registerActivityIndicator.isHidden = false
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            self.registerActivityIndicator.stopAnimating()
            self.registerActivityIndicator.isHidden = true
            if let error = error as? NSError {
                self.displayError(withCode: error.code)
            } else {
                self.performSegue(withIdentifier: "showHomePageFromRegister", sender: self.self)
            }
        }
    }
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupObservers()
        setupViews()
    }
    
    // MARK: - Methods
    
    func displayError(withCode: Int) {
        registerErrorMessage.isHidden = false
        switch withCode {
        case AuthErrorCode.invalidEmail.rawValue:
            registerErrorMessageLabel.text = "Your email is invalid"
        case AuthErrorCode.wrongPassword.rawValue:
            registerErrorMessageLabel.text = "Your password is invalid"
        case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
            registerErrorMessageLabel.text = "Your account is already registred"
        default:
            break
        }
    }
    
    func isValidEmailAddr(strToValidate: String) -> Bool {
      let emailValidationRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

      let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)

      return emailValidationPredicate.evaluate(with: strToValidate)
    }
    
    func isValidEmail() -> Bool {
        return emailTextField.text?.isEmpty == false
    }

    func isValidPassword() -> Bool {
        return passwordTextField.text?.isEmpty == false
    }
    
    func isValidConfirmPassword(emailString: String, passwordString: String, confirmPasswordString: String) -> Bool {
        let emailString = isValidEmailAddr(strToValidate: emailTextField.text ?? "")
        let isPassowordValid = passwordString.count >= 8
        let isConfirmValid = passwordString == confirmPasswordString
        return emailString && isPassowordValid && isConfirmValid
    }
    
    func setupRegisterErrorMessage() {
        registerErrorMessage.isHidden = true
        registerErrorMessage.layer.cornerRadius = 12
        registerErrorMessage.backgroundColor = UIColor(red: 0.729, green: 0.003, blue: 0.003, alpha: 1)
    }
    
    func setupRegisterErrorMessageLabel() {
        registerErrorMessageLabel.alpha = 1
        registerErrorMessageLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        registerErrorMessageLabel.textColor = .white
    }

    func setupEmailTextFiled() {
        emailTextField.delegate = self
        emailTextField.backgroundColor = .white
    }
    
    func setupPasswordFiled() {
        passwordTextField.delegate = self
        passwordTextField.backgroundColor = .white
    }
    
    func setupConfirmPasswordTextFiled() {
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.backgroundColor = .white
    }
    
    func setupUserRegisterNextButton() {
        registerUserButton.layer.cornerRadius = 24
        registerUserButton.alpha = 0.8
        registerUserButton.isEnabled = false
        registerUserButton.backgroundColor = UIColor(red: 0.031, green: 0.11, blue: 0.204, alpha: 1)
        registerUserButton.setTitle("Next", for: .normal)
        registerUserButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    func setupRegisterActivityIndicator() {
        registerActivityIndicator.isHidden = true
    }
    
    func setupViews() {
        setupEmailTextFiled()
        setupPasswordFiled()
        setupConfirmPasswordTextFiled()
        setupUserRegisterNextButton()
        setupRegisterActivityIndicator()
        setupRegisterErrorMessage()
        setupRegisterErrorMessageLabel()
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            registerButtonBottomConstraint.constant = keyboardSize.height
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        registerButtonBottomConstraint.constant = 24
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension RegisterUserViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
//        if let email = emailTextField.text {
//            registerUserButton.alpha = isValidEmailAddr(strToValidate: email) ? 1 : 0.8
//            registerUserButton.isEnabled = isValidEmailAddr(strToValidate: email) ? true : false
//        }
        if registerErrorMessage.isHidden == false {
            registerErrorMessage.isHidden = true
        }
        if textField == emailTextField {
            registerUserButton.alpha = isValidConfirmPassword(emailString: updatedString ?? "", passwordString: passwordTextField.text ?? "", confirmPasswordString: confirmPasswordTextField.text ?? "") ? 1 : 0.8
            registerUserButton.isEnabled = isValidConfirmPassword(emailString: updatedString ?? "", passwordString: passwordTextField.text ?? "", confirmPasswordString: confirmPasswordTextField.text ?? "")
        }
        if textField == passwordTextField {
            registerUserButton.alpha = isValidConfirmPassword(emailString: emailTextField.text ?? "", passwordString: updatedString ?? "", confirmPasswordString: confirmPasswordTextField.text ?? "") ? 1 : 0.8
            registerUserButton.isEnabled = isValidConfirmPassword(emailString: emailTextField.text ?? "", passwordString: updatedString ?? "", confirmPasswordString: confirmPasswordTextField.text ?? "")
        }
        if textField == confirmPasswordTextField {
            registerUserButton.alpha = isValidConfirmPassword(emailString: emailTextField.text ?? "", passwordString: passwordTextField.text ?? "", confirmPasswordString: updatedString ?? "") ? 1 : 0.8
            registerUserButton.isEnabled = isValidConfirmPassword(emailString: emailTextField.text ?? "", passwordString: passwordTextField.text ?? "", confirmPasswordString: updatedString ?? "")
        }
        return true
    }
}
