//
//  UsersModel.swift
//  GitHubSearcher
//
//  Created by Philip Twal on 4/18/20.
//  Copyright © 2020 Philip Altwal. All rights reserved.
//

import Foundation

//MARK: - Users list model
struct UsersModel : Codable {
    var items : [UserItems]
}


struct UserItems : Codable{
    var userName : String
    var avatar : String
    
    private enum CodingKeys : String, CodingKey{
        case userName = "login"
        case avatar = "avatar_url"
    }
}


//MARK: - User detail model
struct UserDetail : Codable{
    
    var name : String?
    var avatar : String?
    var repos : Int?
    var bio : String?
    var email : String?
    var location : String?
    var joiningDate : String?
    var followers : Int?
    var following : Int?
    
    private enum CodingKeys : String, CodingKey{
        case name = "name"
        case avatar = "avatar_url"
        case repos = "public_repos"
        case bio = "bio"
        case email = "email"
        case location = "location"
        case joiningDate = "created_at"
        case followers = "followers"
        case following = "following"
    }
}



//MARK: - User repos Model
struct ReposModel : Codable{
    
    var name : String
    var stars : Int
    var forks : Int
    
    private enum CodingKeys : String, CodingKey{
        case name = "name"
        case stars = "stargazers_count"
        case forks  = "forks_count"
    }
}




//MARK: - User repo search model
struct RepoSearchModel : Codable{
    var items : [Items]
}

struct Items : Codable{
    var name : String
    var stars : Int
    var forks : Int
    
    private enum CodingKeys : String, CodingKey{
        case name = "name"
        case stars = "stargazers_count"
        case forks  = "forks_count"
    }
}
