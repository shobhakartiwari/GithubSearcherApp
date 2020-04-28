//
//  UsersViewModel.swift
//  GitHubSearcher
//
//  Created by Philip Twal on 4/18/20.
//  Copyright © 2020 Philip Altwal. All rights reserved.
//

import Foundation


class UsersViewModel{
    
    typealias UserModelWebServiceComplition = ([UserItems]?,Error?) -> Void
    typealias UserDetailWebServiceComplitionHandler = (UserDetail?,Error?) -> Void
    typealias UserReposWebServiceComplitionHandler = ([ReposModel]?,Error?) -> Void
    typealias UserRepoSearchWebServiceComplitionHandler = ([Items]?,Error?) -> Void
    
    var currentPage = 1
    var limit = 30
    
    
    var fetchUsers : URLSessionDataTask?
    var fetchReposCount : URLSessionDataTask?
    var fetchRepos : URLSessionDataTask?
    
    
    func APICall(url: String ,complitionHandler : @escaping UserModelWebServiceComplition){

        guard let url = URL(string: url) else {
            print("Error with URL !!")
            return
        }
        
        fetchUsers = APIManager.shared.searchAPICall(url: url) { (item, error) in
            
            if error == nil && item != nil{
                complitionHandler(item,nil)
            }else{
                complitionHandler(nil,error)
            }
        }
        fetchUsers?.resume()
    }
    
    
    
    func userDetailApiCall(url : String, complitionHandler : @escaping UserDetailWebServiceComplitionHandler){
        
        guard let url = URL(string: url) else {
            print("Error with URL !!")
            return
        }
        
        fetchReposCount = APIManager.shared.userDetailApiCall(url: url) { (repos, error) in
            
            if error == nil && repos != nil{
                
                complitionHandler(repos,nil)
            }else {
                complitionHandler(nil,error) 
            }
        }
        fetchReposCount?.resume()
    }
    
    
    
    func userReposApiCall(url: String, complitionHandler : @escaping UserReposWebServiceComplitionHandler){
        
        guard let url = URL(string: url) else {
            print("Error with URL !!")
            return
        }
        
        APIManager.shared.reposApiCall(url: url) { (repos, error) in
            
            if error == nil && repos != nil {
                complitionHandler(repos,nil)
            }else{
                complitionHandler(nil,error)
            }
        }
        fetchRepos?.resume()
    }
    
    
    
    func userReposSearchApiCall(url: String, complitionHandler: @escaping UserRepoSearchWebServiceComplitionHandler){
        
        guard let url = URL(string: url) else {
            print("Error with URL !!")
            return
        }
        
        fetchRepos = APIManager.shared.searchRepoApiCall(url: url, complitionHandler: { (model, error) in
            if error == nil && model != nil{
                complitionHandler(model,nil)
            }else{
                complitionHandler(nil,error)
            }
        })
        fetchRepos?.resume()
    }
    
}
