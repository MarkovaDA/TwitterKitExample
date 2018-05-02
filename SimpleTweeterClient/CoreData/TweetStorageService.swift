//
//  TweetStorageService.swift
//  SimpleTweeterClient
//
//  Created by Darya Markova on 09.04.2018.
//  Copyright © 2018 Darya Markova. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class TweetStorageService {
    static let shared = TweetStorageService()
    private let context: NSManagedObjectContext;
    private var tweets: [TweetEntity] = []
    private let tweetFetchRequest: NSFetchRequest<TweetEntity>;
    private init() {
        //инициализация локального хранилища базы данных
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        self.tweetFetchRequest = NSFetchRequest<TweetEntity>(entityName: "TweetEntity")
        do {
          self.tweets = try context.fetch(self.tweetFetchRequest)
        } catch let error as NSError {
            print("\(error)", "\(error.userInfo)")
        }
    }
    
    //получить список твитов из БД
    func getTweets() -> [Tweet] {
        //извлекаем твиты из базы данных
        var fetchedTweets: [Tweet] = []
        if !tweets.isEmpty {
            for tweet in tweets {
                var currentTweet = Tweet(id:tweet.id,
                                         idStr: String(tweet.id),
                                         createdAt: tweet.date! as Date,
                                         fullText:tweet.text,
                                         extendedEntities: nil,
                                         favouriteCount: tweet.favourite_count)
                if (tweet.images != nil) {
                    currentTweet.extendedEntities = Tweet.Entity(media: [])
                    for image in tweet.images! {
                        if let img = image as? ImageEntity {
                            let media = Tweet.Entity.Media(media_url: img.url, media_url_https: img.url, id: img.id);
                            currentTweet.extendedEntities?.media?.append(media)
                        }
                    }
                }
                fetchedTweets.append(currentTweet)
            }
        }
        return fetchedTweets
    }
    
    //сохранить твиты 
    func saveTweets(tweets: [Tweet]) {
        let tweetEntity = NSEntityDescription.entity(forEntityName: "TweetEntity", in: context)!
        let imageEntity = NSEntityDescription.entity(forEntityName: "ImageEntity", in: context)!
        for tweet in tweets {
            if (self.tweets.contains(where: { (tItem) -> Bool in tItem.id == tweet.id})) {
                //код, который обеспечивает сохранение
                print("tweet with id \(tweet.id) ALREADY SAVED")
                continue
            } else {
                print("tweet with id \(tweet.id) IS SAVED NOW")
                let savedTweet = TweetEntity(entity: tweetEntity, insertInto: context)
                 savedTweet.id = tweet.id
                 savedTweet.text = tweet.fullText
                 savedTweet.favourite_count = tweet.favouriteCount
                 savedTweet.date = tweet.createdAt as NSDate
                 if (tweet.extendedEntities != nil) {
                     for media in (tweet.extendedEntities?.media)! {
                         let tweetImage = ImageEntity(entity: imageEntity, insertInto: context)
                         tweetImage.url = media.media_url_https
                         tweetImage.id = media.id
                         tweetImage.tweet = savedTweet
                         //добавляем изображение к твиту
                         savedTweet.addToImages(tweetImage)
                     }
               }
            }
        }
        try! context.save()
    }
    func clearData() {
        let deleteTweetRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "TweetEntity"))
        try! context.execute(deleteTweetRequest)
    }
    
    //сохранить пользователя
    func saveUserInfo(user: User) {
        let userEntity = NSEntityDescription.entity(forEntityName: "UserEntity", in: context)!
        let savedUser = UserEntity(entity: userEntity, insertInto: context)
        savedUser.name = user.name
        savedUser.screen_name = user.screenName
        savedUser.followers_count = user.followersCount
        savedUser.friends_count = user.friendsCount
        savedUser.created_at = user.createdAt as NSDate
        try! context.save()
    }
    //извлечь информацию о пользователе
    func getUserInfo(currentUserId: Int64) -> User? {
        let userFetchRequest: NSFetchRequest<UserEntity> =
            NSFetchRequest<UserEntity>(entityName: "UserEntity");
        let users: [UserEntity] = try! context.fetch(userFetchRequest)
        if (!users.isEmpty) {
            //возвращаем информацию о текущем зарегистрированном пользователе
            let fetchedUser  = users.filter({ (user) -> Bool in
                user.id == currentUserId
            }).first
            if fetchedUser != nil {
                return User(id: 123, idStr: "",
                            createdAt: fetchedUser?.created_at as! Date,
                            name: fetchedUser!.name,
                            screenName: fetchedUser!.screen_name,
                            location: "",
                            friendsCount: fetchedUser!.friends_count,
                            followersCount: fetchedUser!.followers_count)
            }
        }
        return nil
    }
}
