//
//  TweetList.swift
//  SimpleTweeterClient
//
//  Created by Darya Markova on 02.04.2018.
//  Copyright © 2018 Darya Markova. All rights reserved.
//

import Foundation

class TweetList {
    static let shared = TweetList(tweets: [])
    
    var tweets: [Tweet]?
    
    private init(tweets: [Tweet]) {
        self.tweets = tweets
    }
}
