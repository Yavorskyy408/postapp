//
//  SignInVC.swift
//  loginApp
//
//  Created by Vasyl Yavorskyy on 212//18.
//  Copyright © 2018 Vasyl Yavorskyy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SignInVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        addKeyboardObserver()
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        self.loginView.frame.origin.y = (view.frame.size.height - keyboardSize.height - loginView.frame.size.height) / 2 + 45
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField === passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    func logIn() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil && user != nil {
                print("Login success!")
                self.dismiss(animated: false, completion: nil)
            } else {
                print("Error login user: \(error!.localizedDescription)")
                self.resetForm()
            }
        }
    }
    
    func resetForm() {
        let alert = UIAlertController(title: "Error login", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.emailTextField.text?.removeAll()
        self.passwordTextField.text?.removeAll()
    }
    
    @IBAction func dismissPopUp(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func signIn(_ sender: Any) {
        logIn()
    }
}
