//
//  ViewController.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/24/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit
import SwiftyJSON

class RouteTableViewController: UITableViewController {
    let routeManager = RouteManager.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        routeManager.performWhenDataLoaded(in: DispatchQueue.main) {
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return routeManager.dataLoaded ? routeManager.routes.count : 15
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "NearbyCell", for: indexPath)
        case 1:
            if routeManager.dataLoaded {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath) as! RouteTableViewCell
                cell.route = routeManager.routes[indexPath.row]
                
                return cell
            } else {
                return tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath)
            }
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Routes"
        default:
            return nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? DirectionViewController, let cell = sender as? RouteTableViewCell {
            DispatchQueue(label: "queue", qos: .userInteractive).async {
                target.route = cell.route
            }
        }
    }
}

