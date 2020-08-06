//
//  AllCommtentModel.swift
//  RRApp
//
//  Created by Ganesh on 18/06/19.
//  Copyright © 2019 Dotsquares. All rights reserved.
//

import Foundation


class AllCommtentModel : NSObject, NSCoding{
    
    var allData : [CommentModel]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
      allData = [CommentModel]()
       if let allData = dictionary["allData"] as? [[String:Any]]{
            for dic in allData{
                let commentModel = CommentModel(fromDictionary: dic)
                self.allData.append(commentModel)
            }
        }
        
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        
        var dictionary = [String:Any]()
        if allData != nil{
            var dictionaryElements = [[String:Any]]()
            for commentModel in allData {
                dictionaryElements.append(commentModel.toDictionary())
            }
            dictionary["allData"] = dictionaryElements
        }
        
        
        
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        allData = aDecoder.decodeObject(forKey: "allData") as? [CommentModel]
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if allData != nil{
            aCoder.encode(allData, forKey: "allData")
        }
        
    }
    
}
