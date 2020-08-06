//
//  CommentReqModel.swift
//  RRApp
//
//  Created by Parveen on 09/01/20.
//  Copyright © 2020 Dotsquares. All rights reserved.
//

import UIKit

class CommentReqModel: NSObject, NSCoding {
    
    var coordinate : CoordinateModel!
    var emailAddress : String!
    var firstName : String!
    var surname : String!
    var tenant : String!
    var text : String!
    var userId : String!
    var audioFormat : String!
    var audioRecording : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let coordinateData = dictionary["coordinate"] as? [String:Any]{
            coordinate = CoordinateModel(fromDictionary: coordinateData)
        }
        emailAddress = dictionary["emailAddress"] as? String
        firstName = dictionary["firstName"] as? String
        surname = dictionary["surname"] as? String
        tenant = dictionary["tenant"] as? String
        text = dictionary["text"] as? String
        userId = dictionary["userId"] as? String
        audioFormat = dictionary["audioFormat"] as? String
        audioRecording  = dictionary["audioRecording"] as? String
        
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if coordinate != nil{
            dictionary["coordinate"] = coordinate.toDictionary()
        }
        if emailAddress != nil{
            dictionary["emailAddress"] = emailAddress
        }
        if firstName != nil{
            dictionary["firstName"] = firstName
        }
        if surname != nil{
            dictionary["surname"] = surname
        }
        if tenant != nil{
            dictionary["tenant"] = tenant
        }
        if text != nil{
            dictionary["text"] = text
        }
        if userId != nil{
            dictionary["userId"] = userId
        }
        if audioFormat != nil{
            dictionary["audioFormat"] = audioFormat
        }
        if audioRecording != nil{
            dictionary["audioRecording"] = audioRecording
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        coordinate = aDecoder.decodeObject(forKey: "coordinate") as? CoordinateModel
        emailAddress = aDecoder.decodeObject(forKey: "emailAddress") as? String
        firstName = aDecoder.decodeObject(forKey: "firstName") as? String
        surname = aDecoder.decodeObject(forKey: "surname") as? String
        tenant = aDecoder.decodeObject(forKey: "tenant") as? String
        text = aDecoder.decodeObject(forKey: "text") as? String
        userId = aDecoder.decodeObject(forKey: "userId") as? String
        audioFormat = aDecoder.decodeObject(forKey: "audioFormat") as? String
        audioRecording = aDecoder.decodeObject(forKey: "audioRecording") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if coordinate != nil{
            aCoder.encode(coordinate, forKey: "coordinate")
        }
        if emailAddress != nil{
            aCoder.encode(emailAddress, forKey: "emailAddress")
        }
        if firstName != nil{
            aCoder.encode(firstName, forKey: "firstName")
        }
        if surname != nil{
            aCoder.encode(surname, forKey: "surname")
        }
        if tenant != nil{
            aCoder.encode(tenant, forKey: "tenant")
        }
        if text != nil{
            aCoder.encode(text, forKey: "text")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "userId")
        }
        if audioFormat != nil{
            aCoder.encode(audioFormat, forKey: "audioFormat")
        }
        if audioRecording != nil{
            aCoder.encode(audioRecording, forKey: "audioRecording")
        }
        
    }
    
}


class CoordinateModel : NSObject, NSCoding{
    
    var latitude : Float!
    var longitude : Float!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        latitude = dictionary["latitude"] as? Float
        longitude = dictionary["longitude"] as? Float
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
        latitude = aDecoder.decodeObject(forKey: "latitude") as? Float
        longitude = aDecoder.decodeObject(forKey: "longitude") as? Float
        
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
