 
import Foundation

class ModelISDCode : NSObject, NSCoding{

	var code : String!
	var dialCode : Int!
	var name : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		code = dictionary["code"] as? String ?? ""
       
		 let isdcode = dictionary["dial_code"] as? String ?? "0"
   //     print("dial code == %@",isdcode)
        dialCode =  Int(isdcode)
     //   print("dial code == %d",dialCode)
		name = dictionary["name"] as? String ?? ""
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if code != nil{
			dictionary["code"] = code
		}
		if dialCode != nil{
			dictionary["dial_code"] = dialCode
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
         code = aDecoder.decodeObject(forKey: "code") as? String
         dialCode = aDecoder.decodeObject(forKey: "dial_code") as? Int
         name = aDecoder.decodeObject(forKey: "name") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if code != nil{
			aCoder.encode(code, forKey: "code")
		}
		if dialCode != nil{
			aCoder.encode(dialCode, forKey: "dial_code")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}

	}

}
