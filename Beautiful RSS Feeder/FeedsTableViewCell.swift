//
//  FeedsTableViewCell.swift
//  Beautiful RSS Feeder
//
//  Created by Grant on 03/12/2015.
//  Copyright © 2015 GK Micro Ltd. All rights reserved.
//

import UIKit

class FeedsTableViewCell: UITableViewCell {
    
    //Mark: properties
    @IBOutlet weak var feedName: UILabel!
    @IBOutlet weak var feedAddress: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
