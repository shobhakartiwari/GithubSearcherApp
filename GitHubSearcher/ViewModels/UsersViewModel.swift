//
//  UsersViewModel.swift
//  GitHubSearcher
//
//  Created by Philip Twal on 4/18/20.
//  Copyright © 2020 Philip Altwal. All rights reserved.
//

import Foundation


class UsersViewModel{
    
    typealias UserModelWebServiceComplition = (UsersModel?,Error?) -> Void
    typealias UserDetailWebServiceComplitionHandler = (UserDetail?,Error?) -> Void
    typealias UserReposWebServiceComplitionHandler = ([ReposModel]?,Error?) -> Void
    
    func APICall(url: String ,complitionHandler : @escaping UserModelWebServiceComplition){

        guard let url = URL(string: url) else {
            print("Error with URL !!")
            return
        }
        
        APIManager.shared.searchAPICall(url: url) { (userModel, error) in
            
            if error == nil && userModel != nil{
                complitionHandler(userModel,nil)
            }else{
                complitionHandler(nil,error)
            }
        }
    }
    
    
    func userDetailApiCall(url : String, complitionHandler : @escaping UserDetailWebServiceComplitionHandler){
        
        guard let url = URL(string: url) else {
            print("Error with URL !!")
            return
        }
        
        APIManager.shared.userDetailApiCall(url: url) { (repos, error) in
            
            if error == nil && repos != nil{
                
                complitionHandler(repos,nil)
            }else {
                complitionHandler(nil,error) 
            }
        }
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
    }
    
}
