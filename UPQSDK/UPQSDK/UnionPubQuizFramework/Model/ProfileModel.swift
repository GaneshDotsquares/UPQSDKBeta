//
//  ProfileModel.swift
//  RRApp
//
//  Created by Ganesh on 31/05/19.
//  Copyright © 2019 Dotsquares. All rights reserved.
//

import Foundation


class ProfileModel : NSObject, NSCoding{
    
    var createdDateTime : String!
    var emailAddress : String!
    var externalId : String!
    var facebookProfile : String!
    var firstName : String!
    var homeAddress : HomeAddres!
    var id : String!
    var linkedInProfile : String!
    var mobileNumber : String!
    var modifiedDateTime : String!
    var nickName : String!
    var surname : String!
    var twitterHandle : String!
    var station:String!
    var stationImage:String!
    var autoEnabledRecording:Bool!

    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        createdDateTime = dictionary["createdDateTime"] as? String
        emailAddress = dictionary["emailAddress"] as? String
        externalId = dictionary["externalId"] as? String
        facebookProfile = dictionary["facebookProfile"] as? String
        firstName = dictionary["firstName"] as? String
        if let homeAddressData = dictionary["homeAddress"] as? [String:Any]{
            homeAddress = HomeAddres(fromDictionary: homeAddressData)
        }
        id = dictionary["id"] as? String
        linkedInProfile = dictionary["linkedInProfile"] as? String
        mobileNumber = dictionary["mobileNumber"] as? String
        modifiedDateTime = dictionary["modifiedDateTime"] as? String
        nickName = dictionary["nickName"] as? String
        surname = dictionary["surname"] as? String
        twitterHandle = dictionary["twitterHandle"] as? String
        station = dictionary["station"] as? String ?? Utility.FirebaseTenent
        stationImage = dictionary["stationImage"] as? String ?? "dev"
        autoEnabledRecording = dictionary["autoEnabledRecording"] as? Bool ?? false
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if createdDateTime != nil{
            dictionary["createdDateTime"] = createdDateTime
        }
        if emailAddress != nil{
            dictionary["emailAddress"] = emailAddress
        }
        if externalId != nil{
            dictionary["externalId"] = externalId
        }
        if facebookProfile != nil{
            dictionary["facebookProfile"] = facebookProfile
        }
        if firstName != nil{
            dictionary["firstName"] = firstName
        }
        if homeAddress != nil{
            dictionary["homeAddress"] = homeAddress.toDictionary()
        }
        if id != nil{
            dictionary["id"] = id
        }
        if linkedInProfile != nil{
            dictionary["linkedInProfile"] = linkedInProfile
        }
        if mobileNumber != nil{
            dictionary["mobileNumber"] = mobileNumber
        }
        if modifiedDateTime != nil{
            dictionary["modifiedDateTime"] = modifiedDateTime
        }
        if nickName != nil{
            dictionary["nickName"] = nickName
        }
        if surname != nil{
            dictionary["surname"] = surname
        }
        if twitterHandle != nil{
            dictionary["twitterHandle"] = twitterHandle
        }
        
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        createdDateTime = aDecoder.decodeObject(forKey: "createdDateTime") as? String
        emailAddress = aDecoder.decodeObject(forKey: "emailAddress") as? String
        externalId = aDecoder.decodeObject(forKey: "externalId") as? String
        facebookProfile = aDecoder.decodeObject(forKey: "facebookProfile") as? String
        firstName = aDecoder.decodeObject(forKey: "firstName") as? String
        homeAddress = aDecoder.decodeObject(forKey: "homeAddress") as? HomeAddres
        id = aDecoder.decodeObject(forKey: "id") as? String
        linkedInProfile = aDecoder.decodeObject(forKey: "linkedInProfile") as? String
        mobileNumber = aDecoder.decodeObject(forKey: "mobileNumber") as? String
        modifiedDateTime = aDecoder.decodeObject(forKey: "modifiedDateTime") as? String
        nickName = aDecoder.decodeObject(forKey: "nickName") as? String
        surname = aDecoder.decodeObject(forKey: "surname") as? String
        twitterHandle = aDecoder.decodeObject(forKey: "twitterHandle") as? String
        stationImage = aDecoder.decodeObject(forKey: "stationImage") as? String
        station = aDecoder.decodeObject(forKey: "station") as? String
        autoEnabledRecording = aDecoder.decodeObject(forKey: "station") as? Bool
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if createdDateTime != nil{
            aCoder.encode(createdDateTime, forKey: "createdDateTime")
        }
        if emailAddress != nil{
            aCoder.encode(emailAddress, forKey: "emailAddress")
        }
        if externalId != nil{
            aCoder.encode(externalId, forKey: "externalId")
        }
        if facebookProfile != nil{
            aCoder.encode(facebookProfile, forKey: "facebookProfile")
        }
        if firstName != nil{
            aCoder.encode(firstName, forKey: "firstName")
        }
        if homeAddress != nil{
            aCoder.encode(homeAddress, forKey: "homeAddress")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if linkedInProfile != nil{
            aCoder.encode(linkedInProfile, forKey: "linkedInProfile")
        }
        if mobileNumber != nil{
            aCoder.encode(mobileNumber, forKey: "mobileNumber")
        }
        if modifiedDateTime != nil{
            aCoder.encode(modifiedDateTime, forKey: "modifiedDateTime")
        }
        if nickName != nil{
            aCoder.encode(nickName, forKey: "nickName")
        }
        if surname != nil{
            aCoder.encode(surname, forKey: "surname")
        }
        if twitterHandle != nil{
            aCoder.encode(twitterHandle, forKey: "twitterHandle")
        }
        if station != nil{
            aCoder.encode(station, forKey: "station")
        }
        if stationImage != nil{
            aCoder.encode(stationImage, forKey: "stationImage")
        }
        if autoEnabledRecording != nil{
            aCoder.encode(autoEnabledRecording, forKey: "autoEnabledRecording")
        }
 
    }
    
    
    
    
}


