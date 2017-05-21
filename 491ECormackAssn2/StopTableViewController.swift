//
//  StopTableViewController.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/27/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit
import SwiftyJSON

class StopTableViewController: UITableViewController {
    var dataLoaded = false
    var stops = [BusStop]() {
        didSet {
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    }

    @IBOutlet weak var navbar: UINavigationItem!
    
    var route: Route? { didSet { setName(); loadData() } }
    var direction: Direction? { didSet { setName(); loadData() } }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stops.count > 0 ? stops.count : 15
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if stops.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StopCell", for: indexPath) as! StopTableViewCell
            cell.stop = stops[indexPath.row]
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "StopCell", for: indexPath)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? TimeViewController, let cell = sender as? StopTableViewCell {
            destination.stop = cell.stop
            destination.targetRoute = route
            destination.intendedDirection = direction
        }
    }
    
    func setName() {
        guard route != nil, direction != nil else { return }
        //guard isViewLoaded else { return }
        
        DispatchQueue.main.async {
            self.navigationItem.title = "\(self.route!.name) — \(self.direction!.rawValue)"
        }
    }

    func loadData() {
        guard route != nil, direction != nil else { return }
        let stopManager = StopManager.instance
        
        stopManager.performTaskWhenLoaded(for: route!, going: direction!, on: DispatchQueue.global(qos: .userInitiated)) {
            self.stops = (stopManager.routeToStops[self.route!]?[self.direction!])!
        }
    }
}
