
import UIKit
import Foundation
import SystemConfiguration
import SVProgressHUD
public enum URLType: String
{
    case BASE_URL_identity = "https://identity.rrapp.co.za"
    case BASE_URL_USER = "https://user.rrapp.co.za"  
    case BASE_URL_POLL = "https://poll.rrapp.co.za"
    case BASE_URL_COMENT="https://comment.rrapp.co.za"
    case BASE_GetAllStationList = "https://qb988yoj4f.execute-api.us-east-2.amazonaws.com/default/stations_list"
    case GetStationList =  "https://b3iupe2vcf.execute-api.eu-west-2.amazonaws.com/default/getstationsjason"
    //https://afyprizmqe.execute-api.eu-west-2.amazonaws.com/default/getstetionfroms3"
    case newGetUserProfile = "https://mqsqokk8e0.execute-api.eu-west-2.amazonaws.com/default/getProfile"
    
    case fetchBase_URL = "https://rrapp-endpoint-uk.azurewebsites.net/api/Endpoint?region="
}

class WebServiceHelper: NSObject
{
    
    class func getBaseUrl()->String {
//        var obj = Configuration()
//        let url =  obj.environment.baseUrl
//        return url
        return ""
    }
    
    //method for release mode to remove print for release version.
    //    func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    //     //   Swift.print(items[0], separator:separator, terminator: terminator)
    //    }
    
    
    //MARK:- //***** POST Request ***** /
    
    /*
     *  Below method is used to send Post request to server.
     */
    static func postRequest(httpMethod:HttpMethod, method: String, params: AnyObject,canShowHud:Bool,key:String = "", completionHandler: @escaping (_ statusCode:Int, _ status: Bool, _ response: AnyObject, _ error: NSError?) -> ())
    {
        guard isInternetAvailable()==true else {
            if method.contains(EndType.SendComment.rawValue){
            //  WebServiceHelper.setCommentInLocal(params)
                completionHandler(404,false, [] as AnyObject, nil)
            }
            else{
                completionHandler(404,false, [] as AnyObject, nil)
                    UnionPubQuiz.rootController?.presentAlertWith(message:"No internet connection found")

            }
         
            
            return
        }
        if canShowHud{
            
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.clear)
        }
        
        // Set up create URL Session
        let session = URLSession.shared
        //  let endURL  = URLType.liveURL.rawValue+method
        let endURL  =  method//Utility.get_User_base_url() + method
        
       NSLog("endPointURL %@", endURL)
        
        //NSLog json request
        /*
         *  Below method is used to NSLog request in JSON Format.
         */
       NSLogJsonRequest(params: params)
        
        
        guard let url = URL(string: endURL) else {
            NSLog("Get an error")
            return
        }
        
        let urlRequest = NSMutableURLRequest(url: url)
        
        //Call method
        setUpHeader(urlRequest: urlRequest, method: httpMethod.rawValue,key: key)
        
        
        do {
            if urlRequest.url?.description.contains("token") == true {
                let postData = NSMutableData(data: "grant_type=client_credentials".data(using: String.Encoding.utf8)!)
                postData.append("&scope=api1".data(using: String.Encoding.utf8)!)
                urlRequest.httpBody = postData as Data
            }else{
                if !method.contains("Tenant"){
                   urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
                }
                
            }
        } catch {
            NSLog(error.localizedDescription)
        }
        
