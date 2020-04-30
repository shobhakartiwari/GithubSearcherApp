//
//  UsersViewModel.swift
//  GitHubSearcher
//
//  Created by Philip Twal on 4/18/20.
//  Copyright © 2020 Philip Altwal. All rights reserved.
//

import Foundation


class UsersViewModel{
    
    typealias UserModelWebServiceCompletion = ([UserItems]?,Error?) -> Void
    typealias UserDetailWebServiceCompletionHandler = (UserDetail?,Error?) -> Void
    typealias UserReposWebServiceCompletionHandler = ([ReposModel]?,Error?) -> Void
    typealias UserRepoSearchWebServiceCompletionHandler = ([Items]?,Error?) -> Void
    
    var currentPage = 1
    var limit = 30
    
    var fetchUsers : URLSessionDataTask?
    var fetchReposCount : URLSessionDataTask?
    var fetchRepos : URLSessionDataTask?
    
    // MARK: - function for executing fetch users api call
    func APICall(url: String ,completionHandler : @escaping UserModelWebServiceCompletion){

        guard let url = URL(string: url) else {
            print("Error with URL !!")
            return
        }
        
        fetchUsers = APIManager.shared.searchAPICall(url: url) { (item, error) in
            
            if error == nil && item != nil{
                completionHandler(item,nil)
            }else{
                completionHandler(nil,error)
            }
        }
        fetchUsers?.resume()
    }
    
    
    // MARK: - function for executing fetch user detail api call
    func userDetailApiCall(url : String, completionHandler : @escaping UserDetailWebServiceCompletionHandler){
        
        guard let url = URL(string: url) else {
            print("Error with URL !!")
            return
        }
        
        fetchReposCount = APIManager.shared.userDetailApiCall(url: url) { (repos, error) in
            
            if error == nil && repos != nil{
                
                completionHandler(repos,nil)
            }else {
                completionHandler(nil,error)
            }
        }
        fetchReposCount?.resume()
    }
    
    
    // MARK: - function for executing fetch users repos count api call
    func userReposApiCall(url: String, completionHandler : @escaping UserReposWebServiceCompletionHandler){
        
        guard let url = URL(string: url) else {
            print("Error with URL !!")
            return
        }
        
        APIManager.shared.reposApiCall(url: url) { (repos, error) in
            
            if error == nil && repos != nil {
                completionHandler(repos,nil)
            }else{
                completionHandler(nil,error)
            }
        }
        fetchRepos?.resume()
    }
    
    
    // MARK: - function for executing the user repo search api call
    func userReposSearchApiCall(url: String, completionHandler: @escaping UserRepoSearchWebServiceCompletionHandler){
        
        guard let url = URL(string: url) else {
            print("Error with URL !!")
            return
        }
        
        fetchRepos = APIManager.shared.searchRepoApiCall(url: url, completionHandler: { (model, error) in
            if error == nil && model != nil{
                completionHandler(model,nil)
            }else{
                completionHandler(nil,error)
            }
        })
        fetchRepos?.resume()
    }
}
