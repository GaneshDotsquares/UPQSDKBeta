//
//  LoginVC.swift
//  RRApp
//
//  Created by Ganesh on 27/05/19.
//  Copyright © 2019 Dotsquares. All rights reserved.
//

import UIKit
import SafariServices
import AuthenticationServices


class LoginVC: UIViewController,SFSafariViewControllerDelegate{
 
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var privacyPolicyTextView: UITextView!
    @IBOutlet weak var stView: UIStackView!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPrivacyPolicyLink()
        
        
        if #available(iOS 13, *) {
            let authorizationButton = ASAuthorizationAppleIDButton()
           stView.addArrangedSubview(authorizationButton)
            authorizationButton.addTarget(self, action: #selector(handleLogInWithAppleIDButtonPress), for: .touchUpInside)
          }
         
     }
    
    @objc private func handleLogInWithAppleIDButtonPress() {
        if btnCheck.isSelected ==  false{
            self.presentAlertWith(message: AlertMessage.TermCondtions.rawValue)
            
        }
        else{
            self.presentAlertWith(message: AlertMessage.AppleLoginEmailConfirmation.rawValue, oktitle:AlertMessage.Yes.rawValue, okaction: {
                if #available(iOS 13.0, *) {
                    self.signInButtonTapped()
                } else { }
            }, notitle: AlertMessage.No.rawValue) {  }
        }
        
    }
    @IBAction func btnSocialLogin(_ sender:UIButton){
      
        if btnCheck.isSelected ==  false{
            self.presentAlertWith(message: AlertMessage.TermCondtions.rawValue)
            return
        } 
        
        if sender.tag == 11 {// Google Account
            self.loginWithGoogle()
        }
        else if (sender.tag == 12 ){ // for Facebook Account
          self.loginWithFB()
        }
        else if (sender.tag == 13 ){ // for Apple Account
            self.handleLogInWithAppleIDButtonPress()
        }
        else if (sender.tag == 14 ){ // for linkedin Account
        }
    }
    
    @IBAction func btnActionToogle(_ sender: UIButton) {
        btnCheck.isSelected =  !btnCheck.isSelected
    }
    
    func setPrivacyPolicyLink()
    {
        
        
        //self.privacyPolicyTextView.attributedText = policyStr
         self.privacyPolicyTextView.isEditable = false
        self.privacyPolicyTextView.isSelectable = true
        self.privacyPolicyTextView.isUserInteractionEnabled = true
        self.privacyPolicyTextView.delegate = self
        
        privacyPolicyTextView.textColor = UIColor.white
        
    }
    @IBAction func btnActionPrivacy(_ sender: UIButton) {
        let url = URL(string: WebLinked.privacy.rawValue)
        let controller = SFSafariViewController(url: url!)
        self.present(controller, animated: true, completion: nil)
        controller.delegate = self
        
    }
    
   

}
//MARK:- TextField Delegate Methods
extension LoginVC : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let url = URL
        let controller = SFSafariViewController(url: url)
        self.present(controller, animated: true, completion: nil)
        controller.delegate = self
        
        return false
    }
}
 @available(iOS 13.0, *)
extension LoginVC:ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding{
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
            self.presentAlertWith(message: "Login failed \n please try again")
            return
        }
        
        let userIdentifier = appleIDCredential.user
        let userFirstName = appleIDCredential.fullName?.givenName ?? ""
        let userLastName = appleIDCredential.fullName?.familyName ?? ""
        let userEmail = appleIDCredential.email ?? ""
        let FullName =  String(format: "%@ %@", userFirstName, userLastName)
        let model =  SocialModel(email: userEmail, userId: userIdentifier, idToken: userIdentifier, fullName: FullName, givenName: userFirstName, imageURL: "", firstName: userFirstName, lastName: userLastName)
        
        if userEmail.isEmpty {
            self.presentAlertWith(message: AlertMessage.FailedToGetAppleLoginEmail.rawValue)
        }
        else{
            self.callIsUserNewApi(params: model, loginType: .Apple)
        }
 
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("AppleID Credential failed with error: \(error.localizedDescription)")
    }
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return (self.view.window!)
    }
    
    private func showTextFieldAlert(model:SocialModel){
        DispatchQueue.main.async {
            self.presentAlertWithTextField(message: AlertMessage.FailedToGetAppleLoginEmail.rawValue , tfText: "Email", oktitle:  AlertMessage.Yes.rawValue, okaction: { (str) in
                if str.isEmpty{
                    self.presentAlertWith(message: AlertMessage.BEmail.rawValue)
                }
                else if !(str.isValidEmail()){
                    self.presentAlertWith(message: AlertMessage.VEmail.rawValue)
                }
                else{
                    model.email =  str.trimString()
                    self.callIsUserNewApi(params: model, loginType: .Apple)
                }
            }, notitle:  AlertMessage.No.rawValue, noaction: {
                
            })
        }
    }
}
