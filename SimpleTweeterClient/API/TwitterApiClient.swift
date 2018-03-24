//
//  TwitterApiClient.swift
//  SimpleTweeterClient
//
//  Created by Darya Markova on 24.03.2018.
//  Copyright © 2018 Darya Markova. All rights reserved.
//

import Foundation
import TwitterKit
import Microfutures
//создать статический класс с методами
//login
//currentUser
//loadUser
//loadTweets
//sendTweet
//logout
class TwitterApiClient {
    //https://github.com/twitter/twitter-kit-ios/wiki/Access-Twitter's-REST-API
    let client = TWTRAPIClient()
    let store = TWTRTwitter.sharedInstance().sessionStore
    
    static let shared = TwitterApiClient()
    
    func getCurrentUserId() -> String? {
        return TWTRTwitter.sharedInstance().sessionStore.session()?.userID
    }
    
    func getCurrentUser(success: @escaping (TWTRUser?) -> (), failure: @escaping (Error?) -> ()) {
        let userId = self.getCurrentUserId()
        if userId == nil {
            return
        }
        self.client.loadUser(withID: userId!) { (user: TWTRUser?, error: Error?) in
            if user != nil {
                success(user)
            } else {
                failure(nil)
            }
        }
    }
    
    func getProfilePicture() {
        
    }
    
    private init() {}
    
}
