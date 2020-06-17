//
//  cell.swift
//  ios-dev-ass3
//
//  Created by Thomas Good on 9/6/20.
//  Copyright © 2020 Thomas Good. All rights reserved.
//

import UIKit

class cell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var dosageLabel: UILabel!
    @IBOutlet weak var dosageTime: UILabel!
    @IBOutlet weak var foodSwitchLabel: UILabel!
    @IBOutlet weak var notificationTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
