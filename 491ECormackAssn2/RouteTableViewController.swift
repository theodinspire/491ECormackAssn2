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
    var dataLoaded = false
    
    var routes = [Route]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLoaded ? routes.count : 15
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataLoaded {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath) as! RouteTableViewCell
            cell.route = routes[indexPath.row]
            
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath)
        }
    }

    func loadData() {
        let dataTask = CTAConnector.dataTask(forCall: "getroutes") { optdata, response, error in
            guard error == nil else {
                print(error!.localizedDescription)
                //  TODO: do some better error handling
                return
            }
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                if let httpResponse = response as? HTTPURLResponse {
                    print(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                } else {
                    print("Response is not hyper-text transfer protocol")
                }
                
                print("A correct response would have HTTP Status code of 200")
                return
            }
            
            guard let data = optdata else {
                print("Data malformed")
                return
            }
            
            let json = JSON(data: data)
            
            guard let rts = json["bustime-response"]["routes"].array else {
                print("Routes data not correctly shaped as array")
                print(json)
                return
            }
            
            for rt in rts {
                let colorCode = rt["rtclr"].string // Can be option
                if let number = rt["rt"].string, let name = rt["rtnm"].string { // Must have value
                    self.routes.append(Route(name: name, number: number, colorCode: colorCode))
                }
            }
            
            self.dataLoaded = true
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        dataTask?.resume()
    }
}

