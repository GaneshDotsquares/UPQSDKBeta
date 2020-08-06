//
//  ModelAwslogin.swift
//  RRApp
//
//  Created by Ganesh on 10/10/19.
//  Copyright © 2019 Dotsquares. All rights reserved.
//

import Foundation


class ModelAwslogin : NSObject, NSCoding{
    
    var accessToken : String!
    var aud : String!
    var authTime : Int!
    var cognitousername : String!
    var email : String!
    var emailVerified : Bool!
    var eventId : String!
    var exp : Int!
    var expirationTime : String!
    var iat : Int!
    var idToken : String!
    var iss : String!
    var name : String!
    var nickname : String!
    var refreshToken : String!
    var sub : String!
    var tokenUse : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
     //   Utility.json(from: dictionary)
        accessToken = dictionary["accessToken"] as? String
        aud = dictionary["aud"] as? String
        authTime = dictionary["auth_time"] as? Int
        cognitousername = dictionary["cognito:username"] as? String
        email = dictionary["email"] as? String
        emailVerified = dictionary["email_verified"] as? Bool
        eventId = dictionary["event_id"] as? String
        exp = dictionary["exp"] as? Int
        expirationTime = dictionary["expirationTime"] as? String
        iat = dictionary["iat"] as? Int
     
        if let token =  dictionary["id_token"] as? String{
              idToken = token
        }
        if let token =  dictionary["idToken"] as? String{
            idToken = token
        }
        if let token =  dictionary["accessToken"] as? String{
            accessToken = token
        }
        
        if let token =  dictionary["access_token"] as? String{
            accessToken = token
        }
        
        iss = dictionary["iss"] as? String
        name = dictionary["name"] as? String
        nickname = dictionary["nickname"] as? String
        refreshToken = dictionary["refreshToken"] as? String
        sub = dictionary["sub"] as? String
        tokenUse = dictionary["token_use"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if accessToken != nil{
            dictionary["accessToken"] = accessToken
        }
        
        if aud != nil{
            dictionary["aud"] = aud
        }
        if authTime != nil{
            dictionary["auth_time"] = authTime
        }
        if cognitousername != nil{
            dictionary["cognito:username"] = cognitousername
        }
        if email != nil{
            dictionary["email"] = email
        }
        if emailVerified != nil{
            dictionary["email_verified"] = emailVerified
        }
        if eventId != nil{
            dictionary["event_id"] = eventId
        }
        if exp != nil{
            dictionary["exp"] = exp
        }
        if expirationTime != nil{
            dictionary["expirationTime"] = expirationTime
        }
        if iat != nil{
            dictionary["iat"] = iat
        }
        if idToken != nil{
            dictionary["idToken"] = idToken
        }
        if iss != nil{
            dictionary["iss"] = iss
        }
        if name != nil{
            dictionary["name"] = name
        }
        if nickname != nil{
            dictionary["nickname"] = nickname
        }
        if refreshToken != nil{
            dictionary["refreshToken"] = refreshToken
        }
        if sub != nil{
            dictionary["sub"] = sub
        }
        if tokenUse != nil{
            dictionary["token_use"] = tokenUse
        }
        return dictionary
    }
    
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionaryForProfileModel() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if accessToken != nil{
            dictionary["accessToken"] = accessToken
        }
        
        if aud != nil{
            dictionary["aud"] = aud
        }
        if authTime != nil{
            dictionary["auth_time"] = authTime
        }
        if cognitousername != nil{
            dictionary["cognito:username"] = cognitousername
        }
        if email != nil{
            dictionary["emailAddress"] = email
        }
        if emailVerified != nil{
            dictionary["email_verified"] = emailVerified
        }
        if eventId != nil{
            dictionary["event_id"] = eventId
        }
        if exp != nil{
            dictionary["exp"] = exp
        }
        if expirationTime != nil{
            dictionary["expirationTime"] = expirationTime
        }
        if iat != nil{
            dictionary["iat"] = iat
        }
        if idToken != nil{
            dictionary["idToken"] = idToken
        }
        if iss != nil{
            dictionary["iss"] = iss
        }
        if name != nil{
            dictionary["name"] = name
        }
        if nickname != nil{
            dictionary["nickname"] = nickname
        }
        if refreshToken != nil{
            dictionary["refreshToken"] = refreshToken
        }
        if sub != nil{
            dictionary["sub"] = sub
        }
        if tokenUse != nil{
            dictionary["token_use"] = tokenUse
        }
        return dictionary
    }
    
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        accessToken = aDecoder.decodeObject(forKey: "accessToken") as? String
        aud = aDecoder.decodeObject(forKey: "aud") as? String
        authTime = aDecoder.decodeObject(forKey: "auth_time") as? Int
        cognitousername = aDecoder.decodeObject(forKey: "cognito:username") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        emailVerified = aDecoder.decodeObject(forKey: "email_verified") as? Bool
        eventId = aDecoder.decodeObject(forKey: "event_id") as? String
        exp = aDecoder.decodeObject(forKey: "exp") as? Int
        expirationTime = aDecoder.decodeObject(forKey: "expirationTime") as? String
        iat = aDecoder.decodeObject(forKey: "iat") as? Int
        idToken = aDecoder.decodeObject(forKey: "idToken") as? String
        iss = aDecoder.decodeObject(forKey: "iss") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        nickname = aDecoder.decodeObject(forKey: "nickname") as? String
        refreshToken = aDecoder.decodeObject(forKey: "refreshToken") as? String
        sub = aDecoder.decodeObject(forKey: "sub") as? String
        tokenUse = aDecoder.decodeObject(forKey: "token_use") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if accessToken != nil{
            aCoder.encode(accessToken, forKey: "accessToken")
        }
        if aud != nil{
            aCoder.encode(aud, forKey: "aud")
        }
        if authTime != nil{
            aCoder.encode(authTime, forKey: "auth_time")
        }
        if cognitousername != nil{
            aCoder.encode(cognitousername, forKey: "cognito:username")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if emailVerified != nil{
            aCoder.encode(emailVerified, forKey: "email_verified")
        }
        if eventId != nil{
            aCoder.encode(eventId, forKey: "event_id")
        }
        if exp != nil{
            aCoder.encode(exp, forKey: "exp")
        }
        if expirationTime != nil{
            aCoder.encode(expirationTime, forKey: "expirationTime")
        }
        if iat != nil{
            aCoder.encode(iat, forKey: "iat")
        }
        if idToken != nil{
            aCoder.encode(idToken, forKey: "idToken")
        }
        if iss != nil{
            aCoder.encode(iss, forKey: "iss")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if nickname != nil{
            aCoder.encode(nickname, forKey: "nickname")
        }
        if refreshToken != nil{
            aCoder.encode(refreshToken, forKey: "refreshToken")
        }
        if sub != nil{
            aCoder.encode(sub, forKey: "sub")
        }
        if tokenUse != nil{
            aCoder.encode(tokenUse, forKey: "token_use")
        }
        
    }
    
}
