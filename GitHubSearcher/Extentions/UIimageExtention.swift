//
//  Extentions.swift
//  GitHubSearcher
//
//  Created by Philip Twal on 4/21/20.
//  Copyright © 2020 Philip Altwal. All rights reserved.
//

import UIKit


extension UIImageView {
    
    func getImage(url: String){
        
        guard let myUrl = URL(string: url) else {return}
        
        URLSession.shared.dataTask(with: myUrl) { (data, response, error) in
            
            if error == nil && data != nil {
                
                let image = UIImage(data: data!)
                
                DispatchQueue.main.async {
                    
                    self.image = image
                }
            }
        }.resume()
    }
}
