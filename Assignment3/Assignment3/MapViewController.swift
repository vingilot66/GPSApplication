//
//  MapViewController.swift
//  Assignment3
//
//  Created by Christopher Reynolds on 2019-11-14.
//  Copyright © 2019 Christopher Reynolds. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Foundation

class Character : MKCircle {
    var name: String?
    var color: UIColor?
}

class MapViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {

 let locationManager = CLLocationManager()
    struct MyVariables {
        static var initialLocation = CLLocation(latitude: 43.655787, longitude: -79.739534)
        static var wayPoint1 = CLLocation(latitude: 43.655787, longitude: -79.739534)
        static var wayPoint2 = CLLocation(latitude: 43.655787, longitude: -79.739534)
        static var destination = CLLocation(latitude: 43.655787, longitude: -79.739534)

    }
 @IBOutlet var myMapView : MKMapView!
 @IBOutlet var tbDestination: UITextField!
 @IBOutlet var myTableView: UITableView!
    @IBOutlet var tbWaypoint1: UITextField!
    @IBOutlet var tbWaypoint2: UITextField!
    @IBOutlet var selection: UISegmentedControl!
    @IBOutlet var distanceCheck: UILabel!
    

 var routeSteps  = ["Enter a destination or waypoint"] as NSMutableArray

 
 func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     textField.resignFirstResponder()
     
