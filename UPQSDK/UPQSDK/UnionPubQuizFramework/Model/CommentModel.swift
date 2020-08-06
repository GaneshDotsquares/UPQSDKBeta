//
//  CommentModel.swift
//  RRApp
//
//  Created by Ganesh on 18/06/19.
//  Copyright © 2019 Dotsquares. All rights reserved.
//

import Foundation
class CommentModel : NSObject, NSCoding{
    var comment : String!
    var latitude : String!
    var longitude : String!
    var name : String!
    var stationId : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        comment = dictionary["comment"] as? String
        latitude = dictionary["latitude"] as? String
        longitude = dictionary["longitude"] as? String
        name = dictionary["name"] as? String
        stationId = dictionary["stationId"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if comment != nil{
            dictionary["comment"] = comment
        }
        if latitude != nil{
            dictionary["latitude"] = latitude
        }
        if longitude != nil{
            dictionary["longitude"] = longitude
        }
        if name != nil{
            dictionary["name"] = name
        }
        if stationId != nil{
            dictionary["stationId"] = stationId
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        comment = aDecoder.decodeObject(forKey: "comment") as? String
        latitude = aDecoder.decodeObject(forKey: "latitude") as? String
        longitude = aDecoder.decodeObject(forKey: "longitude") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        stationId = aDecoder.decodeObject(forKey: "stationId") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if comment != nil{
            aCoder.encode(comment, forKey: "comment")
        }
        if latitude != nil{
            aCoder.encode(latitude, forKey: "latitude")
        }
        if longitude != nil{
            aCoder.encode(longitude, forKey: "longitude")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if stationId != nil{
            aCoder.encode(stationId, forKey: "stationId")
        }
        
    }
    
}


class Coordinate : NSObject, NSCoding{
    
    var latitude : Double!
    var longitude : Double!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        latitude = dictionary["latitude"] as? Double
        longitude = dictionary["longitude"] as? Double
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if latitude != nil{
            dictionary["latitude"] = latitude
        }
        if longitude != nil{
            dictionary["longitude"] = longitude
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        latitude = aDecoder.decodeObject(forKey: "latitude") as? Double
        longitude = aDecoder.decodeObject(forKey: "longitude") as? Double
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if latitude != nil{
            aCoder.encode(latitude, forKey: "latitude")
        }
        if longitude != nil{
            aCoder.encode(longitude, forKey: "longitude")
        }
        
    }
    
}
