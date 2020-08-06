//
//  TententPopupVC.swift
//  RRApp
//
//  Created by Ganesh on 27/03/20.
//  Copyright © 2020 Dotsquares. All rights reserved.
//

import UIKit
//import Firebase
//import FirebaseInstanceID
//import FirebaseMessaging

class TenentPopupVC: UIViewController {
    var callBack:((_ tenent:String)->())?
    @IBOutlet weak var txtTenent:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtTenent?.text = Utility.FirebaseTenent
    }
    
    class  func getObject()->TenentPopupVC{
        return UIStoryboard(name: "UPQMain", bundle: Bundle(for: self)).instantiateViewController(withIdentifier: "TenentPopupVC") as! TenentPopupVC
        
    }
    
    @IBAction func btnActionSave(_ sender:UIButton){
      /*  if (txtTenent.text?.trimString() ?? "").isEmpty {
            self.presentAlertWith(message: "Please enter tenent")
        }
        else{
            Messaging.messaging().unsubscribe(fromTopic: Utility.FirebaseTenent) { (error) in
                if  error != nil{
                   // print("***************** old Tenet unsuscribe \(Utility.FirebaseTenent)  *****************")
                    Messaging.messaging().subscribe(toTopic: Utility.FirebaseTenent) { (error) in
                        if  error != nil{
                            Messaging.messaging().subscribe( toTopic: Utility.FirebaseTenent)
                           // print("***************** old Tenet unsuscribe \(Utility.FirebaseTenent)  *****************")
                        }
                    }
                }
                else{
                   // print("***************** new Tenet suscribe \(Utility.FirebaseTenent)  *****************")
                    Messaging.messaging().unsubscribe(fromTopic: Utility.FirebaseTenent)
                }
            }
            
            Messaging.messaging().unsubscribe(fromTopic: Utility.FirebaseTenent)
            Utility.FirebaseTenent = txtTenent.text!.trimString()
            Messaging.messaging().subscribe(toTopic: Utility.FirebaseTenent)
            self.dismiss(animated: true) {
                self.callBack?((self.txtTenent.text?.trimString() ?? ""))
            }
        }
        */
    }
    @IBAction func btnActionCancel(_ sender:UIButton){
        self.dismiss(animated: true) {}
    }
    
    
}
