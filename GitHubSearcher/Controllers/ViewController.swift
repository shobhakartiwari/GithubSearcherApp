//
//  ViewController.swift
//  GitHubSearcher
//
//  Created by Philip Twal on 4/18/20.
//  Copyright © 2020 Philip Altwal. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var searchBarController: UISearchBar!
    
    @IBOutlet var myTableView: UITableView!
    
    var userModel : [UserItems] = []
    let usersVM = UsersViewModel()
    var mySearchText = ""
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Github Searcher"
    }
}



extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userModel.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CustomTableViewCell else {return UITableViewCell()}
        
        if userModel.count > 0{
            let data = userModel[indexPath.row]
            
            // UIImageView extension to load the images from data
            cell.avatarImageView.getImage(url: data.avatar)
            cell.nameLabel.text = data.userName
            
            let formatedUrl = (ApiKeys.userReposUrl.rawValue + data.userName).lowercased()
            
            if data.userDetail == nil{
                //MARK: - calling the user detail api to fetch the user repo count
                self.usersVM.userDetailApiCall(url: formatedUrl) { (userDetail, error) in
                    if error == nil && userDetail != nil{
                        DispatchQueue.main.async {
                            cell.repoLabel.text = "Repos: \(userDetail?.repos ?? 0)"
                            data.userDetail = userDetail
                        }
                    }
                }
            }else{
                cell.repoLabel.text = "Repos: \(data.userDetail?.repos ?? 0)"
            }
            
        }else{
            return cell
        }
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        if indexPath.row == usersVM.limit - 1{            
            self.usersVM.limit += 30
            self.usersVM.currentPage += 1
        
            let formatedSrting = ("\(ApiKeys.searchEnd.rawValue)\(self.mySearchText)\(Queries.page.rawValue)\(self.usersVM.currentPage)").lowercased()
            
            //MARK: - fetching the users list to be displayed in table view
            self.usersVM.APICall(url: formatedSrting) { (model, error) in
                if error == nil && model != nil{
                    self.userModel.append(contentsOf: model!)
                    DispatchQueue.main.async {
                        self.myTableView.reloadData()
                        
                    }
                }
            }
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



extension ViewController: UISearchBarDelegate{
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // cancel the previous api call to stop invoking the api while editing the search bar
        self.usersVM.fetchUsers?.cancel()
        timer.invalidate()
        self.userModel = []
        self.usersVM.currentPage = 1
        self.usersVM.limit = 30
        
        if searchBar.text == "" || searchBar.text == " "{
            self.userModel = []
            self.myTableView.reloadData()
    
        }else{
            // adding timer to prevent frequent reloading
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
    
    //MARK: - resign the key board when search button pressed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.searchTextField.resignFirstResponder()
    }
}


extension ViewController {
    
    override func viewWillDisappear(_ animated: Bool) {
        self.usersVM.clear()
    }
}
