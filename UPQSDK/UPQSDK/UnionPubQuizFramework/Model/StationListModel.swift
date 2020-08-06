//
//  StationListModel.swift
//  RRApp
//
//  Created by Ganesh on 20/06/19.
//  Copyright © 2019 Dotsquares. All rights reserved.
//

import Foundation


class FavStationListModel : NSObject, NSCoding{
    
    var allFavList : [StationListModel]!
    var favItem : StationListModel!

    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        allFavList = [StationListModel]()
        if let allFavListArray = dictionary["AllFavList"] as? [[String:Any]]{
            for dic in allFavListArray{
                let value = StationListModel(fromDictionary: dic)
                allFavList.append(value)
            }
        }
        
        if let favItemData = dictionary["favItem"] as? [String:Any]{
            favItem = StationListModel(fromDictionary: favItemData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if allFavList != nil{
            var dictionaryElements = [[String:Any]]()
            for allFavListElement in allFavList {
                dictionaryElements.append(allFavListElement.toDictionary())
            }
            dictionary["AllFavList"] = dictionaryElements
        }
        
        if favItem != nil{
            dictionary["favItem"] = favItem.toDictionary()
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        allFavList = aDecoder.decodeObject(forKey :"AllFavList") as? [StationListModel]
        favItem = aDecoder.decodeObject(forKey: "favItem") as? StationListModel

    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if allFavList != nil{
            aCoder.encode(allFavList, forKey: "AllFavList")
        }
        if favItem != nil{
            aCoder.encode(favItem, forKey: "favItem")
        }
    }
    
}



class StationListModel : NSObject, NSCoding{
    
    var androidApp : String!
    var Calender_url : String!
    var commentUrl : String!
    var id : String!
    var image : String!
    var iosApp : String!
    var name : String!
    var pollUrl : String!
    var socketUrl : String!
    var tenent : String!
    var modes : [FMMode]!
    var websocket : String!
    var currentMode = 0
    
     /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
       
        Calender_url = dictionary["Calender_url"] as? String
        androidApp = dictionary["AndroidApp"] as? String
        commentUrl = dictionary["CommentUrl"] as? String
        id = dictionary["Id"] as? String
        image = dictionary["Image"] as? String
        iosApp = dictionary["IosApp"] as? String
        name = dictionary["Name"] as? String
        pollUrl = dictionary["PollUrl"] as? String
        socketUrl = dictionary["SocketUrl"] as? String ?? Utility.FirebaseTenent
        
        tenent = dictionary["Tenent"] as? String
        modes = [FMMode]()
        if let modesArray = dictionary["modes"] as? [[String:Any]]{
            for dic in modesArray{
                let value = FMMode(fromDictionary: dic)
                modes.append(value)
            }
        }
        websocket = dictionary["websocket"] as? String
 
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        
        
        
        if Calender_url != nil{
            dictionary["Calender_url"] = Calender_url
        }
        
        if androidApp != nil{
            dictionary["AndroidApp"] = androidApp
        }
        if commentUrl != nil{
            dictionary["CommentUrl"] = commentUrl
        }
        if id != nil{
            dictionary["Id"] = id
        }
        if image != nil{
            dictionary["Image"] = image
        }
        if iosApp != nil{
            dictionary["IosApp"] = iosApp
        }
        if name != nil{
            dictionary["Name"] = name
        }
        if pollUrl != nil{
            dictionary["PollUrl"] = pollUrl
        }
        if socketUrl != nil{
            dictionary["SocketUrl"] = socketUrl
        }
        if tenent != nil{
            dictionary["Tenent"] = tenent
        }
        if modes != nil{
            var dictionaryElements = [[String:Any]]()
            for modesElement in modes {
                dictionaryElements.append(modesElement.toDictionary())
            }
            dictionary["modes"] = dictionaryElements
        }
        if websocket != nil{
            dictionary["websocket"] = websocket
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
       
        
        Calender_url = aDecoder.decodeObject(forKey: "Calender_url") as? String

        androidApp = aDecoder.decodeObject(forKey: "AndroidApp") as? String
        commentUrl = aDecoder.decodeObject(forKey: "CommentUrl") as? String
        id = aDecoder.decodeObject(forKey: "Id") as? String
        image = aDecoder.decodeObject(forKey: "Image") as? String
        iosApp = aDecoder.decodeObject(forKey: "IosApp") as? String
        name = aDecoder.decodeObject(forKey: "Name") as? String
        pollUrl = aDecoder.decodeObject(forKey: "PollUrl") as? String
        socketUrl = aDecoder.decodeObject(forKey: "SocketUrl") as? String
        tenent = aDecoder.decodeObject(forKey: "Tenent") as? String
        modes = aDecoder.decodeObject(forKey :"modes") as? [FMMode]
        websocket = aDecoder.decodeObject(forKey: "websocket") as? String
 
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
       
      
        
        if Calender_url != nil{
            aCoder.encode(Calender_url, forKey: "Calender_url")
        }
        
        if androidApp != nil{
            aCoder.encode(androidApp, forKey: "AndroidApp")
        }
        if commentUrl != nil{
            aCoder.encode(commentUrl, forKey: "CommentUrl")
        }
        if id != nil{
            aCoder.encode(id, forKey: "Id")
        }
        if image != nil{
            aCoder.encode(image, forKey: "Image")
        }
        if iosApp != nil{
            aCoder.encode(iosApp, forKey: "IosApp")
        }
        if name != nil{
            aCoder.encode(name, forKey: "Name")
        }
        if pollUrl != nil{
            aCoder.encode(pollUrl, forKey: "PollUrl")
        }
        if socketUrl != nil{
            aCoder.encode(socketUrl, forKey: "SocketUrl")
        }
        if tenent != nil{
            aCoder.encode(tenent, forKey: "Tenent")
        }
        if modes != nil{
            aCoder.encode(modes, forKey: "modes")
        }
        if websocket != nil{
            aCoder.encode(websocket, forKey: "websocket")
        }
        
    }
    
}

class FMMode : NSObject, NSCoding{
    
    var delay : String!
    var name : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        delay = dictionary["delay"] as? String
        name = dictionary["name"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if delay != nil{
            dictionary["delay"] = delay
        }
        if name != nil{
            dictionary["name"] = name
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        delay = aDecoder.decodeObject(forKey: "delay") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if delay != nil{
            aCoder.encode(delay, forKey: "delay")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        
    }
    
}
