//
//  UserSearchTableViewCell.swift
//  SimpleTweeterClient
//
//  Created by Darya Markova on 23.03.2018.
//  Copyright © 2018 Darya Markova. All rights reserved.
//

import UIKit

class UserSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
