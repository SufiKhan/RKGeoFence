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
        if(!inside){
           let distanceArray = self.nearestPointInPolylineToUserLocation(userLocation: userLocation, hubCoordinates: hubCoordinates)
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
    
    func nearestPointInPolylineToUserLocation(userLocation:CLLocation,hubCoordinates:[CLLocationCoordinate2D]) -> [Double]{
        var distanceArray = [Double]()
        let originPoint = CGPoint(x: userLocation.coordinate.longitude, y: userLocation.coordinate.latitude)
        for i in 0..<hubCoordinates.count - 1{
            let startingCoordinate = hubCoordinates[i]
            let startPoint = CGPoint(x: startingCoordinate.longitude, y: startingCoordinate.latitude)
            let endingCoordinate = hubCoordinates[i + 1]
            let endPoint = CGPoint(x: endingCoordinate.longitude, y: endingCoordinate.latitude)
            let point
                        = self.nearestPoint(origin: originPoint, pointA: startPoint, pointB: endPoint)
            let cord = CLLocationCoordinate2DMake(CLLocationDegrees(point.y), CLLocationDegrees(point.x))
            let loc = CLLocation(latitude: cord.latitude, longitude: cord.longitude)
            distanceArray.append(loc.distance(from: userLocation))
        }
        return distanceArray
    }
    
    func nearestPoint(origin:CGPoint,pointA:CGPoint,pointB:CGPoint) ->CGPoint{
        let dAP = CGPoint(x:origin.x - pointA.x, y:origin.y - pointA.y);
        let dAB = CGPoint(x:pointB.x - pointA.x, y:pointB.y - pointA.y);
        let dot = dAP.x * dAB.x + dAP.y * dAB.y;
        let squareLength = dAB.x * dAB.x + dAB.y * dAB.y;
        let param = dot / squareLength;
        
        var nearestPoint = CGPoint()
        if (param < 0 || (pointA.x == pointB.x && pointA.y == pointB.y)) {
            nearestPoint.x = pointA.x;
            nearestPoint.y = pointA.y;
        } else if (param > 1) {
            nearestPoint.x = pointB.x;
            nearestPoint.y = pointB.y;
        } else {
            nearestPoint.x = pointA.x + param * dAB.x;
            nearestPoint.y = pointA.y + param * dAB.y;
        }
        return nearestPoint
    }
    
}
