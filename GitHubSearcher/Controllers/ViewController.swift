//
//  ViewController.swift
//  GitHubSearcher
//
//  Created by Philip Twal on 4/18/20.
//  Copyright © 2020 Philip Altwal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var searchBarController: UISearchBar!
    
    @IBOutlet var myTableView: UITableView!
    
    var userModel : UsersModel?
    let usersVM = UsersViewModel()
  
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Github Searcher"
        
    }
}


extension ViewController : UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer.invalidate()
        
        if searchBar.text == "" || searchBar.text == " "{
            
            self.userModel = nil
            self.myTableView.reloadData()
            
        }else{
            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { (_) in
                self.usersVM.fetchUsers?.cancel()
                self.usersVM.fetchReposCount?.cancel()
                self.userModel = nil
                
                let trimed = searchText.replacingOccurrences(of: " ", with: "+")
                let formatedSrting = (ApiKeys.searchEnd.rawValue + trimed).lowercased()
                DispatchQueue.global(qos: .background).async {
                    self.usersVM.APICall(url: formatedSrting) { (model, error) in
                        if error == nil && model != nil{
                            self.userModel = model
                            DispatchQueue.main.async {
                                self.myTableView.reloadData()
                            }
                        }
                    }
                }
            })
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userModel != nil{
            return userModel!.items.count
        }else{
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CustomTableViewCell else {return UITableViewCell()}
        
        
        if userModel != nil{
            let data = userModel!.items[indexPath.row]
            
            let imageUrl = URL(string: data.avatar)
            cell.avatarImageView.image = UIImage().urlToData(url: imageUrl!)
            cell.nameLabel.text = data.userName
            
            let formatedUrl = (ApiKeys.userReposUrl.rawValue + data.userName).lowercased()
            DispatchQueue.global(qos: .background).async {
                self.usersVM.userDetailApiCall(url: formatedUrl) { (repos, error) in
                    if error == nil && repos != nil{
                        DispatchQueue.main.async {
                            cell.repoLabel.text = "Repos: \(repos?.repos ?? 0)"
                            
                        }
                    }
                }
            }
            return cell
        }else{
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let data = self.userModel?.items[indexPath.row]
        let username = data?.userName
        let stroyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = stroyBoard.instantiateViewController(identifier: "DetailViewController") as DetailViewController
        vc.userName = username
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