     return false;
 }
    override func viewDidLoad() {
           super.viewDidLoad()
        centerMapOnLocation(location: MyVariables.initialLocation)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = MyVariables.initialLocation.coordinate
        dropPin.title = "Starting at Sheridan College"
        self.myMapView.addAnnotation(dropPin)
        self.myMapView.selectAnnotation( dropPin, animated: true)
        
        
        
         }

    @IBAction func clearMap(sender : UIButton)
    {
        let alert = UIAlertController(title: "Could Not Get This Working", message: "Cannot get map to clear, go back to main scren to remove annotations", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
    @IBAction func checkDistance(sender : UIButton)
    {
        let locEnteredText = tbDestination.text
        
        let geocoder = CLGeocoder()
                   
                   geocoder.geocodeAddressString(locEnteredText!, completionHandler: {(placemarks, error) -> Void in
                       if((error) != nil){
                           print("Error", error)
                       }
                       if let placemark = placemarks?.first {
                           let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                           let newLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                           self.centerMapOnLocation(location: newLocation)
                           let dropPin = MKPointAnnotation()
                           dropPin.coordinate = coordinates
                           dropPin.title = placemark.name
                           self.myMapView.addAnnotation(dropPin)
                           self.myMapView.selectAnnotation( dropPin, animated: true)
                        
                        if (newLocation.distance(from: MyVariables.initialLocation) > 30000){
                            let message = "Over 30k Away from Sheridan"
                            self.distanceCheck.text = message
                        } else {
                            let message = "Under 30k Away from Sheridan"
                            self.distanceCheck.text = message
                        }
                        }
                   })
        
    }
    
    @IBAction func findNewLocation(sender : UIButton)
       {
        if selection.selectedSegmentIndex == 0{
            let locEnteredText = tbDestination.text
            
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = MyVariables.initialLocation.coordinate
            dropPin.title = "Starting at Sheridan College"
            self.myMapView.addAnnotation(dropPin)
            self.myMapView.selectAnnotation( dropPin, animated: true)
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(locEnteredText!, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil){
                    print("Error", error)
                }
                if let placemark = placemarks?.first {
                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                    let newLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                    self.centerMapOnLocation(location: newLocation)
                    let dropPin = MKPointAnnotation()
                    dropPin.coordinate = coordinates
                    dropPin.title = placemark.name
                    self.myMapView.addAnnotation(dropPin)
                    self.myMapView.selectAnnotation( dropPin, animated: true)
                    
                 let request = MKDirections.Request()
                    request.source = MKMapItem(placemark: MKPlacemark(coordinate:
                    MyVariables.initialLocation.coordinate,  addressDictionary: nil))
                    request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinates, addressDictionary: nil))
                    request.requestsAlternateRoutes = false
                    request.transportType = .automobile
                    
                    let directions = MKDirections(request: request)
                    directions.calculate (completionHandler: { [unowned self] response, error in
                        
                        for route in (response?.routes)! {
                         self.myMapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                            self.myMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                            self.routeSteps.removeAllObjects()
                            for step in route.steps {
                                self.routeSteps.add(step.instructions)
                                
                                self.myTableView.reloadData();
                            }
                         
                        }
                    })
                    
                }
            })
        }
        
        if selection.selectedSegmentIndex == 1{
            let locEnteredText = tbWaypoint1.text
            
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = MyVariables.initialLocation.coordinate
            dropPin.title = "Starting at Sheridan College"
            self.myMapView.addAnnotation(dropPin)
            self.myMapView.selectAnnotation( dropPin, animated: true)
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(locEnteredText!, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil){
                    print("Error", error)
                }
                if let placemark = placemarks?.first {
                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                    let newLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                    self.centerMapOnLocation(location: newLocation)
                    let dropPin = MKPointAnnotation()
                    dropPin.coordinate = coordinates
                    dropPin.title = placemark.name
                    self.myMapView.addAnnotation(dropPin)
                    self.myMapView.selectAnnotation( dropPin, animated: true)
                    
                 let request = MKDirections.Request()
                    request.source = MKMapItem(placemark: MKPlacemark(coordinate:
                    MyVariables.initialLocation.coordinate,  addressDictionary: nil))
                    request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinates, addressDictionary: nil))
                    request.requestsAlternateRoutes = false
                    request.transportType = .automobile
                    
                    let directions = MKDirections(request: request)
                    directions.calculate (completionHandler: { [unowned self] response, error in
                        
                        for route in (response?.routes)! {
                         self.myMapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                            self.myMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                            self.routeSteps.removeAllObjects()
                            for step in route.steps {
                                self.routeSteps.add(step.instructions)
                                
                                self.myTableView.reloadData();
                            }
                         
                        }
                    })
                    
                }
            })
        }
        
        if selection.selectedSegmentIndex == 2{
            let locEnteredText = tbWaypoint1.text
            let startEnteredText = tbWaypoint2.text
               
               let geocoder = CLGeocoder()
               let geocoder2 = CLGeocoder()
            
                geocoder2.geocodeAddressString(startEnteredText!, completionHandler: {(placemarks2, error) -> Void in
                    if((error) != nil){
                        print("Error", error)
                    }
                    if let placemark2 = placemarks2?.first {
                        let coordinatesStart:CLLocationCoordinate2D = placemark2.location!.coordinate
                        MyVariables.wayPoint2 = CLLocation(latitude: coordinatesStart.latitude, longitude: coordinatesStart.longitude)
                        let dropPinStart = MKPointAnnotation()
                        
                        dropPinStart.coordinate = coordinatesStart
                        dropPinStart.title = placemark2.name
                        self.myMapView.addAnnotation(dropPinStart)
                        self.myMapView.selectAnnotation( dropPinStart, animated: true)
                        
                        
                        
                    }
                })
            
            
               geocoder.geocodeAddressString(locEnteredText!, completionHandler: {(placemarks, error) -> Void in
                   if((error) != nil){
                       print("Error", error)
                   }
                   if let placemark = placemarks?.first {
                       let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                       let newLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                       self.centerMapOnLocation(location: newLocation)
                       let dropPin = MKPointAnnotation()
                       dropPin.coordinate = coordinates
                       dropPin.title = placemark.name
                       self.myMapView.addAnnotation(dropPin)
                       self.myMapView.selectAnnotation( dropPin, animated: true)
                       
                    let request = MKDirections.Request()
                       request.source = MKMapItem(placemark: MKPlacemark(coordinate:
                       MyVariables.wayPoint2.coordinate,  addressDictionary: nil))
                       request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinates, addressDictionary: nil))
                       request.requestsAlternateRoutes = false
                       request.transportType = .automobile
                       
                       let directions = MKDirections(request: request)
                       directions.calculate (completionHandler: { [unowned self] response, error in
                           
                           for route in (response?.routes)! {
                            self.myMapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                               self.myMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                               self.routeSteps.removeAllObjects()
                               for step in route.steps {
                                   self.routeSteps.add(step.instructions)
                                   
                                   self.myTableView.reloadData();
                               }
                            
                           }
                       })
                       
                   }
               })
        }
        /*   let locEnteredText = tbLocEntered.text
           let startEnteredText = tbStart.text
           
           let geocoder = CLGeocoder()
           let geocoder2 = CLGeocoder()
        
            geocoder2.geocodeAddressString(startEnteredText!, completionHandler: {(placemarks2, error) -> Void in
                if((error) != nil){
                    print("Error", error)
                }
                if let placemark2 = placemarks2?.first {
                    let coordinatesStart:CLLocationCoordinate2D = placemark2.location!.coordinate
                    MyVariables.initialLocation = CLLocation(latitude: coordinatesStart.latitude, longitude: coordinatesStart.longitude)
                    let dropPinStart = MKPointAnnotation()
                    
                    dropPinStart.coordinate = coordinatesStart
                    dropPinStart.title = placemark2.name
                    self.myMapView.addAnnotation(dropPinStart)
                    self.myMapView.selectAnnotation( dropPinStart, animated: true)
                    
                    
                    
                }
            })
        
        
           geocoder.geocodeAddressString(locEnteredText!, completionHandler: {(placemarks, error) -> Void in
               if((error) != nil){
                   print("Error", error)
               }
               if let placemark = placemarks?.first {
                   let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                   let newLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                   self.centerMapOnLocation(location: newLocation)
                   let dropPin = MKPointAnnotation()
                   dropPin.coordinate = coordinates
                   dropPin.title = placemark.name
                   self.myMapView.addAnnotation(dropPin)
                   self.myMapView.selectAnnotation( dropPin, animated: true)
                   
                let request = MKDirections.Request()
                   request.source = MKMapItem(placemark: MKPlacemark(coordinate:
                   MyVariables.initialLocation.coordinate,  addressDictionary: nil))
                   request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinates, addressDictionary: nil))
                   request.requestsAlternateRoutes = false
                   request.transportType = .automobile
                   
                   let directions = MKDirections(request: request)
                   directions.calculate (completionHandler: { [unowned self] response, error in
                       
                       for route in (response?.routes)! {
                        self.myMapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                           self.myMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                           self.routeSteps.removeAllObjects()
                           for step in route.steps {
                               self.routeSteps.add(step.instructions)
                               
                               self.myTableView.reloadData();
                           }
                        
                       }
                   })
                   
               }
           })
 */
       }
       
       func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
           let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
           renderer.strokeColor = UIColor.blue
           renderer.lineWidth = 3.0;
           return renderer
       }

       // Step 0 - create a generic method to center
       // map at the desired location
       let regionRadius: CLLocationDistance = 1000
       func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
           myMapView.setRegion(coordinateRegion, animated: true)
       }

       override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }
       

       // MARK: - Table Methods
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return routeSteps.count
       }
       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 30
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()

           tableCell.textLabel?.text = routeSteps[indexPath.row] as? String
           
           return tableCell
           
       }

}
