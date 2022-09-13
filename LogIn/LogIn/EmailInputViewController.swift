//
//  EmailInputViewViewController.swift
//  LogIn
//
//  Created by Felicia Alamorean on 07.09.2022.
//

import UIKit

class EmailInputViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var emailInputTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextButtonBottomContraint: NSLayoutConstraint!

    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupObservers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPasswordSegueId" {
            if let destinationVC = segue.destination as? EmailPasswordViewController {
                destinationVC.userEmail = emailInputTextField.text
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapNextButton(_ sender: UIButton) {
        performSegue(withIdentifier: "showPasswordSegueId", sender: self)
    }
    
    
    // MARK: - Methods
    
    func isValidEmailAddr(strToValidate: String) -> Bool {
      let emailValidationRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

      let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)

      return emailValidationPredicate.evaluate(with: strToValidate)
    }
    
    func setupEmailInputTextFiled() {
        emailInputTextField.delegate = self
        emailInputTextField.backgroundColor = .white
    }
    
    func setupNextButton() {
        nextButton.layer.cornerRadius = 24
        nextButton.alpha = 0.8
        nextButton.isEnabled = false
        nextButton.backgroundColor = UIColor(red: 0.031, green: 0.11, blue: 0.204, alpha: 1)
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    func setupViews() {
        setupEmailInputTextFiled()
        setupNextButton()
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            nextButtonBottomContraint.constant = keyboardSize.height
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        nextButtonBottomContraint.constant = 24
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}

extension EmailInputViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let email = textField.text {
            nextButton.alpha = isValidEmailAddr(strToValidate: email) ? 1 : 0.8
            nextButton.isEnabled = isValidEmailAddr(strToValidate: email) ? true : false
        }
        return true
    }
}

