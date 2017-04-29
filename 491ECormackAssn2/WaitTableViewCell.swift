//
//  WaitTableViewCell.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/29/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

class WaitTableViewCell: UITableViewCell {
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var waitLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
