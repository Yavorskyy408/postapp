//
//  MyMessageCell.swift
//  postApp
//
//  Created by Vasyl Yavorskyy on 20/04/2018.
//  Copyright © 2018 Vasyl Yavorskyy. All rights reserved.
//

import UIKit

class MyMessageCell: UITableViewCell {

    
    @IBOutlet weak var imageViewMessage: UIImageView!
    @IBOutlet weak var bubleView: DesignableView!
    @IBOutlet weak var txtLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageViewMessage.tintColor = UIColor(red: 0/255, green: 150/255, blue: 255/255, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(message: Message) {
        /// convert timestamp to date
        let date = Date(timeIntervalSince1970: message.timestamp / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let stringDate = dateFormatter.string(from: date)
        
        txtLabel.text = message.text
        timeLabel.text = stringDate
    }
}
