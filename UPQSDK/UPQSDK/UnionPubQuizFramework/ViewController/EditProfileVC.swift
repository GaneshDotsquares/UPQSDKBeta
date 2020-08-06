//
//  EditProfileVC.swift
//  RRApp
//
//  Created by Ganesh on 28/05/19.
//  Copyright © 2019 Dotsquares. All rights reserved.
//

import UIKit
//import AWSCognitoIdentityProvider

class EditProfileVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtSurname: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    var profileModel =  Utility.getUserProfileModel()
      @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDataOnUI()
        NotificationCenter.default.addObserver(self,
               selector: #selector(self.keyboardNotification(notification:)),
               name: UIResponder.keyboardWillChangeFrameNotification,
               object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 20.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = (endFrame?.size.height ?? 0.0)+20.0
            }
            UIView.animate(withDuration: duration,
                                       delay: TimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }
    
    private func setDataOnUI(){
        imgProfile?.setImage(with: Utility.getUserProfileModel()?.facebookProfile)
        txtEmail?.text =  Utility.getUserProfileModel()?.emailAddress ?? ""
        txtFirstName?.text =  Utility.getUserProfileModel()?.firstName ?? ""
        txtSurname?.text =  Utility.getUserProfileModel()?.surname ?? ""
        txtMobileNumber.text =  Utility.getUserProfileModel()?.mobileNumber ?? ""
        self.textFiledNextDoneSetUP(fields: [txtFirstName,txtSurname,txtMobileNumber])
     }
    
    class  func getObject()->EditProfileVC{
          return  UIStoryboard(name: "UPQMain", bundle: Bundle(for: self)).instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
    }
    
    @IBAction func backActiondismissKeyword(_ sender: Any) {
        self.view.endEditing(true)
      }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnActionSave(_ sender: UIButton) {
        isValidate()
     }
       

    private func callIsUserEditApi(){
        
        self.view.endEditing(true)
        let user = getTypeUrl(type: "User").url ?? ""
        let userUrlBaseUrl = String(format: "%@/%@", user,profileModel?.id ?? "")
        let param:[String:String] = [ "id" : profileModel?.id ?? "",
                      "firstName" : txtFirstName?.text?.trimString() ?? "",
                      "surname" : txtSurname.text?.trimString() ?? "" ,
                      "nickName" : profileModel?.nickName  ?? "",
                      "emailAddress" : profileModel?.emailAddress ?? "" ,
                      "mobileNumber" : txtMobileNumber?.text?.trimString() ?? "" ,
                      "linkedInProfile" : "",
                      "facebookProfile" : profileModel?.facebookProfile ?? "" ,
                      "twitterHandle" : "",
                      "externalId" : txtEmail?.text?.trimString() ?? ""
        ]
        
        profileModel?.firstName = txtFirstName?.text?.trimString()
        profileModel?.surname = txtSurname?.text?.trimString()
        profileModel?.mobileNumber = txtMobileNumber?.text?.trimString()
        WebServiceHelper.postRequest(httpMethod: .put, method: userUrlBaseUrl, params: param as AnyObject, canShowHud: true, completionHandler: { (statusCode, success, dictionary, error)  in
            if statusCode == 200
            {
                Utility.setUserProfileModel(loginModel: self.profileModel!)
                self.presentAlertWith(message: "Profile saved successfully", oktitle: "OK") {
                     self.dismiss(animated: true, completion: nil)
                }
               
            }
        })
        
    }
    
 
 
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         switch textField {
        case txtMobileNumber:
                 return Utility.checkLimit(textField: textField, string: string, withCount: 15)

        default:
                 return Utility.checkLimit(textField: textField, string: string, withCount: 50)
        }
    }
    
    func isValidate()
    {
        if txtEmail.text?.trimString().count==0
        {
            presentAlertWith(message: AlertMessage.BEmail.rawValue)
            return
        }
        else if txtEmail.text?.trimString().isValidEmail()==false
        {
            presentAlertWith(message: AlertMessage.VEmail.rawValue)
            return
        }
        else if (txtFirstName.text?.trimString().count==0)
        {
            presentAlertWith(message: AlertMessage.BfirstName.rawValue)
            return
        }
//        else if txtSurname.text?.trimString().count==0
//        {
//            presentAlertWith(message: AlertMessage.BSurname.rawValue)
//            return
//        }
//        else if txtMobileNumber.text?.trimString().count==0
//        {
//            presentAlertWith(message: AlertMessage.BMobile.rawValue)
//            return
//        }
        else if (txtMobileNumber.text?.trimString().count ?? 0 > 0) && (txtMobileNumber.text?.trimString().count ?? 0) < 7{
            presentAlertWith(message: AlertMessage.VMobile.rawValue)
            return
        }
        else {callIsUserEditApi()}
    }
    
}
