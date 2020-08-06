//
//  ProfileViewVC.swift
//  RRApp
//
//  Created by Ganesh on 28/05/19.
//  Copyright © 2019 Dotsquares. All rights reserved.
//

import UIKit
import SafariServices
class ProfileViewVC: UIViewController,SFSafariViewControllerDelegate {
    
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblSurName: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblNickNmae: UILabel!
    @IBOutlet weak var lblUserName: UILabel!

    @IBOutlet weak var btnMic: UIButton!
    @IBOutlet weak var lblMic: UILabel!
    @IBOutlet weak var imgMic: UIImageView!
    
    var callOpenEditPrifle:(()->Void)?
   // var profileModel =  Utility.awsLoginModel
    var profileModel : ProfileModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTransparentNavigationBar()
         
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
      profileModel =  Utility.getUserProfileModel()
          self.setDataOnUI()
    }
    
    private func setDataOnUI(){
       imgProfile.setImage(with: self.profileModel?.facebookProfile, placeholder: UIImage(named: "profile_img", in: Bundle(for: type(of: self)), compatibleWith: nil))
        let firstname  = profileModel?.firstName?.trimString()
        lblEmail.text        =  self.profileModel?.emailAddress ?? ""
        lblSurName.text      =  self.profileModel?.surname ?? ""
        lblMobileNumber.text =  self.profileModel?.mobileNumber ?? ""
        lblNickNmae.text     =  firstname
        lblUserName.text     =  String(format: "%@ %@", firstname ?? "" ,  self.profileModel?.surname ?? "" )
        self.setMicStatus(isAutoRecodingEnabled: Utility.isAutoRecardingEnabled)
    }
    
    
    
    class  func getObject()->ProfileViewVC{
        return  UIStoryboard(name: "UPQMain", bundle: Bundle(for: self)).instantiateViewController(withIdentifier: "ProfileViewVC") as! ProfileViewVC
    }
    
    @IBAction func btnBackAction(_ sender:Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnTapEditProfile(_ sender:UIButton){
        self.present(EditProfileVC.getObject(), animated: true, completion: nil)
    }

    @IBAction func btnActionMic(_ sender: UIButton) {
        Utility.isAutoRecardingEnabled = !Utility.isAutoRecardingEnabled
        self.setMicStatus(isAutoRecodingEnabled: Utility.isAutoRecardingEnabled)
        
    }

    // Here is updating mic image and text on uilable
    private func setMicStatus(isAutoRecodingEnabled:Bool){
      
        if isAutoRecodingEnabled == true {
             self.imgMic.image = UIImage(named: "microphone", in: Bundle(for: type(of: self)), compatibleWith: nil)
            self.imgMic.tintColor = #colorLiteral(red: 0.6498398781, green: 0.1058881357, blue: 0.1761343181, alpha: 1)
            self.lblMic.text = MicSelection.isOn.rawValue
            self.lblMic.textColor = #colorLiteral(red: 0.6498398781, green: 0.1058881357, blue: 0.1761343181, alpha: 1)
 
        }
        else{
            self.imgMic.image = UIImage(named: "microphone_selected", in: Bundle(for: type(of: self)), compatibleWith: nil)  
            self.imgMic.tintColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lblMic.text = MicSelection.isOff.rawValue
            self.lblMic.textColor =   #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
       
        
    }
    @IBAction func btnActionPrivacy(_ sender: UIButton) {
          let url = URL(string: "http://www.rrapp.co.uk")
          let controller = SFSafariViewController(url: url!)
          self.present(controller, animated: true, completion: nil)
          controller.delegate = self
          
      }
    
    
    
//  private func callIsUserNewApi(){
//        let params = ["externalId":self.profileModel?.emailAddress]
//         WebServiceHelper.getRequest(method: URLType.newGetUserProfile.rawValue, params: params as AnyObject, isQueryParameter: true ){ (success, dictionary, error) in
//
//            if let data = dictionary as? [String:AnyObject]
//            {
//               self.profileModel =  ProfileModel(fromDictionary: data)
//                Utility.setUserProfileModel(loginModel: self.profileModel)
//                self.setDataOnUI()
//             }
//        }
//     }
//



}