class HomeAddres : NSObject, NSCoding{
    
    var city : String!
    var country : String!
    var line1 : String!
    var line2 : String!
    var line3 : String!
    var postalCode : Int!
    var state : String!
    var suburb : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        city = dictionary["city"] as? String
        country = dictionary["country"] as? String
        line1 = dictionary["line1"] as? String
        line2 = dictionary["line2"] as? String
        line3 = dictionary["line3"] as? String
        postalCode = dictionary["postalCode"] as? Int
        state = dictionary["state"] as? String
        suburb = dictionary["suburb"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if city != nil{
            dictionary["city"] = city
        }
        if country != nil{
            dictionary["country"] = country
        }
        if line1 != nil{
            dictionary["line1"] = line1
        }
        if line2 != nil{
            dictionary["line2"] = line2
        }
        if line3 != nil{
            dictionary["line3"] = line3
        }
        if postalCode != nil{
            dictionary["postalCode"] = postalCode
        }
        if state != nil{
            dictionary["state"] = state
        }
        if suburb != nil{
            dictionary["suburb"] = suburb
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        city = aDecoder.decodeObject(forKey: "city") as? String
        country = aDecoder.decodeObject(forKey: "country") as? String
        line1 = aDecoder.decodeObject(forKey: "line1") as? String
        line2 = aDecoder.decodeObject(forKey: "line2") as? String
        line3 = aDecoder.decodeObject(forKey: "line3") as? String
        postalCode = aDecoder.decodeObject(forKey: "postalCode") as? Int
        state = aDecoder.decodeObject(forKey: "state") as? String
        suburb = aDecoder.decodeObject(forKey: "suburb") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if city != nil{
            aCoder.encode(city, forKey: "city")
        }
        if country != nil{
            aCoder.encode(country, forKey: "country")
        }
        if line1 != nil{
            aCoder.encode(line1, forKey: "line1")
        }
        if line2 != nil{
            aCoder.encode(line2, forKey: "line2")
        }
        if line3 != nil{
            aCoder.encode(line3, forKey: "line3")
        }
        if postalCode != nil{
            aCoder.encode(postalCode, forKey: "postalCode")
        }
        if state != nil{
            aCoder.encode(state, forKey: "state")
        }
        if suburb != nil{
            aCoder.encode(suburb, forKey: "suburb")
        }
        
    }
    
}
