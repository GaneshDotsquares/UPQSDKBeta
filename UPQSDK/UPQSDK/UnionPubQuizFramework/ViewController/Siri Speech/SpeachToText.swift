//
//  SpeachToText.swift
//  SpeechToText
//
//  Created by claudio Cavalli on 17/01/2019.
//  Copyright © 2019 claudio Cavalli. All rights reserved.
//

import UIKit
import Speech

extension DashboardVC:SFSpeechRecognizerDelegate{
     
    func siriSpeechToText() throws{
        // print("gap check siriSpeechToText",Date.timestamp)
         if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
            stopSpeechRecording()
        }
 
        do {
            try audioSession.setCategory(.playAndRecord,mode: .measurement)
            try audioSession.setMode(.default)
            try audioSession.setPreferredSampleRate(44100)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
        } catch {
            print("audioSession properties weren't set because of an error.")
             updateUIForErrorSpeechOrRecording()
            return
        }
        
     //   print("gap check siriSpeechToText initilise ",Date.timestamp)
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            print("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
              updateUIForErrorSpeechOrRecording()
            return
        }
 
        recognitionRequest.shouldReportPartialResults = true
        
        self.currentTime = -2.0
        self.countForStopTalking = 1.5
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            _ = result?.isFinal ?? false
            self.currentTime = 0.5
            if(result?.bestTranscription.formattedString != nil){
                DispatchQueue.main.async {
                    //  self.lblRecordedText.text =  (result?.bestTranscription.formattedString)!
                    self.curentRecordedText = (result?.bestTranscription.formattedString)!
                }
            }
            
            if error != nil  {
               self.audioEngine.inputNode.removeTap(onBus: 0)
               //  self.audioEngine.reset()
//                self.inputNode?.removeTap(onBus: 0)
//                self.audioEngine.stop()
                 self.recognitionRequest?.endAudio()
//                self.recognitionTask?.cancel()
               // self.currentTime =  2.0
                //self.btnMice.isEnabled = false
            }
        })
        
        var recordingFormat = inputNode.outputFormat(forBus: 0)
        if(inputNode.inputFormat(forBus: 0).channelCount == 0){
            Utility.debugPrint(any: "Not enough available inputs!")
             updateUIForErrorSpeechOrRecording()
            return
        }
        if (recordingFormat.sampleRate <= 0){
              recordingFormat = inputNode.outputFormat(forBus: 0)
            audioEngine.inputNode.reset()
        }
            // print("available inputs!",inputNode.inputFormat(forBus: 0).channelCount)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {[weak self] (buffer, when) in
                self?.recognitionRequest?.append(buffer)
            }
       
        
        audioEngine.prepare()
        do {
         
            try  audioEngine.start()
                invalidTimer()
            //  print("gap check siriSpeechToText start ",Date.timestamp)
                timerForSeekProgress = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(self.refreshAudioView(_:)), userInfo: nil, repeats: true)
        }
        catch{
            updateUIForErrorSpeechOrRecording()
             print("audioEngine couldn't start because of an error.")
             return
        }
        
    }
    
    @objc internal func refreshAudioView(_ timer:Timer) {
        if currentTime > self.countForStopTalking{
            timer.invalidate()
            if   let str =   self.curentRecordedText, !str.isEmpty{
                self.stopSpeechRecording()
                 self.countForStopTalking = 1.5
                screenState  = self.settingRecordingType == .Audio ? .StartAudioListing :.StartAppleListingForComment
                
                self.drowSeekProgress(str)
                if SpeechRecognitionService.sharedInstance.isStreaming()  == true || self.activeRecordingType == .Google {
                    self.stopGoogleAudio()
                    screenState =  self.settingRecordingType == .Audio ? .StartAudioListing :.StartAppleListingForComment
                 }
                
               // self.pollComment = nil
            }
             else{
              //  self.screenState = .Error
                self.updateUIForErrorSpeechOrRecording()
                self.stopSpeechRecording()
                if SpeechRecognitionService.sharedInstance.isStreaming()  == true || self.activeRecordingType == .Google {
                    self.stopGoogleAudio()
                     Utility.debugPrint(any: "**APPSPECTOR** Google time out")
                 screenState =  self.settingRecordingType == .Audio ? .StartAudioListing :.StartAppleListingForComment
                 }
                 self.pollComment = nil
            }
            self.invalidTimer()
            
        }
        
        currentTime += timer.timeInterval
//       print("countDelay",String(format: "%.1f", currentTime))
//       print( self.curentRecordedText ?? "")
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
         //   btnMice?.isEnabled = true
            //            recordButton.setTitle("Start Recording", for: [])
        } else {
           // btnMice?.isEnabled = false
            //            recordButton.setTitle("Recognition not available", for: .disabled)
        }
    }
    
    func setSpeechRec() {
        if speechRecognizer == nil {
            speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
            speechRecognizer?.delegate = self
        }
        self.checkRecogniserAvialable()
        
    }
    func checkRecogniserAvialable(){
        if WebServiceHelper.isInternetAvailable() == false  && speechRecognizer?.isAvailable  == false {
            DispatchQueue.main.async {
                self.presentAlertWith(message: AlertMessage.VspeehRecogniserNotAvailable.rawValue)
            }
        }
    }
}
