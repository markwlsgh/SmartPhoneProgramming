//
//  MapViewController.swift
//  HospitalMap
//
//  Created by kpugame on 2018. 4. 23..
//  Copyright © 2018년 SeokJinHo. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var posts = NSMutableArray()
    
    let regionRadius: CLLocationDistance = 5000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    var hospitals : [Hospital] = []
    
    func loadInitialData() {
        for post in posts {
            let yadmNm = (post as AnyObject).value(forKey: "title") as! NSString as String
            let addr = (post as AnyObject).value(forKey: "place") as! NSString as String
            let XPos = (post as AnyObject).value(forKey: "latitude") as! NSString as String
            let YPos = (post as AnyObject).value(forKey: "longitude") as! NSString as String
            let lat = (YPos as NSString).doubleValue
            let lon = (XPos as NSString).doubleValue
            let hospital = Hospital(title: yadmNm, locationName: addr, coordinate: CLLocationCoordinate2D(latitude: 37.4786094, longitude: 127.0091182))
            hospitals.append(hospital)
            
            let initialLocation = CLLocation(latitude: 37.4786094, longitude: 127.0091182)
            // Do any additional setup after loading the view.
            centerMapOnLocation(location: initialLocation)
        }
        
        

    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Hospital
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotaiton = annotation as? Hospital else { return nil }
        
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let initialLocation = CLLocation(latitude: 37.4786094, longitude: 127.0091182)
        // Do any additional setup after loading the view.
        centerMapOnLocation(location: initialLocation)
        
        mapView.delegate = self

        loadInitialData()
        
        mapView.addAnnotations(hospitals)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
