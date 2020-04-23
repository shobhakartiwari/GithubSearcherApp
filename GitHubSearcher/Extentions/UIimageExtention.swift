//
//  Extentions.swift
//  GitHubSearcher
//
//  Created by Philip Twal on 4/21/20.
//  Copyright © 2020 Philip Altwal. All rights reserved.
//

import UIKit



extension UIImage{
    
    func urlToData(url : URL) -> UIImage?{
        
        do{
            let imageData = try Data(contentsOf: url)
            let image = UIImage(data: imageData)
            return image
        }catch{
            return UIImage()
        }
        
    }
}
