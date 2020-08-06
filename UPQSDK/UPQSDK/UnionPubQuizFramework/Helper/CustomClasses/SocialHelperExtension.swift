 
 
 import UIKit
// import GoogleSignIn
// import FBSDKLoginKit
// import FBSDKCoreKit
// import FBSDKLoginKit
// import Firebase
 
 
 

 
 extension UIViewController:GIDSignInUIDelegate
 {
    //MARK:- Google Sign In
    func loginWithGoogle()
    {
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        NotificationCenter.default.addObserver(self, selector: #selector(googleDataReceived(notification:)), name: .ReceivedGoogleData, object: nil)
    }
    /**
     * Below method is called when app received data from google. This notification is posted from appdelegate.
     */
    @objc func googleDataReceived(notification:Notification)
    {
        if let dict = notification.userInfo as? [String:Any]
        {
            if let model=dict["model"] as? SocialModel
            {
                print(model)
                // call method
                self.callIsUserNewApi(params: model, loginType: .Google)
            }
        }
        
        NotificationCenter.default.removeObserver(self)
    }
    
   
    
    
    
    
    //MARK:- GIDSignInUIDelegate
    
    public func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    public func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    public func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    //MARK:- Facebook Sign In
    
    func loginWithFB()
    {
        let loginManager = LoginManager()//LoginManager()
        //        loginManager.loginBehavior = .browser
        loginManager.logOut()
        
        
        loginManager.logIn(permissions:  ["public_profile", "email"], from: self) { (loginResult, error) in
            
            if (loginResult?.isCancelled ?? false){
                print("user canceled")
                return
            }
            if error == nil{
                self.getFBUserData(manager: loginManager)
            }
            else{
                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                    print("facebook error on login in app :- \(error?.localizedDescription)")
                    AppDelegate.rootController?.presentAlertWith(message: AlertMessage.FBnotLogin.rawValue)
                })
                
            }
        }
    }
    /*
     *  Below method is used to get data from facebook.
     */
    func getFBUserData(manager:LoginManager)
    {
        if((AccessToken.current) != nil){
            //  self.signInWithAWSFacebook()
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, first_name, last_name"]).start(completionHandler: { (connection, result, error)  in
                if (error == nil){
                    // here is clear token and delete permission and logout from app
                    self.parseFB_Data(jsonData: result)
                    self.deleteFbPermission(manager: manager)
                    print(result!)
                    
                }
            })
        }
    }
    
     
    // Delete fb permission
    
    private func deleteFbPermission(manager:LoginManager){
        manager.logOut()
        let deletepermission = GraphRequest(graphPath: "me/permissions/", parameters: ["public_profile": "email"], httpMethod: HTTPMethod(rawValue: "DELETE"))
        deletepermission.start(completionHandler: {(connection,result,error)-> Void in
            print("the delete permission is \(String(describing: result))")
            AccessToken.current = nil
            Profile.current = nil
        })
    }
    /*
     *  Below method is used to parse data from facebook. and check wheter user already registered or not.
     * If user already registered then go to home.
     * Otherwise go to sign up form with user details from fb.
     */
    func parseFB_Data(jsonData: Any?)
    {
        guard let data = jsonData as? [String:Any] else {return}
        
        var email=""
        if let eml = data["email"] as? String
        {
            email=eml
        }
        else{
            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                AppDelegate.rootController?.presentAlertWith(message: AlertMessage.FBNotEmailPermission.rawValue)
            })
            return
        }
        guard let id = data["id"] as? String else{return}
        
        var name=""
        if let nme = data["name"] as? String
        {
            name=nme
        }
        
        var fname=""
        if let first_name = data["first_name"] as? String
        {
            fname=first_name
        }
        
        var lname=""
        if let last_name = data["last_name"] as? String
        {
            lname=last_name
        }
        var imageUrl=""
        if let dict=data["picture"] as? [String:Any]
        {
            if let inner_data=dict["data"] as? [String:Any]
            {
                if let image=inner_data["url"] as? String
                {
                    imageUrl=image
                }
            }
        }
        
        let model =  SocialModel(email: email, userId: id, idToken: id, fullName: name, givenName: "", imageURL: imageUrl, firstName: fname, lastName: lname)
        //let model=SocialModel(email: email, userId: id, idToken: "", fullName: name, givenName: "",imageURL:imageUrl)
        // call method
        //  callCreatUserApi(params: model,ProviderType:.Facebook)
        callIsUserNewApi(params: model, loginType: .Facebook)
    }
    
 }
 
 
 
 import AuthenticationServices
 
 @available(iOS 13.0, *)
 class BtnLoginWithApple:UIButton,ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding{
    let signInButton = ASAuthorizationAppleIDButton()
    let authorizationProvider = ASAuthorizationAppleIDProvider()
    
    override func draw(_ rect: CGRect) {
        
    }
    
    
    
    func signInButtonTapped( ) {
        let authorizationProvider = ASAuthorizationAppleIDProvider()
        let request = authorizationProvider.createRequest()
        request.requestedScopes = [.email,.fullName]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            self.viewContainingController?.presentAlertWith(message: "Login failed \n please try again")
            return
        }
        let userIdentifier = appleIDCredential.user
        let userFirstName = appleIDCredential.fullName?.givenName ?? ""
        let userLastName = appleIDCredential.fullName?.familyName ?? ""
        let userEmail = appleIDCredential.email ?? ""
        let FullName =  String(format: "%@ %@", userFirstName, userLastName)
        let model =  SocialModel(email: userEmail, userId: userIdentifier, idToken: userIdentifier, fullName: FullName, givenName: userFirstName, imageURL: "", firstName: userFirstName, lastName: userLastName)
        
        if userEmail.isEmpty {
            self.viewContainingController?.presentAlertWith(message: AlertMessage.FailedToGetAppleLoginEmail.rawValue)
        }
        else{
            self.viewContainingController?.callIsUserNewApi(params: model, loginType: .Apple)
        }
       
        
       
        
        
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("AppleID Credential failed with error: \(error.localizedDescription)")
    }
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return (self.window!)
    }
    
    private func showTextFieldAlert(model:SocialModel){
        DispatchQueue.main.async {
            self.viewContainingController?.presentAlertWithTextField(message: AlertMessage.FailedToGetAppleLoginEmail.rawValue , tfText: "Email", oktitle:  AlertMessage.Yes.rawValue, okaction: { (str) in
                if str.isEmpty{
                    self.viewContainingController?.presentAlertWith(message: AlertMessage.BEmail.rawValue)
                }
                else if !(str.isValidEmail()){
                    self.viewContainingController?.presentAlertWith(message: AlertMessage.VEmail.rawValue)
                }
                else{
                     model.email =  str.trimString()
                    self.viewContainingController?.callIsUserNewApi(params: model, loginType: .Apple)
                }
            }, notitle:  AlertMessage.No.rawValue, noaction: {
                
            })
        }
    }
    
 }
 
