//
//  RouteTableViewCell.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/26/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell {
    @IBOutlet weak var colorBar: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var routeLabel: UILabel!
    
    var route = Route(name: "Loading", number: "") {
        didSet {
            colorBar.backgroundColor = route.color
            numberLabel.text = route.number
            routeLabel.text = route.name
            setNeedsDisplay()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
