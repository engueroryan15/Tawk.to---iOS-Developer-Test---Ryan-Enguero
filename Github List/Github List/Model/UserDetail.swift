//
//  UserDetail.swift
//  Github List
//
//  Created by Ryan Enguero on 3/28/21.
//

import Foundation

struct UserDetail: Codable
{
   var bio: String?
   var blog: String?
   var company: String?
   var created_at: String?
   var email: String?
   var followers: Int16
   var following: Int16
   var hireable: String?
   var id: Int16
   var location: String?
   var name: String?
   var public_gists: Int16
   var public_repos: Int16
   var twitter_username: String?
   var updated_at: String?
    
    
    enum CodingKeys: String, CodingKey {
        
        case bio = "bio"
        case blog = "blog"
        case company = "company"
        case created_at = "created_at"
        case email = "email"
        case followers
        case following
        case hireable = "hireable"
        case id
        case location = "location"
        case name = "name"
        case public_gists
        case public_repos
        case twitter_username = "twitter_username"
        case updated_at = "updated_at"
    }
    
}

