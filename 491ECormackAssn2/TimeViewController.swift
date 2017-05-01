//
//  TimeViewController.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/29/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit
import SwiftyJSON

class TimeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var stopName: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var routeNumber: UILabel!

    @IBOutlet weak var stopWait: UILabel!
    
    @IBOutlet weak var table: UITableView!
    
    var stop: BusStop?
    var targetRoute: Route?
    var intendedDirection: Direction?
    
    var highAlert = [Warning]()
    var predictions = [Prediction]()
    var warnings = [Warning]()
    
    var timer: Timer?
    
    var predictionDataLoaded = false {
        didSet {
            if warningsDataLoaded && predictionDataLoaded { DispatchQueue.main.async { self.setData() } }
        }
    }
    var warningsDataLoaded = false {
        didSet {
            if warningsDataLoaded && predictionDataLoaded { DispatchQueue.main.async { self.setData() } }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        table.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stopName.text = stop!.name
        loadData()
        super.viewWillAppear(animated)
        
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(loadData), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return highAlert.count
        case 1:
            return max(0, predictions.count - 1)
        case 2:
            return warnings.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HighAlertCell", for: indexPath) as! WarningTableViewCell
            let alert = highAlert[indexPath.row]
            
            cell.warning?.text = "⚠️ \(alert.name)"
            cell.detail?.text = alert.detail
            
            return cell
            
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WaitCell", for: indexPath) as! WaitTableViewCell
            let prediction = predictions[indexPath.row + 1]
            
            cell.routeLabel.text = "\(prediction.routeNum) to: \(prediction.destination)"
            cell.waitLabel.text = "\(prediction.waittime) min"
            
            return cell
            
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WarningCell", for: indexPath) as! WarningTableViewCell
            let warning =  warnings[indexPath.row]
            
            cell.warning?.text = "⚠️ \(warning.name)"
            cell.detail?.text = warning.detail
            
            return cell
            
            
        default:
            return tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func loadData() {
        print("Updating stop info…")
        guard stop != nil else {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        
        highAlert.removeAll(keepingCapacity: true)
        predictions.removeAll(keepingCapacity: true)
        warnings.removeAll(keepingCapacity: true)
        
        CTAConnector.makeRequest(forCall: "getpredictions", withArguments: ["stpid=\(stop!.ID)"]) { data in
            let json = JSON(data: data)
            
            guard let prds = json["bustime-response"]["prd"].array else {
                if let errs = json["bustime-response"]["error"].array {
                    for err in errs { if err["msg"] == "No service scheduled" {
                        self.predictionDataLoaded = true
                        return
                        }
                    }
                }
                
                print("Prediction data malformed")
                print(json["bustime-response"]["prd"].error.debugDescription)
                print(json)
                
                self.predictionDataLoaded = true
                
                return
            }
            
            for prd in prds {
                guard let destination = prd["des"].string else { break }
                guard let routeNum = prd["rt"].string else { break }
                guard let key = prd["typ"].string, let predictionType = PredictionType(forKey: key) else { break }
                guard let dir = prd["rtdir"].string, let direction = Direction(rawValue: dir) else { break }
                guard let time = prd["prdctdn"].string, let waittime = Int(time) else { break }
                
                self.predictions.append(Prediction(destination: destination, routeNum: routeNum, type: predictionType, direction: direction, waittime: waittime))
            }
            
            self.predictions.sort { $0.waittime < $1.waittime }
            self.predictionDataLoaded = true
        }
        
        CTAConnector.makeRequest(forCall: "getservicebulletins", withArguments: ["rt=\(targetRoute!.number)","rtdir=\(intendedDirection!.rawValue)"]) { data in
            let json = JSON(data: data)
            
            guard let wrns = json["bustime-response"]["sb"].array else {
                
                if let errs = json["bustime-response"]["error"].array {
                    for err in errs { if err["msg"] == "No data found for parameter" {
                        self.warningsDataLoaded = true
                        return
                        }
                    }
                }
                
                print("Service Bulletin data malformed")
                print(json["bustime-response"]["sb"].error.debugDescription)
                print(json)
                
                self.warningsDataLoaded = true
                
                return
            }
            
            for wrn in wrns {
                guard let name = wrn["sbj"].string else { break }
                guard let key = wrn["prty"].string, let priority = WarningPriority(rawValue: key) else { break }
                guard let detail = wrn["dtl"].string else { break }
                
                let warning = Warning(name: name, detail: detail, priority: priority)
                if priority == .High { self.highAlert.append(warning) }
                else { self.warnings.append(warning) }
            }
            
            self.warningsDataLoaded = true
        }
    }
    
    //  Must be accessed through Main thread
    func setData() {
        if predictions.count > 0 {
            let main = predictions[0]
            
            directionLabel.text = main.direction.rawValue
            destination.text = main.destination
            routeNumber.text = main.routeNum
            
            stopWait.text = String(main.waittime)
        } else {
            directionLabel.text = ""
            destination.text = "No busses"
            routeNumber.text = ""
            
            stopWait.text = "--"
        }
        
        warningsDataLoaded = false
        predictionDataLoaded = false
        
        table.reloadData()
    }
}
