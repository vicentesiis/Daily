//
//  MomentsTableViewCell.swift
//  Daily
//
//  Created by Vicente Cantu Garcia on 19/10/17.
//  Copyright © 2017 Vicente Cantu Garcia. All rights reserved.
//

import UIKit

class MomentsTableViewCell: UITableViewCell {

    @IBOutlet weak var momentLabel: UILabel!
    @IBOutlet weak var momentImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
