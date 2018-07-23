//
//  Constants.swift
//  kakaogram
//
//  Created by UramMyeongbu on 2018. 7. 21..
//  Copyright © 2018년 myeongbu. All rights reserved.
//

import Foundation

struct INSTAGRAM_IOS
{
    static let AUTHURL = "https://api.instagram.com/oauth/authorize/"
    static let APIURL = "https://api.instagram/v1.users"
    static let CLIENTID = "d54cc56c32c142c8857fa6917b87e57d"
    static let CLIENTSECRET = "a4307c4bb8be4bd4b65932c3b4612711"
    static let REDIRECTURL = "http://www.naver.com"
    static var ACCESSTOKEN = ""
    static let SCOPE = "likes+comments+relationships+public_content"
    
    static let SEARCH_TAG = "https://api.instagram.com/v1/tags/%@/media/recent?access_token=%@"
    static let RECENT_MEDIA = "https://api.instagram.com/v1/users/self/media/recent/?access_token=%@"
}
