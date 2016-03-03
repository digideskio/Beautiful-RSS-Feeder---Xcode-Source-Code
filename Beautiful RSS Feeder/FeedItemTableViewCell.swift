//
//  FeedItemTableViewCell.swift
//  Beautiful RSS Feeder
//
//  Created by Grant on 04/12/2015.
//  Copyright © 2015 GK Micro Ltd. All rights reserved.
//

import UIKit

class FeedItemTableViewCell: UITableViewCell {

    @IBOutlet weak var largeLetter: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
