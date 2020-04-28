//
//  APIManager.swift
//  GitHubSearcher
//
//  Created by Philip Twal on 4/18/20.
//  Copyright © 2020 Philip Altwal. All rights reserved.
//

import Foundation

class APIManager {
    
    static let shared = APIManager()
    private init(){}
    
    typealias UserModelWebServiceComplitionHandler = ([UserItems]?,Error?) -> Void
    typealias UserDetailWebServiceComplitionHandler = (UserDetail?,Error?) -> Void
    typealias UserReposWebServiceComplitionHandler = ([ReposModel]?,Error?) -> Void
    typealias UserRepoSearchWebServiceComplitionHandler = ([Items]?,Error?) -> Void
    
    var userModelArray : [UserItems]?
    var repoModelArray : [Items]?
    
    
    func searchAPICall(url : URL, complitionHandler: @escaping UserModelWebServiceComplitionHandler) -> URLSessionDataTask{
        userModelArray = nil
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error == nil && data != nil{
                
                guard let data = data else {return}
                
                do{
                    let users = try JSONDecoder().decode(UsersModel.self, from: data)
                    self.userModelArray = [UserItems]()
                    for user in users.items{
                        self.userModelArray?.append(user)
                    }
                    complitionHandler(self.userModelArray,nil)
                    
                }catch{
                    print(error.localizedDescription)
                    complitionHandler(nil,error)
                }
            }else{
                print(error!)
                complitionHandler(nil,error)
            }
        }
        return task
    }
    
    
    
    func userDetailApiCall(url: URL, complitionHandler : @escaping UserDetailWebServiceComplitionHandler) -> URLSessionDataTask{
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error == nil && data != nil{
                
                guard let data = data else {return}
                
                do{
                    let repos = try JSONDecoder().decode(UserDetail.self, from: data)
                   
                    complitionHandler(repos,nil)
                }catch{
                    print(error.localizedDescription)
                    complitionHandler(nil,error)
                }
            }else{
                print(error!)
                complitionHandler(nil,error)
            }
        }
        return task
    }
    
    
    
    func reposApiCall(url : URL, ComplitionHandler : @escaping UserReposWebServiceComplitionHandler){
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error == nil && data != nil{
                
                guard let data = data else {return}
                
                do{
                    let repos = try JSONDecoder().decode([ReposModel].self, from: data)
                    ComplitionHandler(repos,nil)
                }catch{
                    print(error.localizedDescription)
                    ComplitionHandler(nil,error)
                }
            }else{
                ComplitionHandler(nil,error)
            }
        }.resume()
    }
    
    
    
    func searchRepoApiCall(url: URL, complitionHandler : @escaping  UserRepoSearchWebServiceComplitionHandler) -> URLSessionDataTask {
        
        self.repoModelArray = nil
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error == nil && data != nil{
                
                guard let data = data else {return}
                
                do{
                    let repos = try JSONDecoder().decode(RepoSearchModel.self, from: data)
                    self.repoModelArray = [Items]()
                    for repo in repos.items{
                        self.repoModelArray?.append(repo)
                    }
                    complitionHandler(self.repoModelArray,nil)
                }catch{
                    complitionHandler(nil,error)
                }
                
            }else{
                complitionHandler(nil,error)
    
            }
        }
        return task
    }
}
