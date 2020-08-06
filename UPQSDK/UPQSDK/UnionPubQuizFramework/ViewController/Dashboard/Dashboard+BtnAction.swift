//
//  Dashboard+BtnAction.swift
//  RRApp
//
//  Created by Ganesh on 01/06/20.
//  Copyright © 2020 Dotsquares. All rights reserved.
//

import Foundation
import UIKit
extension DashboardVC{
    @IBAction func btnActionappStore(_ sender: Any) {
        openAppsStoreInBrowser("https://apps.apple.com/us/app/union-jack/id1145541314")
    }

    @IBAction func btnSettingAction(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        stOption.alpha = 0.0
        UIView.animate(withDuration: 1.0) {
            self.stOption.alpha = 1.0
            self.stOption.isHidden = !sender.isSelected
        }
        
        
    }
    
    
    
    @IBAction func btnMicAction(_ sender:UIButton){
            if Utility.isAutoRecardingEnabled ==  true{
                self.showToast(message: "You are in handsfree mode.")
            }
            else{
            switch self.screenState {
            case .Runing:
                break
            case .StartAppleListingForComment:
                updateUIForStartAppleListing()
                break
            case .StartAppleListingForPOll:
                updateUIForStartAppleListingForPOll()
                break
            case .StartGoogleListing:
                updateUIForStartGoogleListing()
                break
            case .StartAudioListing:
                updateUIForStartAudioListing()
                break
            case .StopAudioListing:
                updateUIForStopAudioListing()
                break
            case .Error:
                //stopSpeechRecording()
                
                break
            }
    //        print("gap check btnMicAction complete",Date.timestamp)
            invalidCountTimer()
            self.lblCountDown?.isHidden =  true
            }
        }
    
    @IBAction func btnListAction(_ sender:UIButton){
        
    }
    
    @IBAction func btnExitAction(_ sender:UIButton){
        // Utility.loadLoginVC()
        self.presentAlertWith(message: Confirmation.exitApp.rawValue, oktitle: AlertMessage.Ok.rawValue, okaction: {
            DashboardVC.callApiSignIn(isSignIn: false)
            //            exit(0)
        }, notitle: AlertMessage.Cancel.rawValue) {  }
    }
    
    @IBAction func btnProfileAction(_ sender:UIButton){
        let vc = ProfileViewVC.getObject()
        vc.callOpenEditPrifle = {
            self.navigateController(vc: EditProfileVC.getObject())
        }
       // self.stopSpeechRecording()
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnActionFMMode(_ sender:UIButton){
        let vc = TenentPopupVC.getObject()
        vc.callBack = { str in
            DashboardVC.removeAllHandler()
            self.addNameSocket(str)
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnWebLinkedAction(_ sender:UIButton){
     print("gap check play sound",Date.timestamp)
        PlayBeepSound.shared.play()
     }
    
    
}
