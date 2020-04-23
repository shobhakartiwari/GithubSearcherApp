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
    
    typealias UserModelWebServiceComplitionHandler = (UsersModel?,Error?) -> Void
    typealias UserDetailWebServiceComplitionHandler = (UserDetail?,Error?) -> Void
    typealias UserReposWebServiceComplitionHandler = ([ReposModel]?,Error?) -> Void
   
    func searchAPICall(url : URL, complitionHandler: @escaping UserModelWebServiceComplitionHandler){
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error == nil && data != nil{
                
                guard let data = data else {return}
                
                do{
                    let users = try JSONDecoder().decode(UsersModel.self, from: data)
                    complitionHandler(users,nil)
                }catch{
                    complitionHandler(nil,error)
                    print(error.localizedDescription)
                }
            }else{
                complitionHandler(nil,error)
                print(error!)
            }
        }.resume()
    }
    
    
    
    func userDetailApiCall(url: URL, complitionHandler : @escaping UserDetailWebServiceComplitionHandler){
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
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
        }.resume()        
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
}
