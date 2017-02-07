//
//  UserCell.swift
//  demoSwift
//
//  Created by yons on 17/2/7.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var imgPor: UIImageView!
    
    @IBOutlet weak var labelNick: UILabel!
    
    @IBOutlet weak var labelAddr: UILabel!
    
    @IBOutlet weak var labelViewers: UILabel!
    
    @IBOutlet weak var imgBigPor: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
