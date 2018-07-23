//
//  InstagramData.swift
//  kakaogram
//
//  Created by UramMyeongbu on 2018. 7. 21..
//  Copyright © 2018년 myeongbu. All rights reserved.
//

import Foundation
import ObjectMapper


struct JSONData : Mappable {
    var data : [InstagramData]!
    
    init?(map: Map) {
        data <- map["data"]
    }
    
    mutating func mapping(map: Map) {
        
    }
}

struct InstagramData : Mappable {
    var mediaType : MediaType!
    var tags : [String]!
    var image : Image!
    var carousel_media : [Carousel]!
    var video : Video!
    var caption : Caption?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        mediaType <- (map["type"],EnumTransform<MediaType>())
        tags <- map["tags"]
        image <- map["images"]
        caption <- map["caption"]
        
        switch (mediaType) {
        case .Image :
            break;
        case .Carousel :
            carousel_media <- map["carousel_media"]
        case .Video :
            video <- map["videos"]
        default: break
        
        }
    }
    
}

struct Caption : Mappable {
    var created_time : String!
    var text : String!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        created_time <- map["created_time"]
        text <- map["text"]
    }
}

struct Carousel : Mappable {
    var images : Image!
    var videos : Video!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        images <- map["images"]
        videos <- map["videos"]
    }
}

struct Image : Mappable {
    var url : String!
    var width : NSInteger!
    var height : NSInteger!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        url <- map["thumbnail.url"]
        width <- map["thumbnail.width"]
        height <- map["thumbnail.height"]
    }
}

struct Video : Mappable {
    var url : String!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        url <- map["standard_resolution.url"]
    }
    
}

enum MediaType : String {
    case Image = "image"
    case Video = "video"
    case Carousel = "carousel"
}

