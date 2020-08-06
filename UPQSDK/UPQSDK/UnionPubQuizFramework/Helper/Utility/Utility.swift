//
//  Utility.swift
//
//  Created by Ganesh on 31/5/19.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import SVProgressHUD
//import Firebase
 
//import FirebaseMessaging
import Speech

class Utility: NSObject
{
    
    class func setUnSeletectedtabBarColor() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
    }
    
    class var FirebaseTenent:String {
        set {
            UserDefaults.standard.set(newValue, forKey: "FirebaseTenent")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.object(forKey: "FirebaseTenent") as? String ??  "Test" //"UnionJack"
        }
    }
    
    class var isNewVersionApp:Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "isNewVersionApp")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.object(forKey: "isNewVersionApp") as? Bool ?? true
        }
    }
     
    //MARK:- ****************************** Dashboard Home VC *******************************************
    class func loadHomeVC()
    {
          Utility.isUserLoginBefore = true
        let storyboard=UIStoryboard(name: "UPQMain",bundle: Bundle(for: self))
        let dashboardNav = DashboardVC.getObject()
        storyboard.instantiateViewController(withIdentifier:"ProfileViewVC")
        DispatchQueue.main.async {
            UnionPubQuiz.rootController?.present(dashboardNav, animated: true)
        }
       
        
    }
    
    class func loadLoginVC()
    {
        Utility.isUserLoginBefore = false
        let tabBarVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"LoginVC")
        //  let tabBarVC = LoginRegister.instantiateViewController(withIdentifier:"signinController")
        UnionPubQuiz.rootController = tabBarVC
    }
    
    
    
    //MARK:-  ****************************** UserProfile model ******************************
    class func setUserProfileModel(loginModel object:ProfileModel)
    {
        let objectData = NSKeyedArchiver.archivedData(withRootObject: object)
        UserDefaults.standard.set(objectData, forKey: "UserProfile")
        Utility.isUserLoginBefore = true
        UserDefaults.standard.synchronize()
    }
    
    class func getUserProfileModel() -> ProfileModel?
    {
        guard let encodedobject:Data = UserDefaults.standard.object(forKey: "UserProfile") as? Data  else{return nil}
        let object: ProfileModel? = NSKeyedUnarchiver.unarchiveObject(with: encodedobject) as? ProfileModel
        if let model=object
        {
            return model
        }
         return nil
     }
    
    class func setBaseURlModel(loginModel object:[BaseUrlLinks])
    {
        let objectData = NSKeyedArchiver.archivedData(withRootObject: object)
        UserDefaults.standard.set(objectData, forKey: "BaseUrlLinksForApp")
        UserDefaults.standard.synchronize()
    }
    
    class func getBaseURlModel() -> [BaseUrlLinks]?
    {
        guard let encodedobject:Data = UserDefaults.standard.object(forKey: "BaseUrlLinksForApp") as? Data  else{return nil}
        let object: [BaseUrlLinks]? = NSKeyedUnarchiver.unarchiveObject(with: encodedobject) as? [BaseUrlLinks]
        if let model=object
        {
            return model
        }
        return nil
    }
    
    
    
    
    
    
    //MARK:-  ****************************** isAutoRecardingEnabled ******************************
    class  var isAutoRecardingEnabled:Bool{
        set{
            UserDefaults.standard.set(newValue, forKey: "isAutoRecardingEnabled")
            UserDefaults.standard.synchronize()
            
        }
        get{
            return  UserDefaults.standard.value(forKey: "isAutoRecardingEnabled") as? Bool ??  false
        }
    }
    
    
    //MARK:-  ****************************** device language code ******************************
    class  var deviceLanguageCode:String{
        set{
            UserDefaults.standard.set(newValue, forKey: "devicelanguagecode")
            UserDefaults.standard.synchronize()
        }
        get{
            let LC = UserDefaults.standard.value(forKey: "devicelanguagecode") as? String ?? "en-US"
            NSLog("devicelanguagecode ==== \(LC))")
            return LC
        }
    }
    
    //MARK:-  ****************************** location Permission Attemp ******************************
    class  var locationPermissionAttemp:Bool{
        set{
            UserDefaults.standard.set(newValue, forKey: "locationPermissionAttemp")
            UserDefaults.standard.synchronize()
        }
        get{
            let LC = UserDefaults.standard.value(forKey: "locationPermissionAttemp") as? Bool ?? false
            NSLog("locationPermissionAttemp ==== \(LC))")
            return LC
        }
    }
    
    
    class func getPreferredLocale() -> Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }
    //MARK:-  ****************************** Device token ******************************
    
    class func setDeviceToken(deviceToken: String)
    {
        UserDefaults.standard.set(deviceToken, forKey: "devicetoken")
    }
    
    class func getDeviceToken() -> String
    {
        guard let device=UserDefaults.standard.value(forKey: "devicetoken") as? String
            else{
                return  ""
        }
        return device
    }
    
    
    //MARK:-  ****************************** Access token ******************************
     
    class  var apiAccessToken:String{
           set{
               UserDefaults.standard.set(newValue, forKey: "apiAccessToken")
               UserDefaults.standard.synchronize()
           }
           get{
               let apiAccessToken = UserDefaults.standard.value(forKey: "apiAccessToken") as? String ?? "apiAccessToken is blank"
                return apiAccessToken
           }
       }
    
    
    //MARK:- Offset -
    class func getOffset()->Int{
        return TimeZone.current.secondsFromGMT()
    }
    
    
    //MARK:-  ****************************** Is User already login in  ******************************
     class  var isUserLoginBefore:Bool{
           set{
               UserDefaults.standard.set(newValue, forKey: "is_Login")
               UserDefaults.standard.synchronize()
           }
           get{
               let is_Login = UserDefaults.standard.bool(forKey: "is_Login")
                return is_Login
           }
       }
    
    
    
    //MARK:-  ******************************  Current Date Format ******************************
    class func getCurrentTime()->String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let arrStr = formatter.string(from: Date()).components(separatedBy: " ")
        let strTime: String = arrStr[0]
        // NSString *strSession = [arrStr objectAtIndex:1];
        return strTime
    }
    
    class func readJson(_ jsonFileName:String? = "CountryCodes") -> AnyObject? {
        var response: AnyObject?
        if let jsonPath: String = Bundle.main.path(forResource: jsonFileName, ofType: "json"), let jsonData: Data = NSData(contentsOfFile: jsonPath) as Data? {
            do {
                let object: AnyObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as AnyObject
                
                if let object = object as? [String: Any] {
                    // json is a dictionary
                    response = object as AnyObject
                    
                } else if let object = object as? [Any] {
                    // json is an array
                    response = object as AnyObject
                    
                } else {
                    print("JSON is invalid")
                }
                
            } catch {
                print("Error while deserialization of jsonData")
            }
        }
        return response
    }
    
    class func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        var strJson=String(data: data, encoding: String.Encoding.utf8)
        strJson=strJson?.replacingOccurrences(of: "\\/", with: "//")
        strJson=strJson?.replacingOccurrences(of: "//", with: "/")
        print(strJson ?? "")
        return strJson
    }
    
    
    class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    class func appVersion()->String{
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String ?? "1.0"
    }
    
    //MARK:-  ****************************** TextField related  Methods ******************************
       class func checkLimit(textField:UITextField,string:String,withCount:Int)->Bool
       {
           guard string != ""  else {return true }// If user is deleting something
           
           let name: String = textField.text!.appending(string)
           let currentCharacterCount = name.count
           return currentCharacterCount <= withCount
       }
    
    
    class func showHud(){
        DispatchQueue.main.async {
//            SVProgressHUD.show()
//            SVProgressHUD.setDefaultMaskType(.clear)
//            SVProgressHUD.setBackgroundColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
//            SVProgressHUD.setForegroundColor(themeColor)
        }
        
    }
    
    class func DismissHud(){
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    
    
    class func debugPrint(any:Any){
        print(any)
      }
 
}


class PlayBeepSound:NSObject{
    static var shared = PlayBeepSound(fromUrl: Bundle.main.url(forResource: "play", withExtension: "mp3"))
   // var player : AVPlayer!
    var beepSoundurl:URL!
    var beepAudioPlayer = AVAudioPlayer()
     
    init(fromUrl url: URL?){
        if let url =  url {
            beepSoundurl =  url
            beepAudioPlayer = try! AVAudioPlayer(contentsOf: url)
        }
        else{
            let beepSound  = Bundle.main.url(forResource: "play", withExtension: "mp3")
            beepAudioPlayer = try! AVAudioPlayer(contentsOf: url!)
            beepSoundurl =  beepSound
        }
        beepAudioPlayer.numberOfLoops = 0
        beepAudioPlayer.volume = 1.0
       // self.player = AVPlayer(playerItem:AVPlayerItem(url: beepSoundurl) )
      //  player?.rate = 1.0
       // player.playImmediately(atRate: 1.0)
       // player.volume = 1
    }
    func play(){
         print("gap check play sound",Date.timestamp)
       // player.automaticallyWaitsToMinimizeStalling = false;
        // player.play()
        beepAudioPlayer.play()
    }
}


