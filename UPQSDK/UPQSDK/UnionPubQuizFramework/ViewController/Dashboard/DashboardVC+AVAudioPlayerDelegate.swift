//
//  DashboardVC+AVAudioPlayerDelegate.swift
//  RRApp
//
//  Created by Ganesh on 19/06/19.
//  Copyright © 2019 Dotsquares. All rights reserved.
//

import Foundation
import UIKit
import Speech
//import Firebase
import AVFoundation

extension DashboardVC:AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
       // print("sound play audioPlayerDidFinishPlaying",Date.timestamp)
//       try? audioSession.setCategory(.playAndRecord, mode: .default)
//      try? audioSession.setActive(true)
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
       // print(" sound play audioPlayerDecodeErrorDidOccur",Date.timestamp)
    }
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
       // print("sound play audioPlayerBeginInterruption",Date.timestamp)
    }
    
    
    func invalidTimer(){
         timerForSeekProgress?.invalidate()
        timerForSeekProgress =  nil
    }
    
    func invalidCountTimer(){
        self.CountDowntimer?.invalidate()
        self.CountDowntimer = nil
       
              
    }
    
}



extension DashboardVC{
    
    func updateUIForSetNormalState(){
        if self.pollComment == nil{
           screenState =  self.settingRecordingType == .Audio ? .StartAudioListing :.StartAppleListingForComment
            self.imgMic?.image = UIImage(named: "start", in: Bundle(for: type(of: self)), compatibleWith: nil)
            self.lblsuggestion?.text =  nil
            self.lblQues?.text =  self.strQuizMessage
            self.btnMice?.isEnabled = true
            self.lblRecordedText?.text =  ""
            self.curentRecordedText =  ""
            self.lblCountDown?.isHidden =  true
            self.isAudioRecording = false
              UnionPubQuiz.sharedInstance.isMicListening?(false)
        }
    }
    
    func updateUIForErrorSpeechOrRecording(){
          UnionPubQuiz.sharedInstance.isMicListening?(false)
              screenState = .Error
              self.currentTime = -2.0
             // self.pollComment = nil
             // self.btnMice.isEnabled = false
         self.activeRecordingType =  self.settingRecordingType
        DispatchQueue.main.async {
            self.imgMic?.image =  UIImage(named: "error", in: Bundle(for: type(of: self)), compatibleWith: nil)  
            self.lblsuggestion?.text =  AlertMessage.RecordingError.rawValue
        }
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
            if self.pollComment == nil{
                self.updateUIForSetNormalState()
            }
        }
     }
    
    func updateUIForStartAppleListing(){
          UnionPubQuiz.sharedInstance.isMicListening?(true)
        screenState = .Runing
        self.imgMic?.image = UIImage(named: "started", in: Bundle(for: type(of: self)), compatibleWith: nil)
        self.lblsuggestion?.text = AlertMessage.SendUsAcomment.rawValue
      //  self.imgMic?.zoomIn(duration: 0.3)
        try! self.siriSpeechToText()
        self.isPlaySound(true)
      
    }
    
    func updateUIForStartAppleListingForPOll(){
        UnionPubQuiz.sharedInstance.isMicListening?(true)
        Utility.debugPrint(any: "**APPSPECTOR** user button tab remaining second \(self.lblCountDown?.text ?? "")")
         screenState = .Runing
       self.imgMic?.image =  UIImage(named: "started", in: Bundle(for: type(of: self)), compatibleWith: nil)
        self.lblsuggestion?.text = ""
        //self.imgMic?.zoomIn(duration: 0.3)
         Utility.debugPrint(any: "**APPSPECTOR** Siri start listening for question")
        try! self.siriSpeechToText()
        self.isPlaySound(true)
         
        
    }
    
    
    
    
    func updateUIForStartGoogleListing(){
         UnionPubQuiz.sharedInstance.isMicListening?(true)
           Utility.debugPrint(any: "**APPSPECTOR** user button tab remaining second \(self.lblCountDown?.text ?? "")")
         screenState = .Runing
        self.imgMic?.image = UIImage(named: "started", in: Bundle(for: type(of: self)), compatibleWith: nil)
        self.lblsuggestion?.text =  nil
       // self.imgMic?.zoomIn(duration: 0.3)
         Utility.debugPrint(any: "**APPSPECTOR** Google start listening for question")
        self.startGoogleRecording()
        self.isPlaySound(true)
        
     }
    
    func updateUIForStartAudioListing(){
         UnionPubQuiz.sharedInstance.isMicListening?(true)
         screenState = .StopAudioListing
        isAudioRecording = true
       // self.imgMic?.zoomIn(duration: 0.3)
       self.imgMic?.image =   UIImage(named: "started", in: Bundle(for: type(of: self)), compatibleWith: nil)
        self.lblsuggestion?.text = AlertMessage.tapToStop.rawValue
        self.startAudioRecording()
        self.isPlaySound(true)
        
        
    }
    
    func updateUIForStopAudioListing(){
        screenState =  self.settingRecordingType == .Audio ? .StartAudioListing :.StartAppleListingForComment
        isAudioRecording = false
        self.isPlaySound(true)
        self.imgMic?.image =  UIImage(named: "started", in: Bundle(for: type(of: self)), compatibleWith: nil) 
        finishAudioRecording(success: true)
         UnionPubQuiz.sharedInstance.isMicListening?(false)
    }
    
    
}
