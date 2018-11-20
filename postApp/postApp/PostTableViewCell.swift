//
//  PostTableViewCell.swift
//  loginApp
//
//  Created by Vasyl Yavorskyy on 09.03.18.
//  Copyright © 2018 Vasyl Yavorskyy. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: DesignableImage!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var postTextLable: UILabel!
//    let start = String.Index(encodedOffset: 0)
//    let end = String.Index(encodedOffset: 100)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func set(post: Post) {
        /// convert timestamp to date
        let date = Date(timeIntervalSince1970: post.timestamp / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let stringDate = dateFormatter.string(from: date)
        
        /// transmit data to the screen
        usernameLabel.text = post.author.name + " " + post.author.surname
        postTextLable.text = post.text
        postTextLable.numberOfLines = 2
        timeLabel.text = String(stringDate)
        
        /// get image from database or cache
        ImageService.getImage(withURL: post.author.photoURL) { (image) in
            self.profileImage.image = image
        }
    }
}
