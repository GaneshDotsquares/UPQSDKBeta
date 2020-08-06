//
//	AudioTextTypeModel.swift
//
//	Create by Mukesh Yadav on 24/1/2020

import UIKit


class AudioTextTypeModel: NSObject, NSCoding {

	var controlType: Int?
	var descriptionField: String?
	var displayName: String?
	var key: String?
	var options: [String]?
	var value: String?


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		controlType = dictionary["controlType"] as? Int
		descriptionField = dictionary["description"] as? String
		displayName = dictionary["displayName"] as? String
		key = dictionary["key"] as? String
		options = dictionary["options"] as? [String]
		value = dictionary["value"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if controlType != nil{
			dictionary["controlType"] = controlType
		}
		if descriptionField != nil{
			dictionary["description"] = descriptionField
		}
		if displayName != nil{
			dictionary["displayName"] = displayName
		}
		if key != nil{
			dictionary["key"] = key
		}
		if options != nil{
			dictionary["options"] = options
		}
		if value != nil{
			dictionary["value"] = value
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         controlType = aDecoder.decodeObject(forKey: "controlType") as? Int
         descriptionField = aDecoder.decodeObject(forKey: "description") as? String
         displayName = aDecoder.decodeObject(forKey: "displayName") as? String
         key = aDecoder.decodeObject(forKey: "key") as? String
         options = aDecoder.decodeObject(forKey: "options") as? [String]
         value = aDecoder.decodeObject(forKey: "value") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if controlType != nil{
			aCoder.encode(controlType, forKey: "controlType")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if displayName != nil{
			aCoder.encode(displayName, forKey: "displayName")
		}
		if key != nil{
			aCoder.encode(key, forKey: "key")
		}
		if options != nil{
			aCoder.encode(options, forKey: "options")
		}
		if value != nil{
			aCoder.encode(value, forKey: "value")
		}

	}

}
