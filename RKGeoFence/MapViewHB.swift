//
//  LocationUpdater.swift
//  RKGeoFence
//
//  Created by Sierra Solutions Mac User 5 on 26/1/17.
//  Copyright © 2017 test. All rights reserved.
//

import MapKit

class MapViewHB: MKMapView {
    
    func isLocationWithinArea(userLocation:CLLocation,hubCoordinates:[CLLocationCoordinate2D],accuracy:Double)->Bool{
        let polygonRenderer = MKPolygonRenderer(polygon: (overlays.first as? MKPolygon)!)
        let currentMapPoint: MKMapPoint = MKMapPointForCoordinate(userLocation.coordinate)
        let polygonViewPoint: CGPoint = polygonRenderer.point(for: currentMapPoint)
        let inside = polygonRenderer.path.contains(polygonViewPoint)
        var distanceArray = [CLLocationDistance]()
        if(!inside){
            for polygonPoint in hubCoordinates.enumerated(){
                let  loc =  CLLocation(latitude: polygonPoint.element.latitude, longitude: polygonPoint.element.longitude)
                let distance = loc.distance(from: userLocation)
                distanceArray.append(distance)
            }
            if(distanceArray.min()?.isLessThanOrEqualTo(accuracy))!
            {
                return true
            }else{
                return false
            }
        }else{
            return true
        }
    }
}
