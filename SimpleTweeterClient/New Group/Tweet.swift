//
//  Tweet.swift
//  SimpleTweeterClient
//
//  Created by Darya Markova on 25.03.2018.
//  Copyright © 2018 Darya Markova. All rights reserved.
//

import Foundation

struct Tweet: Codable {
    let id: Int64 //id твита
    let createdAt: Date //дата публикации
    let text: String? //текст
    let entities: Entity?
    
    struct Entity: Codable {
        struct Media: Codable {
            let media_url: String?
            let media_url_https: String?
        }
        let media: [Media]?
    }
    
    enum CodingKeys:String, CodingKey {
        case id
        case text
        case entities
        case createdAt = "created_at"
    }
}