        // **** Make the request **** //
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) in
            // make sure we got data
            
            if canShowHud{
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
            }
            
            guard let httpResponse = response as? HTTPURLResponse else{ return  }
        //    NSLog("Response code == \(httpResponse.statusCode)")
            var jsonResult: NSMutableDictionary!
            do {
             //   NSLog(String(data: data!, encoding: String.Encoding.utf8)!)
                jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSMutableDictionary
               
                jsonResult?.setValue(httpResponse.statusCode, forKey: "ResponseCode")
                if jsonResult == nil {
                    jsonResult=NSMutableDictionary()
                     jsonResult?.setValue(httpResponse.statusCode, forKey: "ResponseCode")
                    let array = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSArray
                    jsonResult.setValue(array, forKey: "data")
                }
                NSLog("\(String(describing: jsonResult))")
                //MARK:-  Parsed received json using helper method
                /*
                 *  Below method is used to parse response received from server.
                 */
                WebServiceHelper.jsonParsing(jsonResult: jsonResult, completionHandler: completionHandler)
            } catch _ {
                completionHandler(httpResponse.statusCode,false, [:] as AnyObject, nil)
            }
            
            
        })
        task.resume()
        
    }
    //MARK:- Set up Header
    static func setUpHeader(urlRequest:NSMutableURLRequest,method:String,key:String = "")
    {
        urlRequest.httpMethod = method//"POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
//        //Set X function key in header
//        if key == ""{
//            urlRequest.setValue(Utility.getAccessToken(), forHTTPHeaderField: "X-Functions-Key")
//        }
//        else{
//            urlRequest.setValue(key, forHTTPHeaderField: "X-Functions-Key")
//        }
//
//
//        if urlRequest.url?.description.contains("token") == true {
//            urlRequest.setValue("Basic bXZjOnNlY3JldA==", forHTTPHeaderField: "Authorization")
//            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        }
//
//
//        else{
//            let tokenStr = String(format: "Bearer %@", Utility.getAccessToken())
//            urlRequest.setValue(tokenStr, forHTTPHeaderField: "Authorization")
//
//        }

        
        //Set X function key in header
        if urlRequest.url?.description.contains("token") == true {
            urlRequest.setValue("Basic bXZjOnNlY3JldA==", forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        else if ( urlRequest.url?.description.contains("Endpoint") ==  true ){
            urlRequest.setValue("U/PwgeBVZeu6ySUIdGlfZuhtvxTlbCt2T3fqHfawahSIqR11aLvGcg==", forHTTPHeaderField: "X-Functions-Key")
        }
        else  {
            if key == ""{
                urlRequest.setValue(Utility.apiAccessToken, forHTTPHeaderField: "Authorization")
            }
            else{
                urlRequest.setValue(key, forHTTPHeaderField: "X-Functions-Key")
            }
        }
         //  print("all header value === \(urlRequest.allHTTPHeaderFields!)")
    }
    
   
    
    
    
    
    // here is not set acccess token for header in url request
    static  func notsetAccessTokenForHeader(urlRequest:NSMutableURLRequest,method:String){
        //        if method ==  Constant.kCOUNTRIESWITHFLAGS ||  method ==  Constant.kLOGIN
        //        {
        //            urlRequest.setValue(nil, forHTTPHeaderField: "Authorization")
        //         }
    }
    
    
    //MARK:- //***** GET Request ***** //
    /*
     *  Below method is used to send GET request to server.
     */
    static func getRequest(method: String, params: AnyObject?,isQueryParameter:Bool=true, canShowHud:Bool=true,key:String = "", completionHandler: @escaping (_ statusCode:Int, _ status: Bool, _ response: AnyObject?, _ error: NSError?) -> ())
    {
        
        guard isInternetAvailable()==true else {
            
            UnionPubQuiz.rootController?.presentAlertWith(message:"No internet connection found")
            return
        }
       
        //   Below block is used to test whether method param is dictionary or not.
        
        guard let dictionary=params as? NSDictionary else {
            
            
           // SVProgressHUD.dismiss()
             UnionPubQuiz.rootController?.presentAlertWith(message: "Parameter is not NSDictionary")
            return
        }
        
        var baseUrl=method+"?"
        
        for (key, value) in dictionary
        {
            NSLog("key: \(key)")
            NSLog("value= \(value)")
            baseUrl=baseUrl+"\(key)=\(value)&"
        }
        baseUrl=baseUrl.substring(to: baseUrl.index(before: baseUrl.endIndex))
        baseUrl=baseUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        // let baseUrl=WebServiceHelper.getBaseUrl()+method
        NSLog("end Url \n \(baseUrl)")
        
        let url = NSURL(string: baseUrl)
        
        let request = NSMutableURLRequest(url: url! as URL)
        
        //call method
        setUpHeader(urlRequest: request, method: "GET",key: key)
        let err : NSError?
        err = nil
        
        //NSLog json request
        /*
         *  Below method is used to NSLog request in JSON Format.
         */
        
        
        if canShowHud{
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.clear)
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            let error: AutoreleasingUnsafeMutablePointer<NSError?>? = nil
           guard let httpResponse = response as? HTTPURLResponse else { return   completionHandler(404,false, nil, err) }
           //  NSLog("Response code *************** \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 204  {//method.hasPrefix("https://user.rrapp.co.za/api/User")
                 WebServiceHelper.getToken()
                completionHandler(httpResponse.statusCode,false, response, nil)
                return
            }
            if httpResponse.statusCode == 401{
                DispatchQueue.main.async(execute: {
                    Utility.DismissHud()
                    WebServiceHelper.getToken()
                })
                return
            }
            if httpResponse.statusCode == 200, data != nil{
                var jsonResult: NSDictionary!
                jsonResult = nil
                do {
                    NSLog(String(data: data!, encoding: String.Encoding.utf8)!)
                    jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    jsonResult.setValue(httpResponse.statusCode, forKey: "ResponseCode")
                    NSLog("\(String(describing: jsonResult))")
                    //MARK:-  Parsed received json using helper method
                    /*
                     *  Below method is used to parse response received from server.
                     */
                    WebServiceHelper.jsonParsing(jsonResult: jsonResult, completionHandler: completionHandler)
                } catch _ {
                }
                
            }
            else if error != nil{
                DispatchQueue.main.async{
                   WebServiceHelper.getToken()
                    completionHandler(httpResponse.statusCode,false, nil, err)
                }
            }
            else{
                DispatchQueue.main.async{
                    WebServiceHelper.getToken()
                    completionHandler(httpResponse.statusCode,false, nil, err)
                }
            }
            
        }
        task.resume()
        
        
    }
    
    //MARK:- //***** MULTI-PART Request ***** //
    /*
     *  Below method is used to send MULTI-PART request to server.
     */
    static func multiPartMedia(method: String,  images : UIImage, params : NSDictionary , completeBlock:@escaping (_ statusCode:Int, _ status : Bool, _ data : AnyObject?, _ error : NSError?)->())
    {
        guard isInternetAvailable()==true else {
            
            UnionPubQuiz.rootController?.presentAlertWith(message: "No internet connection found")
            return
        }
        
        let boundary = generateBoundaryString()
        
        let arrImageData = NSMutableArray()
        
        //        for img in images{
        let dictImage = NSMutableDictionary()
        let data = images.jpegData(compressionQuality: 0.5)
        dictImage.setObject("PatientPhoto\(Date()).png", forKey: "Filename" as NSCopying)
        dictImage.setObject(data! , forKey: "Image" as NSCopying)
        arrImageData.add(dictImage)
        //}
        
        
        //let arrImageData = NSArray(object: dictImage)
        
        let bodyData = createBodyWithParameters(params as? [String : AnyObject], filePathKey: "Image", files: arrImageData as! Array<Dictionary<String, AnyObject>>, boundary: boundary, image: data!)
        
        // Set up create URL session
        let session = URLSession.shared
        // let endURL  = URLType.liveURL.rawValue + method
        let endURL  = WebServiceHelper.getBaseUrl() + method
        NSLog("endPointURL ", endURL)
        NSLog("params ", params)
        
        guard let url = URL(string: endURL) else {
            NSLog("Get an error")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        //  urlRequest.addValue("8bit", forHTTPHeaderField: "Content-Transfer-Encoding")
        urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = bodyData
        urlRequest.timeoutInterval = 120
        let seconds = TimeZone.current.secondsFromGMT()
        let second_string="\(seconds)"
        urlRequest.setValue("48DQHBv9yIY", forHTTPHeaderField: "ApiServiceToken")
        urlRequest.setValue(second_string, forHTTPHeaderField: "Offset")
        urlRequest.setValue(Utility.appVersion(), forHTTPHeaderField: "AppVersion")
        /*  urlRequest.setValue( "\(Utility.getLoginModel()?.practitionerId ?? 0)", forHTTPHeaderField: "PractitionerId")
         urlRequest.setValue( Utility.getLoginModel()?.authorizationToken ?? "", forHTTPHeaderField: "AuthorizationToken")*/
        
        /*   if let token=Utility.getLoginModel()?.authorizationToken
         {
         urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
         NSLog("-------------->  token in header is \(token) <---------")
         }
         */
        
        //NSLog HEADER FIELDS
        for item in urlRequest.allHTTPHeaderFields!{
            NSLog("\(item)")
        }
        /*
         do {
         urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
         } catch {
         NSLog(error.localizedDescription)
         }
         */
        var err : NSError?
        err = nil
        
      
        SVProgressHUD.show()
        SVProgressHUD.setDefaultStyle(.dark)
      
       
        let dataTask = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            // Handle response
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
            });
            
            
            let error: AutoreleasingUnsafeMutablePointer<NSError?>? = nil
            if data != nil {
                
                let strData = String(data: data!, encoding: String.Encoding.utf8)
                NSLog("JSON Response is: \(strData ?? "")")
                
                var jsonResult: NSDictionary!
                jsonResult = nil
                
                do {
                    jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                } catch _ {
                }
                
                //parse data
                WebServiceHelper.jsonParsing(jsonResult: jsonResult, completionHandler: completeBlock)
                
                
            }
            else if error != nil {
                completeBlock(404,false, nil, err)
            }else {
                completeBlock(404,false, nil, err)
            }
        })
        dataTask.resume()
        
    }
    
    
    //MARK:- Upload FIle with parameters
    /*
     *  Below method is used to upload file(image or video) in file data with parameters.
     */
    static func uploadFileWithParameter(serviceName:String , fileData : [NSData], parameter : NSDictionary,canShowHud:Bool, completeBlock:@escaping (_ statusCode:Int, _ status : Bool, _ data : AnyObject?, _ error : NSError?)->())
    {
        
        guard isInternetAvailable()==true else {
            
            UnionPubQuiz.rootController?.presentAlertWith(message: "No internet connection found")
            return
        }
        
        let endURL  = WebServiceHelper.getBaseUrl() + serviceName
        NSLog("endPointURL %@", endURL)
        
        //NSLog request in json format
        NSLogJsonRequest(params: parameter)
        
        guard let url = URL(string: endURL) else {
            NSLog("Get an error")
            return
        }
        
        //Show progresshud
        if canShowHud{
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.show()
        }
        
        let boundary = generateBoundaryString()
        
        var fileName="fileName.doc"
        if let name=parameter.value(forKey: "contentName") as? String{
            fileName=name
        }
        
        let dictVideo = NSMutableDictionary()
        for (_,item) in fileData.enumerated(){
            dictVideo.setObject(item , forKey: "fileData" as NSCopying)
            dictVideo.setObject(fileName, forKey: "filename"  as NSCopying)
        }
        
        let arrVideoData = NSArray(object: dictVideo)
        
        
        let session = URLSession.shared
        let urlRequest = NSMutableURLRequest(url: url)
        
        
        
        NSLog(urlRequest.url?.absoluteString ?? "")
        
        
        //FIXME: Header field for particular app
        //setUpHeader(urlRequest: urlRequest, method: "POST")
        urlRequest.httpMethod="POST"
        
        
        urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let bodyData = createBodyWithParameters(parameter as? [String : AnyObject], filePathKey: "FileName", files: arrVideoData as! Array<Dictionary<String, AnyObject>>, boundary: boundary, image: Data())
        
        
        urlRequest.httpMethod = "POST"
        urlRequest.timeoutInterval = 250
        
        urlRequest.httpBody = bodyData as Data
        
        
        
        let dataTask = session.dataTask(with: urlRequest as URLRequest) { data, response, error in
            
            NSLog(error?.localizedDescription ?? "")
            
            if canShowHud{
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                
            }
            
            
            // Handle response
            let error: AutoreleasingUnsafeMutablePointer<NSError?>? = nil
            if data != nil
            {
                NSLog(String(data: data!, encoding: .utf8)!)
                var jsonResult: NSDictionary!
                jsonResult = nil
                
                do{
                    jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    NSLog("\(String(describing: jsonResult))")
                    WebServiceHelper.jsonParsing(jsonResult: jsonResult, completionHandler: completeBlock)
                    
                } catch _ {
                }
                if jsonResult == nil{
                    DispatchQueue.main.async{
                        completeBlock(404,false, jsonResult, nil)
                    }
                }
                
            }
            else if error != nil{
                DispatchQueue.main.async{
                    completeBlock(404,false, nil, nil)
                }
            }
            else{
                DispatchQueue.main.async{
                    completeBlock(404,false, nil, nil)
                }
            }
            
        }
        dataTask.resume()
    }
    
    //MARK:- //******* Create MultiPart Body ********** //
    class func createBodyWithParameters(_ parameters: [String: AnyObject]?, filePathKey: String?, files : Array<Dictionary<String, AnyObject>>, boundary: String, image:Data) -> Data
    {
        
        let body : NSMutableData = NSMutableData();
        if parameters != nil {
            for (key, value) in parameters! {
                body.append(("--\(boundary)\r\nContent-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            }
        }
        
        for file in files {
            let filename : String = file["Filename"] as? String ?? ""
            let _ : Data = file["Image"] as! Data
            
            body.append(("--\(boundary)\r\nContent-Disposition: form-data; name=\"\(filePathKey ?? "FileName")\"; filename=\"\(filename)\"\r\n\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            body.append(image)
            
            body.append(("\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        }
        body.append(("--\(boundary)--\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        return body as Data
    }
    
    class func generateBoundaryString() -> String {
        return "************"
    }
    
    //MARK:- //***** NSLog json request ***** //
    class func NSLogJsonRequest(params:AnyObject)
    {
        do {
            if let postData : NSData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData?{
                
                let json = NSString(data: postData as Data, encoding: String.Encoding.utf8.rawValue)! as String
               NSLog("*********** json request ---->>>>>>> \(json)")
                
            }
            
        }
        catch {
            NSLog("\(error)")
        }
    }
    /*
     *  Below method is used to parse response received from server.
     */
    //MARK:-  Parsed received json using helper method
    static func jsonParsing(jsonResult: NSDictionary?, completionHandler: @escaping (_ statusCode:Int, _ status: Bool, _ response: AnyObject, _ error: NSError?) -> ())
    {
        if let jsonResult = jsonResult
        {
            if let responseCode = jsonResult["ResponseCode"] as? Int
            {
                
                if responseCode == 204 // session has been expired
                {
                    
                    if let error = jsonResult["FailureMsg"] as? String
                    {
                        DispatchQueue.main.async(execute: {
                            Utility.DismissHud()
                            completionHandler(204,false, jsonResult, nil)
                           UnionPubQuiz.rootController?.presentAlertWith(message: error, oktitle:AlertMessage.Ok.rawValue, okaction: {
                                Utility.loadLoginVC()
                                WebServiceHelper.getToken()
                            })
                        })
                    }
                }
                else if responseCode == 200 //Success
                {
                    DispatchQueue.main.async(execute: {
                        Utility.DismissHud()
                        completionHandler(200,true, jsonResult, nil)
                    });
                }
                else if responseCode == 401 //Unauthorized
                {
                    DispatchQueue.main.async(execute: {
                        Utility.DismissHud()
                        WebServiceHelper.getToken()
                        completionHandler(401,false, jsonResult, nil)
                    })
                }
                else if responseCode == 202 //Error
                {
                    if let error = jsonResult["FailureMsg"] as? String
                    {
                        DispatchQueue.main.async(execute: {
                            Utility.DismissHud()
                           UnionPubQuiz.rootController?.presentAlertWith(message: error)
                            completionHandler(202,false, jsonResult, nil)
                            
                            WebServiceHelper.getToken()
                        })
                    }
                }
                else if responseCode == 302 //Only for end Points Url
                {
                     WebServiceHelper.fetchBaseUrl()
                }
                    //validation closed
                else{
                    DispatchQueue.main.async {
                        Utility.DismissHud()
                        if let failureMsg = jsonResult["FailureMsg"] as? String
                        {
                            completionHandler(404,false, jsonResult, nil)
                            showAlert(msg: failureMsg)
                            WebServiceHelper.getToken()
                        }
                    }
                }
            }
        }else{ // json is nil
            DispatchQueue.main.async(execute: {
                completionHandler(404,false,  [:] as AnyObject, nil)
                 Utility.DismissHud()
               UnionPubQuiz.rootController?.presentAlertWith(message: "Something went wrong")
                 WebServiceHelper.getToken()
            })
        }
        
    }
    static func showAlert(msg:String)
    {
        DispatchQueue.main.async(execute: {
            //SVProgressHUD.dismiss()
             
            if let presented=UnionPubQuiz.rootController?.presentedViewController
            {
                presented.presentAlertWith(message: msg)
            }
            else{
                UnionPubQuiz.rootController?.presentAlertWith(message: msg)
            }
            
        });
    }
    //MARK:- //***** Check Internet ***** //
    class func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    
  class func getToken(){
 
   let parmas = ["grant_type":"client_credentials","scope":"api1"]
        print(parmas)
        WebServiceHelper.postRequest(httpMethod: .post, method: "https://identity.rrapp.co.za/connect/token", params:parmas as AnyObject, canShowHud: false, completionHandler: { (code,success, dictionary, error) in
            if success == true{
                let  authenticationResult =  dictionary as? [String:Any]
                 var accessToken =  authenticationResult?["access_token"] as? String ?? ""
                let token_type =  authenticationResult?["token_type"] as? String ?? ""
                accessToken =  token_type + " " + accessToken
                Utility.apiAccessToken = accessToken
             }
        })
    }
    
     
     
    
    /*
     .... Find for base url and endpoints
     */
    class func fetchBaseUrl(){
        
        //TODO: Make sure dynemic country code
        let url =  URLType.fetchBase_URL.rawValue + (Locale.current.regionCode ?? "UK")
        print(url)
        getRequestBaseUrl(method: url, canShowHud: false) { (code,success, dictionary, error) in
            
            Utility.DismissHud()
            print(dictionary as Any)
            
            if let data = dictionary?["data"] as? [[String:Any]]
            {
                var baseUrlArray:[BaseUrlLinks] = [BaseUrlLinks]()
                for item in data{
                    let obj:BaseUrlLinks = BaseUrlLinks(fromDictionary: item)
                    baseUrlArray.append(obj)
                }
                Utility.setBaseURlModel(loginModel: baseUrlArray)
                //  DashboardVC.callApiSignIn(isSignIn: true)
//                let arr = Utility.getBaseURlModel()
//                if let array = arr{
//                    for item in array{
//                        print(item.name ?? "")
//                        print(item.url ?? "")
//                    }
//                }
            }
            else{ // json is nil
                DispatchQueue.main.async(execute: {
                    Utility.DismissHud()
                     UnionPubQuiz.rootController?.presentAlertWith(message: "Something went wrong")
                    WebServiceHelper.getToken()
                })
            }
            
        }
  
    }
    
    static func getRequestBaseUrl(method: String, canShowHud:Bool=true, completionHandler: @escaping (_ statusCode:Int, _ status: Bool, _ response: AnyObject?, _ error: NSError?) -> ())
    {
        
        guard isInternetAvailable()==true else {
            
           UnionPubQuiz.rootController?.presentAlertWith(message:"No internet connection found")
            return
        }
        
        let baseUrl = method
        
        NSLog("end Url \n \(baseUrl)")
        
        let url = NSURL(string: baseUrl)
        
        let request = NSMutableURLRequest(url: url! as URL)
        
        //set header
        request.httpMethod = "GET"
        request.setValue("U/PwgeBVZeu6ySUIdGlfZuhtvxTlbCt2T3fqHfawahSIqR11aLvGcg==", forHTTPHeaderField: "X-Functions-Key")
        
        
        let err : NSError?
        err = nil
        
        //NSLog json request
        /*
         *  Below method is used to NSLog request in JSON Format.
         */
        
        if canShowHud{
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.clear)
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            let error: AutoreleasingUnsafeMutablePointer<NSError?>? = nil
            guard let httpResponse = response as? HTTPURLResponse else { return   completionHandler(404,false, nil, err) }
          //  NSLog("Response code *************** \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 204, method.hasPrefix("https://user.rrapp.co.za/api/User") {
                WebServiceHelper.getToken()
                completionHandler(204,false, response, nil)
                return
            }
            if httpResponse.statusCode == 401{
                DispatchQueue.main.async(execute: {
                    Utility.DismissHud()
                    WebServiceHelper.getToken()
                })
                return
            }
            if httpResponse.statusCode == 200, data != nil{
                var jsonResult: NSMutableDictionary!
                jsonResult = nil
                do {
                   // NSLog(String(data: data!, encoding: String.Encoding.utf8)!)
                    
                    jsonResult=NSMutableDictionary()
                    jsonResult?.setValue(httpResponse.statusCode, forKey: "ResponseCode")
                    let array = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSArray
                    jsonResult.setValue(array, forKey: "data")
                    
                     NSLog("\(String(describing: jsonResult))")
                    
                    //MARK:-  Parsed received json using helper method
                    /*
                     *  Below method is used to parse response received from server.
                     */
                    WebServiceHelper.jsonParsing(jsonResult: jsonResult, completionHandler: completionHandler)
                    
                } catch _ {
                    completionHandler(200,false, [:] as AnyObject, nil)
                }
                
            }
            else if error != nil{
                DispatchQueue.main.async{
                    WebServiceHelper.getToken()
                    completionHandler(404,false, nil, err)
                }
            }
            else{
                DispatchQueue.main.async{
                    WebServiceHelper.getToken()
                    completionHandler(404,false, nil, err)
                }
            }
            
        }
        task.resume()
        
        
    }
    
    
    
     /* =========================================
        here is check user status new or extisting
        =========================================*/
    
       class  func callIsUserNewApi(params:SocialModel, loginType:SocialLoginType){
    //        let uniqueID = loginType == .Apple ? params.idToken:params.email
            let uniqueID = params.email
            let param = ["externalId":uniqueID]
            let model = getTypeUrl(type: "User")
            guard  let url =  model.url else {return}
            
            WebServiceHelper.getRequest(method: url+EndType.GetUserByExternalId.rawValue, params: param as AnyObject, isQueryParameter: true ){ (code,success, dictionary, error) in
                
                if success == true , let data = dictionary as? [String:AnyObject]{ // 204 mean no user found that mean new user
                    DispatchQueue.main.async {
                        let profileModel =  ProfileModel(fromDictionary: data)
                        Utility.setUserProfileModel(loginModel: profileModel)
                       // Utility.SuscribeDefaulstStation()
                        Utility.loadHomeVC()
                        
                    }
                }
                else
                {
                    if let httpResponse = dictionary as? HTTPURLResponse, httpResponse.statusCode == 204 {
                        // here call api for create new user login
                        self.callCreatUserApi(params: params, loginType: loginType)
                    }
                }
            }
            
        }
    
    // this api for creat new user
    class func callCreatUserApi(params:SocialModel,loginType:SocialLoginType){
        print("all params \(params.toDictionary())")
        let param = [ "id": "",//params.userId
                      "firstName": params.fName.isEmpty ? params.givenName ?? "":params.fName ?? "",
                      "surname": params.lName ?? "",
                      "nickName": "",
                      "emailAddress": params.email ?? "",
                      "mobileNumber": "",
                      "linkedInProfile": "",
                      "facebookProfile": params.imageURL ?? "",
                      "twitterHandle": "",
                      "externalId": loginType == .Apple ? params.idToken ?? "":params.email ?? ""] as [String : Any]
        
        let model = getTypeUrl(type: "User")
        guard  let url =  model.url else {return}
        WebServiceHelper.postRequest(httpMethod: .post, method:  url, params:param as AnyObject, canShowHud: true, completionHandler: { (code,success, dictionary, error) in
            if code == 204 {
                self.callIsUserNewApi(params: params, loginType: .Apple)
            }
           else if let data = dictionary as? [String:AnyObject], code == 200
            {
                DispatchQueue.main.async {
                    let profileModel =  ProfileModel(fromDictionary: data)
                    Utility.setUserProfileModel(loginModel: profileModel)
                    Utility.loadHomeVC()
                   // DashboardVC.callApiSignIn(isSignIn: true)
                }
            }
        })
        
        
    }
    
    
    class func setupApiToken(){
        self.getToken()
        Timer.scheduledTimer(withTimeInterval: 45*60, repeats: true) { (timer) in
            self.getToken()
        }
    }
}



 
