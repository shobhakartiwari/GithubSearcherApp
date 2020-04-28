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
    
    var userModel : [UserItems] = []
    let usersVM = UsersViewModel()
    var mySearchText = ""
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Github Searcher"
    }
}


extension ViewController : UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.usersVM.fetchUsers?.cancel()
        timer.invalidate()
        self.userModel = []
        self.usersVM.currentPage = 1
        self.usersVM.limit = 30
        
        if searchBar.text == "" || searchBar.text == " "{
            self.userModel = []
            self.myTableView.reloadData()
            
        }else{
            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { (_) in
                
                let trimed = searchText.replacingOccurrences(of: " ", with: "+")
                self.mySearchText = trimed
                let formatedSrting = ("\(ApiKeys.searchEnd.rawValue)\(trimed)\(Queries.page.rawValue)\(self.usersVM.currentPage)").lowercased()
                
                self.usersVM.APICall(url: formatedSrting) { (model, error) in
                    if error == nil && model != nil{
                        self.userModel = model!
                        DispatchQueue.main.async {
                            self.myTableView.reloadData()
                        }
                    }
                }
            })
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if userModel.count > 0{
            return userModel.count
        }else{
            return 0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        if indexPath.row == usersVM.limit - 1{            
            self.usersVM.limit += 30
            self.usersVM.currentPage += 1
        
            let formatedSrting = ("\(ApiKeys.searchEnd.rawValue)\(self.mySearchText)x\(Queries.page.rawValue)\(self.usersVM.currentPage)").lowercased()

            self.usersVM.APICall(url: formatedSrting) { (model, error) in
                if error == nil && model != nil{
                    self.userModel.append(contentsOf: model!)
                    DispatchQueue.main.async {
                        self.myTableView.reloadData()
                    }
                }
            }
        }
        cell.alpha = 0
        UIView.animate(withDuration: 1, animations: {cell.alpha = 1})
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CustomTableViewCell else {return UITableViewCell()}
        
        if userModel.count > 0{
            let data = userModel[indexPath.row]
            
            let imageUrl = URL(string: data.avatar)
            cell.avatarImageView.image = UIImage().urlToData(url: imageUrl!)
            cell.nameLabel.text = data.userName
            
            let formatedUrl = (ApiKeys.userReposUrl.rawValue + data.userName).lowercased()
            
            self.usersVM.userDetailApiCall(url: formatedUrl) { (repos, error) in
                if error == nil && repos != nil{
                    DispatchQueue.main.async {
                        cell.repoLabel.text = "Repos: \(repos?.repos ?? 0)"
                        
                    }
                }
            }
            
            return cell
        }else{
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let data = self.userModel[indexPath.row]
        let username = data.userName
        let stroyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = stroyBoard.instantiateViewController(identifier: "DetailViewController") as DetailViewController
        vc.userName = username
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
