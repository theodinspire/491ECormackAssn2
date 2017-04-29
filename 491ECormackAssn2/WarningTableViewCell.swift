//
//  WarningTableViewCell.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/29/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

class WarningTableViewCell: UITableViewCell {
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var warning: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
