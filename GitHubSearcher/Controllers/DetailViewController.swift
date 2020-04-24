//
//  DetailViewController.swift
//  GitHubSearcher
//
//  Created by Philip Twal on 4/20/20.
//  Copyright © 2020 Philip Altwal. All rights reserved.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var mySearchBar: UISearchBar!
    @IBOutlet weak var myTableView: UITableView!
    
    
    var userDetail : UserDetail?
    var userRepos : [ReposModel]?
    var usersVM = UsersViewModel()
    var isSearching = false
    var userName : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .background).async {
            let formatedUrl = (ApiKeys.userReposUrl.rawValue + self.userName!).lowercased()
            print(formatedUrl)
            self.usersVM.userDetailApiCall(url: formatedUrl) { (Detail, error) in
                self.userDetail = Detail
                DispatchQueue.main.async {
                    guard let imageUrl = URL(string: (self.userDetail?.avatar) ?? "nil") else {return}
                    self.avatarImageView.image = UIImage().urlToData(url: imageUrl)
                    self.userNameLabel.text = self.userDetail?.name ?? self.userName
                    self.bioLabel.text = self.userDetail?.bio ?? "No biography on this user"
                    self.emailLabel.text = self.userDetail?.email ?? "Nil Email"
                    self.followersLabel.text = "Followers: \(String(describing: self.userDetail?.followers ?? 0))"
                    self.followingLabel.text = "Following: \(String(describing: self.userDetail?.following ?? 0))"
                    self.locationLabel.text = self.userDetail?.location ?? "Nil Location"
                }
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            let formatedUrl = (ApiKeys.userReposUrl.rawValue + self.userName! + EndPionts.repos.rawValue).lowercased()
            print(formatedUrl)
            self.usersVM.userReposApiCall(url: formatedUrl) { (reposModel, error) in
                self.userRepos = reposModel
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                }
            }
        }
    }
}



extension DetailViewController: UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.userRepos != nil{
            return self.userRepos!.count
        }else{
            return 0
        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? DetailCustomTableViewCell else {return UITableViewCell()}
        
        if self.userRepos != nil{
            let data = self.userRepos![indexPath.row]
            
            cell.reposNameLabel.text = data.name
            cell.forksLabel.text = "Forks :\(data.forks)"
            cell.starsLabel.text = "Stars :\(data.stars)"
            
            return cell
        }else{
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
        let data = self.userRepos![indexPath.row]
        let repoName = data.name
        let formatedUrl = (ApiKeys.safariUrl.rawValue + self.userName! + "/" + repoName).lowercased()
        showSafariVC(url: formatedUrl)

    }
    
    
    func showSafariVC(url : String){
        
        guard let url = URL(string: url) else {return}
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}
