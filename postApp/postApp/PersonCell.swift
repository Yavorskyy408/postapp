//
//  PersonCell.swift
//  postApp
//
//  Created by Vasyl Yavorskyy on 11/04/2018.
//  Copyright © 2018 Vasyl Yavorskyy. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {
    
    // Callback on button tap
    var onButtonTap: ((_ sender: UIButton)->())?
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func set(user: UserProfile) {
        /// get image from database or cache
        ImageService.getImage(withURL: user.photoURL) { (image) in
            self.userImage.image = image
        }
        userName.text = user.name + " " + user.surname
    }
    
    @IBAction func chatButton(_ sender: UIButton) {
        onButtonTap?(sender)
    }
}
