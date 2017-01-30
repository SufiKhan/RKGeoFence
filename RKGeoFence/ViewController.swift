//
//  ViewController.swift
//  RKGeoFence
//
//  Created by Sierra Solutions Mac User 5 on 25/1/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController,MKMapViewDelegate{
    @IBOutlet weak var mapViewHB: MapViewHB!
    var locationManager = CLLocationManager()
    var polygonCoordinates = [CLLocationCoordinate2D]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUserLocation()
        HUBCoordinates().getCoordinatesForGeofence(callback: { (coordinates,centerCoordinate) in
            if(centerCoordinate != nil){
                setCenterAreaOfMap( centerCoordinate!)
                polygonCoordinates = coordinates
                setGeofence(polygonCoordinates)
            }
        })
    }
    
    func setUpUserLocation(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.distanceFilter = 50
//            locationManager.desiredAccuracy = Constants.ACCURACY
            mapViewHB.showsUserLocation = true
    }
    
    
    func setCenterAreaOfMap(_ coordinate:CLLocationCoordinate2D){
        //Set span for region to view the whole fence
        let span = MKCoordinateSpanMake(Constants.SPAN_LEVEL, Constants.SPAN_LEVEL)
        //set region to load while start of map
        let region =  MKCoordinateRegion(center: coordinate, span:span)
        mapViewHB.setRegion(region, animated: true)
    }

    //MARK: DRAW GEOFENCE
    func setGeofence(_ coordinates:[CLLocationCoordinate2D]){
        let geofence = MKPolygon(coordinates: coordinates, count: coordinates.count)
        mapViewHB.add(geofence)
        
    }
    func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.strokeColor = UIColor.black
            polygonView.lineWidth  = 3
            polygonView.fillColor = UIColor.blue .withAlphaComponent(0.5)
            return polygonView
    }
    
    func showAlert(_title: String,msg:String){
        let alert = UIAlertController.init(title: _title, message: msg, preferredStyle: .alert)
        let action  = UIAlertAction(title: Constants.OK, style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userWithinArea = mapViewHB.isLocationWithinArea(userLocation: locations.first!, hubCoordinates: polygonCoordinates, accuracy: Constants.ACCURACY)
        if(userWithinArea){
            self.showAlert(_title: Constants.INSIDE, msg: Constants.INSIDE_HUB_ALERT)
        }else{
            self.showAlert(_title: Constants.OUTSIDE,msg: Constants.OUTSIDE_HUB_ALERT)
        }
//        manager.stopUpdatingLocation()
    }
}
