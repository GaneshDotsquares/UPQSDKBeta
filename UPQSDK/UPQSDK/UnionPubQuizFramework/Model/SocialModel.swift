//
//  LoginModel.swift
//  UnionPubQuizFramework
//
//  Created by Ganesh on 25/06/20.
//  Copyright © 2020 Dotsquares. All rights reserved.
//

import Foundation

internal class SocialModel : NSObject{
   
   var userId : String!
   var idToken : String!
   var email : String!
   var fullName : String!
   var givenName : String!
   var fName : String!
   var lName : String!
   
   var imageURL : String! = ""
   
   override init() {
       super.init()
   }
   /**
    * Instantiate the instance using the passed parameter values to set the properties values
    */
   
   init(email:String,userId:String,idToken:String,fullName:String,givenName:String,imageURL : String, firstName:String?,lastName : String?){
       
       self.email = email
       self.userId = userId
       self.idToken = idToken
       self.fullName = fullName
       self.givenName = givenName
       self.imageURL = imageURL
       self.fName = firstName
       self.lName = lastName
       
   }
   /**
    * Instantiate the instance using the passed dictionary values to set the properties values
    */
   init(fromDictionary dictionary: [String:Any]){
       
       email = dictionary["Email"] as? String
       userId = dictionary["UserId"] as? String
       idToken = dictionary["idToken"] as? String
       fullName = dictionary["fullName"] as? String
       givenName = dictionary["givenName"] as? String
       imageURL = dictionary["imageURL"] as? String
       fName = dictionary["first_name"] as? String
       lName = dictionary["last_name"] as? String
   }
   
   /**
    * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
    */
   func toDictionary() -> [String:Any]
   {
       var dictionary = [String:Any]()
       
       if email != nil{
           dictionary["Email"] = email
       }
       if userId != nil{
           dictionary["UserId"] = userId
       }
       if idToken != nil{
           dictionary["idToken"] = idToken
       }
       if fullName != nil{
           dictionary["fullName"] = fullName
       }
       if givenName != nil{
           dictionary["givenName"] = givenName
       }
       if imageURL != nil{
           dictionary["imageURL"] = imageURL
       }
       if fName != nil{
           dictionary["first_name"] = fName
       }
       if lName != nil{
           dictionary["last_name"] = lName
       }
       
       return dictionary
   }
}
