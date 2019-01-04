//
//  GeoPoint.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2019 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

import SwiftyJSON

@objcMembers open class GeoPoint: NSObject, NSCoding, Codable {
    
    open private(set) var objectId: String
    open private(set) var latitude: Double
    open private(set) var longitude: Double
    open private(set) var categories: [String]
    private var _metadata: JSON?
    open private(set) var metadata: [String: Any]? {
        get {
            return self._metadata?.dictionaryObject
        }
        set {
            if metadata != nil {
                self._metadata = JSON(metadata!)
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case objectId
        case latitude
        case longitude
        case categories
        case _metadata = "metadata"
    }
    
    public init(latitude: Double, longitude: Double) {
        self.objectId = ""
        self.latitude = latitude
        self.longitude = longitude
        self.categories = ["Default"]
    }
    
    public init(latitude: Double, longitude: Double, categories: [String]) {
        self.objectId = ""
        self.latitude = latitude
        self.longitude = longitude
        self.categories = categories
    }
    
    public init (latitude: Double, longitude: Double, metadata: [String: Any]) {
            self.objectId = ""
            self.latitude = latitude
            self.longitude = longitude
            self.categories = ["Default"]
            self._metadata = JSON(metadata)
        }
    
        public init (latitude: Double, longitude: Double, categories: [String], metadata: [String: Any]) {
            self.objectId = ""
            self.latitude = latitude
            self.longitude = longitude
            self.categories = categories
            self._metadata = JSON(metadata)
        }
    
    init(objectId: String, latitude: Double, longitude: Double, categories: [String], metadata: JSON?) {
        self.objectId = objectId
        self.latitude = latitude
        self.longitude = longitude
        self.categories = categories
        self._metadata = metadata
    }
    
    convenience required public init?(coder aDecoder: NSCoder) {
        let objectId = aDecoder.decodeObject(forKey: CodingKeys.objectId.rawValue) as! String
        let latitude = aDecoder.decodeDouble(forKey: CodingKeys.latitude.rawValue)
        let longitude = aDecoder.decodeDouble(forKey: CodingKeys.longitude.rawValue)
        let categories = aDecoder.decodeObject(forKey: CodingKeys.categories.rawValue) as! [String]
        let metadata = aDecoder.decodeObject(forKey: CodingKeys._metadata.rawValue) as? JSON
        self.init(objectId: objectId, latitude: latitude, longitude: longitude, categories: categories, metadata: metadata)
    }
    
    required public override init() {
        self.objectId = ""
        self.latitude = 0.0
        self.longitude = 0.0
        self.categories = ["Default"]
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(objectId, forKey: CodingKeys.objectId.rawValue)
        aCoder.encode(latitude, forKey: CodingKeys.latitude.rawValue)
        aCoder.encode(longitude, forKey: CodingKeys.longitude.rawValue)
        aCoder.encode(categories, forKey: CodingKeys.categories.rawValue)
        aCoder.encode(_metadata, forKey: CodingKeys.categories.rawValue)
    }
}
