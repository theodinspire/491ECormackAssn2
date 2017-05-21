//
//  LocalTableViewCell.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 5/20/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

class LocalTableViewCell: UITableViewCell {
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var routeName: UILabel!
    @IBOutlet weak var stopName: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var wait: UILabel!
    
    var route: Route?
    var direction: Direction?
    var prediction: Prediction?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
