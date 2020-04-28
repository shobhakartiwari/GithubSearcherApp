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
    
    typealias UserModelWebServiceCompletionHandler = ([UserItems]?,Error?) -> Void
    typealias UserDetailWebServiceCompletionHandler = (UserDetail?,Error?) -> Void
    typealias UserReposWebServiceCompletionHandler = ([ReposModel]?,Error?) -> Void
    typealias UserRepoSearchWebServiceCompletionHandler = ([Items]?,Error?) -> Void
    
    var userModelArray : [UserItems]?
    var repoModelArray : [Items]?
    
    
    func searchAPICall(url : URL, completionHandler: @escaping UserModelWebServiceCompletionHandler) -> URLSessionDataTask{
        
        userModelArray = nil
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("token bd0684d966201740d6a5e3b04caf711b5fd4d3fc", forHTTPHeaderField: "Authorization")
        
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
                    completionHandler(nil,error)
                }
            }else{
                completionHandler(nil,error)
            }
        }
        return task
        
        
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//
//            if error == nil && data != nil{
//
//                guard let data = data else {return}
//
//                do{
//                    let users = try JSONDecoder().decode(UsersModel.self, from: data)
//                    self.userModelArray = [UserItems]()
//                    for user in users.items{
//                        self.userModelArray?.append(user)
//                    }
//                    completionHandler(self.userModelArray,nil)
//
//                }catch{
//                    print(error.localizedDescription)
//                    completionHandler(nil,error)
//                }
//            }else{
//                print(error!)
//                completionHandler(nil,error)
//            }
//        }
//        return task
    }
    
    
    
    func userDetailApiCall(url: URL, completionHandler : @escaping UserDetailWebServiceCompletionHandler) -> URLSessionDataTask{
        
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("token bd0684d966201740d6a5e3b04caf711b5fd4d3fc", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            
            if error == nil && data != nil{
                
                do{
                    let repos = try JSONDecoder().decode(UserDetail.self, from: data!)
                    completionHandler(repos,nil)
                }catch{
                    completionHandler(nil,error)
                }
            }else{
                completionHandler(nil,error)
            }
        }
        return task
        
        
        
        
        
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//
//            if error == nil && data != nil{
//
//                guard let data = data else {return}
//
//                do{
//                    let repos = try JSONDecoder().decode(UserDetail.self, from: data)
//
//                    completionHandler(repos,nil)
//                }catch{
//                    print(error.localizedDescription)
//                    completionHandler(nil,error)
//                }
//            }else{
//                print(error!)
//                completionHandler(nil,error)
//            }
//        }
//        return task
    }
    
    
    
    func reposApiCall(url : URL, completionHandler : @escaping UserReposWebServiceCompletionHandler){
        
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("token bd0684d966201740d6a5e3b04caf711b5fd4d3fc", forHTTPHeaderField: "Authorization")
        
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
        
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//
//            if error == nil && data != nil{
//
//                guard let data = data else {return}
//
//                do{
//                    let repos = try JSONDecoder().decode([ReposModel].self, from: data)
//                    completionHandler(repos,nil)
//                }catch{
//                    print(error.localizedDescription)
//                    completionHandler(nil,error)
//                }
//            }else{
//                completionHandler(nil,error)
//            }
//        }.resume()
    }
    
    
    
    func searchRepoApiCall(url: URL, completionHandler : @escaping  UserRepoSearchWebServiceCompletionHandler) -> URLSessionDataTask {
        
        self.repoModelArray = nil
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("token bd0684d966201740d6a5e3b04caf711b5fd4d3fc", forHTTPHeaderField: "Authorization")
        
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
        
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//
//            if error == nil && data != nil{
//
//                guard let data = data else {return}
//
//                do{
//                    let repos = try JSONDecoder().decode(RepoSearchModel.self, from: data)
//                    self.repoModelArray = [Items]()
//                    for repo in repos.items{
//                        self.repoModelArray?.append(repo)
//                    }
//                    completionHandler(self.repoModelArray,nil)
//                }catch{
//                    completionHandler(nil,error)
//                }
//
//            }else{
//                completionHandler(nil,error)
//
//            }
//        }
//        return task
    }
}
