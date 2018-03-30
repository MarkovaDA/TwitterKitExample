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
    let client = TWTRAPIClient()
    let store = TWTRTwitter.sharedInstance().sessionStore
    
    static let shared = TwitterApiClient()
    
    func getCurrentUserId() -> String? {
        return self.store.session()?.userID
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
    
    func getHomeTimeline(success: @escaping ([Tweet]?) -> (), failure: @escaping (Error?) -> ()) {
        //let userClient = TWTRAPIClient.init(userID: self.getCurrentUserId());
        let tweetFetchUrl = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        let params = ["user_id": self.getCurrentUserId(), "tweet_mode": "extended"]
        let request = self.client.urlRequest(withMethod: "GET", urlString: tweetFetchUrl, parameters: params, error: nil)
    
        self.client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(String(describing: connectionError))")
                failure(nil)
            } else {
                /*do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    print("JSON: \(json)")
                } catch let jsonError as NSError {
                    print("JSON ERROR: \(jsonError.localizedDescription)")
                }*/
                let formatter = DateFormatter()
                formatter.dateFormat = "E M dd HH:mm:ss +zzzz yyyy"
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(formatter)
                let tweets = try! decoder.decode([Tweet].self, from: data!)
                success(tweets)
            }
        }
    }
    
    func getTweetById(id: String) {
        //запрос, который бы позволил зафетчить все урлы у твита
        self.client.loadTweet(withID: id) { (tweet, error) in
            if error != nil {
                print("ERROR GETTING TWEET")
                print(error)
            } else {
                print("GETTING TWEET")
                print(tweet)
            }
        }
    }
    
    func getProfilePicture() {
        
    }
    
    private init() {}
    
}
