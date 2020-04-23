//
//  DetailCustomTableViewCell.swift
//  GitHubSearcher
//
//  Created by Philip Twal on 4/21/20.
//  Copyright © 2020 Philip Altwal. All rights reserved.
//

import UIKit

class DetailCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var reposNameLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
