//
//  Constants.swift
//  GitHubSearcher
//
//  Created by Philip Twal on 4/21/20.
//  Copyright © 2020 Philip Altwal. All rights reserved.
//

import Foundation

enum ApiKeys : String {
    
    case searchEnd = "https://api.github.com/search/users?q="
    case userReposUrl = "https://api.github.com/users/"
    case safariUrl = "https://github.com/"
}

enum EndPionts : String{
    case repos = "/repos"
}

