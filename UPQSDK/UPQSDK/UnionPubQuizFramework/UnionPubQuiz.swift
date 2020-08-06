//
//  StringFile.swift
//  UnionPubQuizFramework
//
//  Created by Ganesh on 24/06/20.
//  Copyright © 2020 Dotsquares. All rights reserved.
//

import UIKit

public class UnionPubQuiz: NSObject {
    
    public static let sharedInstance = UnionPubQuiz()
    public static var rootController : UIViewController?
    public  var isMicListening:((_ status:Bool)->())?

    
    private override init() {// Prevents using the default '()' initializer
        super.init()
    }
    
    public var appdelegate : UIApplicationDelegate!
    public func printString(_ str:String = ""){
        print(str)
    }
    
    public func apiCogiguration(_ viewController:UIViewController){
        UnionPubQuiz.rootController = viewController
        WebServiceHelper.setupApiToken()
          WebServiceHelper.fetchBaseUrl()
    }
    
    public func loginUser(socialLoginid:String, email:String,  firstName:String, lastName:String?,   nickName:String?,  profileImageUrl:String?,  isAppleLogin:Bool = false){
        
        let model = SocialModel(email: email, userId: socialLoginid, idToken: socialLoginid, fullName: String(format: "%@ %@", firstName, lastName ?? ""), givenName: firstName, imageURL: profileImageUrl ?? "", firstName: firstName, lastName: lastName)
        WebServiceHelper.callIsUserNewApi(params: model, loginType: isAppleLogin ? .Apple :.Facebook)
        
    }
    
}
