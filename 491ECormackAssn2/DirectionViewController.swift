//
//  DirectionViewController.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/27/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit
import SwiftyJSON

class DirectionViewController: UIViewController {
    @IBOutlet weak var north: UIView!
    @IBOutlet weak var east: UIView!
    @IBOutlet weak var south: UIView!
    @IBOutlet weak var west: UIView!
    
    var route: Route? {
        didSet {
            guard let rt = route else { return }
            let stopManager = StopManager.instance
            
            stopManager.performTaskWhenLoaded(for: rt, going: nil, on: DispatchQueue.main) {
                guard let keys = stopManager.routeStops[rt]?.keys else { return }
                
                for key in keys {
                    switch key {
                    case .Northbound: self.north.isHidden = false
                    case .Eastbound: self.east.isHidden = false
                    case .Southbound: self.south.isHidden = false
                    case .Westbound: self.west.isHidden = false
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        north.isHidden = true
        east.isHidden = true
        south.isHidden = true
        west.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideNorthSouth() {
        DispatchQueue.main.async {
            self.north.isHidden = true
            self.south.isHidden = true
            self.east.isHidden = false
            self.west.isHidden = false
        }
    }
    
    func hideEastWest() {
        DispatchQueue.main.async {
            self.north.isHidden = false
            self.south.isHidden = false
            self.east.isHidden = true
            self.west.isHidden = true
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? StopTableViewController, let buttonTitle = (sender as? UIButton)?.currentTitle {
            destination.route = self.route
            destination.direction = Direction(rawValue: buttonTitle)
        }
    }

}
