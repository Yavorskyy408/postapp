//
//  SignUpVC.swift
//  loginApp
//
//  Created by Vasyl Yavorskyy on 27.02.18.
//  Copyright © 2018 Vasyl Yavorskyy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SignUpVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var registrationView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        surnameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        addKeyboardObserver()
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            self.registrationView.frame.origin.y = (view.frame.size.height - keyboardSize.height - registrationView.frame.size.height) / 2 + 45
    }

    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        userImage.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: keyboard method for textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === nameTextField {
            surnameTextField.becomeFirstResponder()
        } else if textField === surnameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField === emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    // MARK: Register new user
    func registrate() {
        guard let userName = nameTextField.text else { return }
        guard let userSurname = surnameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let image = userImage.image else { return }
        
        
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                print("Registration succeed!")
//                self.dismiss(animated: false, completion: nil)
                self.uploadProfileImage(image) { (url) in
                    
                    if url != nil {
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = userName
                        changeRequest?.displayName = userSurname
                        changeRequest?.photoURL = url
                        
                        changeRequest?.commitChanges { error in
                            if error == nil {
                                print("User display name changed!")
                                self.saveProfile(userName: userName, userSurname: userSurname, profileImageURL: url!) { succeed in
                                    if succeed {
                                        self.dismiss(animated: false, completion: nil)
                                    }
                                }
                            }
                        }
                    } else {
                        // error to upload profile inage
                    }
                }
            } else {
                print("Error creating user: \(error!.localizedDescription)")
                self.resetForm()
            }
        }
    }
    
    func resetForm() {
        let alert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.nameTextField.text?.removeAll()
        self.surnameTextField.text?.removeAll()
        self.emailTextField.text?.removeAll()
        self.passwordTextField.text?.removeAll()
    }
    
    func uploadProfileImage(_ image: UIImage, completion: @escaping ((_ url: URL?) -> ()) ) {
        guard let uId = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("users/\(uId)")
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {return}
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if error == nil, metaData != nil {
                if let url = metaData?.downloadURL() {
                    completion(url)
                } else {
                    completion(nil)
                }
                // success
            } else {
                //failed
                completion(nil)
            }
        }
    }
    
    func saveProfile(userName: String, userSurname: String, profileImageURL: URL, completion: @escaping ((_ succeed: Bool) -> ())) {
        
        guard let uId = Auth.auth().currentUser?.uid else { return }
//        print("UserID = \(uId)")
        let databaseRef = Database.database().reference().child("users/profile/\(uId)")
        
        let userOject = [
            "userName": userName,
            "userSurname": userSurname,
            "photoURL": profileImageURL.absoluteString
        ] as [String: Any]
        
        databaseRef.setValue(userOject) { error, ref in
            completion(error == nil)
        }
    }
    
    // MARK: Actions
    @IBAction func dismissPopUp(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func signUp(_ sender: Any) {
        registrate()
    }
    
    @IBAction func changeUserImage(_ sender: Any) {
//        print("changeUserImage")
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
}
