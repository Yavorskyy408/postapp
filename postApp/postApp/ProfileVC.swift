//
//  ProfileVC.swift
//  postApp
//
//  Created by Vasyl Yavorskyy on 13/04/2018.
//  Copyright © 2018 Vasyl Yavorskyy. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    
    var name: String?
    var surname: String?
    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.setBottomLine(borderColor: .white)
        surnameField.setBottomLine(borderColor: .white)
        nameField.isUserInteractionEnabled = false
        surnameField.isUserInteractionEnabled = false
        nameField.text = name
        surnameField.text = surname
        userImage.image = image
    }
    
    func set(user: UserProfile) {
        name = user.name
        surname = user.surname
        /// get image from database or cache
        ImageService.getImage(withURL: user.photoURL) { (image) in
            self.image = image
        }
    }
    
    func currentUser() {
        guard let userProfile = UserService.currentUserProfile else { return }
        name = userProfile.name
        surname = userProfile.surname
        ImageService.getImage(withURL: userProfile.photoURL) { (image) in
            self.image = image
        }
    }
    
    @IBAction func profileButton(_ sender: UIButton) {
        print("cancle")
        self.dismiss(animated: true, completion: nil)
    }
}

extension UITextField {
    
    func setBottomLine(borderColor: UIColor) {
        
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        
        let borderLine = UIView()
        let height = 1.0
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - height, width: Double(self.frame.width), height: height)
        
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
}
