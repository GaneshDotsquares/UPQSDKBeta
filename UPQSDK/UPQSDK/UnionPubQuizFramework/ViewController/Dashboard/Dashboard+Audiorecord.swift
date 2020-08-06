//
//  Dashboard+Audiorecord.swift
//  RRApp
//
//  Created by Ganesh on 27/03/20.
//  Copyright © 2020 Dotsquares. All rights reserved.
//

import UIKit
import Speech
//import Firebase
import AVFoundation
//import FirebaseCrashlytics
import googleapis



extension DashboardVC:AVAudioRecorderDelegate{
    
    func setupView() {
        recordingSession = audioSession
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        
                    } else {
                        // failed to record
                    }
                }
            }
        } catch {
            // failed to record
             self.updateUIForSetNormalState()
            
          // print("*********************** An AudioSession could not be activate ***********************")
 
         //  self.presentAlertWith(message: "An AudioSession could not be activate")
       return
            
        }
    }
    
    func startAudioRecording() {
          self.setupView()
         let name = "\(Date.timestamp)"
        let audioFilename = getFileURL(str: name)
        self.fileName = name
 
        let settings: [String: Any] = [
            /// Format Flac
            AVFormatIDKey: Int(kAudioFormatFLAC),
            AVSampleRateKey: 16000,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMIsFloatKey: false,
        ]

        do {
             self.lblsuggestion?.text =  AlertMessage.tapToStop.rawValue
             self.currentTime = 1
            self.countForStopTalking = 55
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            audioRecorder.prepareToRecord()
            //Tap to stop hint
            let strRecordedFile = audioFilename.absoluteString
           self.invalidTimer()
            self.timerForSeekProgress =  Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
                self.currentTime += 1
               print(self.currentTime)
                if self.isAudioRecording{
                    if self.currentTime > self.countForStopTalking{
                        self.finishAudioRecording(success: false)
                        self.currentTime = 1
                        self.drowSeekProgress(strRecordedFile)
                        self.invalidTimer()
                    }
                }else{
                    if self.currentTime > 1{
                        self.finishAudioRecording(success: false)
                        self.currentTime = 1
                        self.drowSeekProgress(strRecordedFile)
                       self.invalidTimer()
                    }else{
                        self.isAudioRecording = false
                        self.finishAudioRecording(success: false)
                        self.invalidTimer()
                    }
                }
            })

        } catch {
            finishAudioRecording(success: false)
        }
    }
 
    func finishAudioRecording(success: Bool) {
        if audioRecorder != nil{
            audioRecorder.stop()
            audioRecorder = nil
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileURL(str:String) -> URL {
        let filename = "\(str).flac" //flac
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
 
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishAudioRecording(success: false)
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
       // print("Error while recording audio \(error!.localizedDescription)")
    }
}
