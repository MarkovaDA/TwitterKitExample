//
//  User.swift
//  SimpleTweeterClient
//
//  Created by Darya Markova on 03.04.2018.
//  Copyright © 2018 Darya Markova. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: Int64 //id твита
    let idStr: String
    let createdAt: Date //дата публикации
    let name: String
    let screenName: String
    let location: String
    let friendsCount: Int
    let followersCount: Int
    //let profileImageUrl: String
    
    enum CodingKeys:String, CodingKey {
        case id
        case name
        case location
        case createdAt = "created_at"
        case screenName = "screen_name"
        case idStr = "id_str"
        case friendsCount = "friends_count"
        case followersCount = "followers_count"
        //case profileImageUrl = "profile_image_url_https"
    }
}
