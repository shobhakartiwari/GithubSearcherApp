//
//  APIManager.swift
//  GitHubSearcher
//
//  Created by Philip Twal on 4/18/20.
//  Copyright © 2020 Philip Altwal. All rights reserved.
//

import Foundation

/// Addded updated token to make the application functional
enum Token : String{
    case tokenKey = "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"
}


class APIManager {
    
    static let shared = APIManager()
    private init(){}
    
    typealias UserModelWebServiceCompletionHandler = ([UserItems]?,Error?) -> Void
    typealias UserDetailWebServiceCompletionHandler = (UserDetail?,Error?) -> Void
    typealias UserReposWebServiceCompletionHandler = ([ReposModel]?,Error?) -> Void
    typealias UserRepoSearchWebServiceCompletionHandler = ([Items]?,Error?) -> Void
    
    var userModelArray : [UserItems]?
    var repoModelArray : [Items]?
    
    //MARK:- Web service for fetching users and their avatars
    func searchAPICall(url : URL, completionHandler: @escaping UserModelWebServiceCompletionHandler) -> URLSessionDataTask{
        
        userModelArray = nil
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("token \(Token.tokenKey.rawValue)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if error == nil && data != nil{
                
                do{
                    let users = try JSONDecoder().decode(UsersModel.self, from: data!)
                    self.userModelArray = [UserItems]()
                    for user in users.items{
                        self.userModelArray?.append(user)
                    }
                    completionHandler(self.userModelArray,nil)
                }catch{
                    print(error.localizedDescription)
                    completionHandler(nil,error)
                }
            }else{
                completionHandler(nil,error)
            }
        }
        return task
    }
    
    
    //MARK: -Web service for fetching a single user detail and for repos count to be displayed in view controller table view
    func userDetailApiCall(url: URL, completionHandler : @escaping UserDetailWebServiceCompletionHandler) -> URLSessionDataTask{
        
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("token \(Token.tokenKey.rawValue)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            
            if error == nil && data != nil{
                
                do{
                    let userDetail = try JSONDecoder().decode(UserDetail.self, from: data!)
                    completionHandler(userDetail,nil)
                }catch{
                    completionHandler(nil,error)
                }
            }else{
                completionHandler(nil,error)
            }
        }
        return task
    }
    
    
    //MARK:- Web service for fetching the user repos to be displayed in the Detail View Controller
    func reposApiCall(url : URL, completionHandler : @escaping UserReposWebServiceCompletionHandler){
        
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("token \(Token.tokenKey.rawValue)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            
            if error == nil && data != nil{
                
                do{
                    let repos = try JSONDecoder().decode([ReposModel].self, from: data!)
                    completionHandler(repos,nil)
                }catch{
                    completionHandler(nil,error)
                }
            }else{
                completionHandler(nil,error)
            }
            
        }.resume()
    }
    
    
    //MARK:- Web service is called when searching for the user repos
    func searchRepoApiCall(url: URL, completionHandler : @escaping  UserRepoSearchWebServiceCompletionHandler) -> URLSessionDataTask {
        
        self.repoModelArray = nil
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("token \(Token.tokenKey.rawValue)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            
            if error == nil && data != nil{
                
                do{
                    let repos = try JSONDecoder().decode(RepoSearchModel.self, from: data!)
                    self.repoModelArray = [Items]()
                    for repo in repos.items{
                        self.repoModelArray?.append(repo)
                    }
                    completionHandler(self.repoModelArray,nil)
                }catch{
                    completionHandler(nil,error)
                }
            }else{
                completionHandler(nil,error)
            }
        }
        return task
    }
}
