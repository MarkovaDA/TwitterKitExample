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
    let API_URL = "https://api.twitter.com/1.1/"
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
        let tweetFetchUrl = "\(self.API_URL)statuses/user_timeline.json"
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
                let tweets = try! self.getJsonDecoder().decode([Tweet].self, from: data!)
                success(tweets)
            }
        }
    }
    //загрузить твит
    func uploadTweet(text: String,
                     success: @escaping (TWTRTweet?) -> (), failure: @escaping (Error?) -> ()) {
        if let userId = self.getCurrentUserId() {
            let userClient = TWTRAPIClient(userID: userId)
            userClient.sendTweet(withText: text) { (tweet, error) in
                if error != nil {
                    failure(error)
                } else {
                    success(tweet)
                }
            }
        }
    }
    
    //загрузить твит с изображением
    func uploadTweetWithImage(text: String, image: UIImage,
                     success: @escaping (TWTRTweet?) -> (), failure: @escaping (Error?) -> ()) {
        if let userId = self.getCurrentUserId() {
            let userClient = TWTRAPIClient(userID: userId)
            userClient.sendTweet(withText: text, image: image) { (tweet, error) in
                if error != nil {
                    failure(error)
                } else {
                    success(tweet)
                }
            }
        }
    }
    
    func getCurrentUserProfile(success: @escaping (User) -> (), failure: @escaping (Error?) -> ()) {
        if let userId = self.getCurrentUserId() {
            let userClient = TWTRAPIClient(userID: userId)
            let profileFetchUrl = "\(self.API_URL)/users/show.json"
            let params = ["user_id": userId, "include_entities": "0"]
            let request = userClient.urlRequest(withMethod: "GET", urlString: profileFetchUrl, parameters: params, error: nil)
            userClient.sendTwitterRequest(request, completion: { (response, data, error) in
                if error != nil {
                    failure(error)
                } else {
                    let profile = try! self.getJsonDecoder().decode(User.self, from: data!)
                    success(profile)
                }
            })
        }
    }
    
    func uploadImage(url: String, success: @escaping (UIImage) -> (), failure: @escaping (Error) -> ()) {
        let imageUrl = URL(string: url)
        let loadImageTask = URLSession.shared.dataTask(with: imageUrl!) {
            (data, response, error) in
            if error != nil {
                failure(error!)
            }
            else if data != nil {
                let image = UIImage(data: data!)
                success(image!)
            }
        }
        loadImageTask.resume()
    }
    
    private func getJsonDecoder() ->  JSONDecoder {
        let formatter = DateFormatter()
        formatter.dateFormat = "E M dd HH:mm:ss +zzzz yyyy"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }
    
    private init() {}
    
}
