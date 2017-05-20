//
//  LocalViewController.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 5/19/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit
import MapKit

class LocalViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var location: CLLocation = CLLocation(latitude: 41.8781, longitude: -87.6298)
    
    let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.01)
    var initialZoom = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        map.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        map.showsUserLocation = true
        
        //  Location manager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        map.setRegion(MKCoordinateRegion(center: locationManager.location!.coordinate, span: defaultSpan), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let _ = locations.last else { return }
        location = locations.last!
        //print(location)
    }
    
    @IBAction func printStops(_ sender: Any) {
        print(location.coordinate)
        let nearbyStops = StopManager.instance.getStops(near: location, within: 1000)
        //nearbyStops.sort(by: )
        nearbyStops.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }.forEach { print("\($0.ID)\t\($0.name)") }
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
