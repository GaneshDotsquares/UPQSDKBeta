//
//  Authorization.swift
//  SpeechToText
//
//  Created by claudio Cavalli on 17/01/2019.
//  Copyright © 2019 claudio Cavalli. All rights reserved.
//

import UIKit
import Speech

extension DashboardVC{
    
  func requestAuthorization(){
    SFSpeechRecognizer.requestAuthorization { authStatus in
        
        OperationQueue.main.addOperation {
            switch authStatus {
            case .authorized:
                self.btnMice.isEnabled = true
                
            case .denied:
                self.btnMice.isEnabled = false
               // print("User denied access to speech recognition")
            case .restricted:
                self.btnMice.isEnabled = false
               // print("Speech recognition restricted on this device")
 
            case .notDetermined:
                self.btnMice.isEnabled = false
               // print("Speech recognition not yet authorized")
            @unknown default:
                break;
            }
        }
    }
  }
    
}
