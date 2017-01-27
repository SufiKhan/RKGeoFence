//
//  Constants.swift
//  RKGeoFence
//
//  Created by Sierra Solutions Mac User 5 on 25/1/17.
//  Copyright © 2017 test. All rights reserved.
//

import Foundation


struct Constants {
    static let JSONFILENAME = "hub"
    static let FILETYPE = "json"
    static let GEOMETRY = "results.geometry"
    static let LAT = "lat"
    static let LNG = "lon"
    
    static let ACCURACY = 0.0
    
    static let BOUNDS = "results.bounds"
    static let MIN_LAT = "minlat"
    static let MIN_LNG = "minlon"
    static let MAX_LAT = "maxlat"
    static let MAX_LNG = "maxlon"
    
    static let SPAN_LEVEL = 0.01
    static let OUTSIDE =  "OTSIDE"
    static let INSIDE =  "INSIDE"
    static let OK =  "OK"
    static let OUTSIDE_HUB_ALERT = "You are outside the defined accuracy of the hub."
    static let INSIDE_HUB_ALERT = "You are inside the defined accuracy of the hub."
}
