//
//  LocalViewController.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 5/19/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

class LocalViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var table: UITableView!
    
    var annotation: MKPointAnnotation?
    
    let stopManager = StopManager.instance
    let locationManager = CLLocationManager()
    
    var here: CLLocation = CLLocation(latitude: 41.8781, longitude: -87.6298)
    var radius: CLLocationDistance = 1000
    
    //let span
    let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.01)
    var initialZoom = false
    
    var localStops = [BusStop]()
    var closestStopsWithRoutes = [BusStop: [RouteDirection]]()
    var routePredictions = [(rtDir: RouteDirection, pred: Prediction)]() {
        didSet {
            if !routePredictions.isEmpty {
                for (rtDir, pred) in routePredictions {
                    print("\(rtDir.route.number), \(rtDir.direction) -> \(pred.stopName): \(pred.waittime) min")
                }
                DispatchQueue.main.async { self.table.reloadData() }
                //locationManager.requestLocation()
            }
        }
    }
    
    var updateTimer: Timer?
    
    var newRoutePredictions = [RouteDirection: Prediction]()
    var remainingForUpdate = 0 {
        didSet {
            if remainingForUpdate == 0 {
                var rtPred = [(rtDir: RouteDirection, pred: Prediction)]()
                for (rtDir, pred) in newRoutePredictions {
                    rtPred.append((rtDir, pred))
                }
                routePredictions = rtPred.sorted { $0.pred.waittime < $1.pred.waittime }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        map.region = MKCoordinateRegion(center: here.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        map.showsUserLocation = true
        
        //  Location manager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
        if initialZoom {
            update()
            map.setRegion(MKCoordinateRegionMakeWithDistance(here.coordinate, 2 * radius, 2 * radius), animated: true)
            updateTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                print("Updating…")
                self.update()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateTimer?.invalidate()
        locationManager.stopUpdatingLocation()
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        here = locations.last ?? here
        let annotations: [MKAnnotation] = annotation == nil ? [map.userLocation] : [annotation!, map.userLocation]
        map.showAnnotations(annotations, animated: true)
        if !initialZoom {
            initialZoom = true
            map.setRegion(MKCoordinateRegionMakeWithDistance(here.coordinate, 2 * radius, 2 * radius), animated: true)
            update()
            updateTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                print("Updating…")
                self.update()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    //  MARK: - Data
    func update() {
        localStops = stopManager.getStops(near: here, within: radius)
        closestStopsWithRoutes = getClosestStopsAndRoutes(for: localStops)
        
        getPredictions(for: closestStopsWithRoutes)
    }
    
    private func getClosestStopsAndRoutes(for stops: [BusStop]) -> [BusStop: [RouteDirection]] {
        let localRoutes = stopManager.getRoutesAndDirections(for: stops)
        var routeToStop = [RouteDirection: BusStop]()
        
        for stop in stops {
            for route in localRoutes {
                guard let rts = stopManager.stopsToRoutes[stop], rts.contains(route) else { continue }
                guard let otherStop = routeToStop[route] else {
                    routeToStop[route] = stop
                    continue
                }
                
                if here.distance(from: stop.location) < here.distance(from: otherStop.location) {
                    routeToStop[route] = stop
                }
            }
        }
        
        var stopToRoutes = [BusStop: [RouteDirection]]()
        
        for (route, stop) in routeToStop {
            if var ary = stopToRoutes[stop] {
                ary.append(route)
                stopToRoutes[stop] = ary
            } else {
                stopToRoutes[stop] = [route]
            }
        }
        
        return stopToRoutes
    }
    
    func getPredictions(for stopsToRoutes: [BusStop: [RouteDirection]]) {
        newRoutePredictions = [:]
        remainingForUpdate = stopsToRoutes.keys.count
        
        for stop in stopsToRoutes.keys {
            let routes = stopsToRoutes[stop]!
            var routesToGo = routes.count
            
            CTAConnector.makeRequest(forCall: "getpredictions", withArguments: ["stpid=\(stop.ID)"]) { data in
                let json = JSON(data: data)
                
                guard let prds = json["bustime-response"]["prd"].array else {
                    if let errs = json["bustime-response"]["error"].array {
                        for err in errs { if err["msg"] == "No service scheduled" {
                            routesToGo -= 1
                            self.remainingForUpdate -= 1
                            return
                            }
                        }
                    }
                    
                    routesToGo -= 1
                    self.remainingForUpdate -= 1
                    return
                }
                
                for prd in prds {
                    guard let destination = prd["des"].string else { continue }
                    guard let routeNum = prd["rt"].string else { continue }
                    guard let key = prd["typ"].string, let predictionType = PredictionType(forKey: key) else { continue }
                    guard let dir = prd["rtdir"].string, let direction = Direction(rawValue: dir) else { continue }
                    guard let time = prd["prdctdn"].string, let waittime = Int(time) else { continue }
                    guard let stopName = prd["stpnm"].string else { continue }
                    
                    guard let routeToPlace = routes.first(where: { $0.route.number == routeNum }) else { continue }
                    guard !self.newRoutePredictions.keys.contains(routeToPlace) else { continue }
                    
                    let prediction = Prediction(destination: destination, routeNum: routeNum, type: predictionType, direction: direction, waittime: waittime, stopName: stopName)
                    
                    self.newRoutePredictions[routeToPlace] = prediction
                    routesToGo -= 1
                    
                    guard routesToGo > 0 else { break }
                }
                
                self.remainingForUpdate -= 1
            }
        }
    }
    
    //  MARK: - TableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(routePredictions.count, 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocalStopCell") as! LocalTableViewCell
        if routePredictions.count == 0 {
            cell.accessoryType = .none
            
            cell.number.text = ""
            cell.routeName.text = ""
            cell.stopName.text = "No nearby busses"
            cell.directionLabel.text = ""
            cell.wait.text = "∞"
        } else {
            let (rtDir, pred) = routePredictions[indexPath.row]
            
            cell.accessoryType = .detailButton
            
            cell.number.text = pred.routeNum
            cell.routeName.text = rtDir.route.name
            cell.stopName.text = pred.stopName
            cell.directionLabel.text = rtDir.direction.rawValue
            cell.wait.text = String(pred.waittime)
            
            cell.route = rtDir.route
            cell.direction = rtDir.direction
            cell.prediction = pred
        }
        
        return cell
    }
    
    //  MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let anno = annotation { map.removeAnnotation(anno) }
        
        let (_, prediction) = routePredictions[indexPath.row]
        guard let stop = closestStopsWithRoutes.keys.first(where: { $0.name == prediction.stopName }) else { return }
        
        annotation = MKPointAnnotation()
        annotation?.coordinate = stop.location.coordinate
        
        map.addAnnotation(annotation!)
        map.showAnnotations([annotation!, map.userLocation], animated: true)
        //locationManager.requestLocation()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? TimeViewController, let cell = sender as? LocalTableViewCell {
            destination.intendedDirection = cell.direction
            destination.targetRoute = cell.route
            destination.stop = closestStopsWithRoutes.keys.first(where: { $0.name == cell.prediction?.stopName })
        }
    }

    //  Inspectables
    @IBInspectable var getStopsWithin: Double = 1000 {
        didSet {
            radius = getStopsWithin
        }
    }
}
