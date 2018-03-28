//
//  ImageTableViewCell.swift
//  SimpleTweeterClient
//
//  Created by Darya Markova on 28.03.2018.
//  Copyright © 2018 Darya Markova. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
