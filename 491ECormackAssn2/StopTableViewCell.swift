//
//  StopTableViewCell.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/28/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

class StopTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    var stop = BusStop(ID: "Loading…", name: "", lat: 0, lon: 0) {
        didSet {
            DispatchQueue.main.async {
                self.label.text = self.stop.name
            }
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
