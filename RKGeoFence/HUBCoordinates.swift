//
//  HUBCoordinates.swift
//  RKGeoFence
//
//  Created by Sierra Solutions Mac User 5 on 25/1/17.
//  Copyright © 2017 test. All rights reserved.
//

import CoreLocation

class HUBCoordinates {
    func getCoordinatesForGeofence(callback:([CLLocationCoordinate2D],CLLocationCoordinate2D?)->()){
        if let path = Bundle.main.path(forResource: Constants.JSONFILENAME, ofType: Constants.FILETYPE)
        {
            do{
                let jsonData: NSData = try NSData(contentsOfFile: path, options: .mappedIfSafe)
                if let json: NSDictionary = try JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments) as? NSDictionary{
                    
                    if let geometry =  json.value(forKeyPath: Constants.GEOMETRY) as? [[NSDictionary]]{
                        var arrayCoordinates = [CLLocationCoordinate2D]()
                        for subArray in geometry{
                            for dic in subArray{
                                let coordinate = CLLocationCoordinate2DMake((dic[Constants.LAT] as? CLLocationDegrees)!, (dic[Constants.LNG] as? CLLocationDegrees)!)
                                arrayCoordinates.append(coordinate)
                                }
                            }
                            callback(arrayCoordinates,self.getFocusedRegion(json)!)
                        }
                }
            
            }catch{
                callback([],nil)
            }
        }
        callback([],nil)
    }
    
    func getFocusedRegion(_ json: NSDictionary) -> CLLocationCoordinate2D?{
        if let bounds =  json.value(forKeyPath: Constants.BOUNDS) as? NSDictionary{
            let minLat = bounds[Constants.MIN_LAT] as? Double
            let maxLat = bounds[Constants.MAX_LAT] as? Double
            let minLng = bounds[Constants.MIN_LNG] as? Double
            let maxLng = bounds[Constants.MAX_LNG] as? Double
            let center = CLLocationCoordinate2DMake((maxLat! + minLat!) * 0.5, (maxLng! + minLng!) * 0.5)
            return center
        }
        return nil
    }
}
