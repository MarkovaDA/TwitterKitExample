//
//  TweetTableViewCell.swift
//  SimpleTweeterClient
//
//  Created by Darya Markova on 27.03.2018.
//  Copyright © 2018 Darya Markova. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetTextField: UITextView!
    @IBOutlet weak var tweetDateLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var tweetFavouriteCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
