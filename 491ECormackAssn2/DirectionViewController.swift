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
    
    var route: Route! {
        didSet {
            loadData()
        }
    }
    
    var primaryDirection = Direction.Northbound {
        didSet {
            switch primaryDirection {
            case .Northbound, .Southbound:
                hideEastWest()
            case .Eastbound, .Westbound:
                hideNorthSouth()
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
    
    func loadData() {
        CTAConnector.makeRequest(forCall: "getdirections", withArguments: ["rt=\(route.number)"], failureTask: { DispatchQueue.main.async { self.navigationController?.popViewController(animated: true) } }) { data in
            let json = JSON(data: data)
            
            if let str = json["bustime-response"]["directions"].array?[0]["dir"].string, let direction = Direction(rawValue: str) {
                self.primaryDirection = direction
            }
        }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
