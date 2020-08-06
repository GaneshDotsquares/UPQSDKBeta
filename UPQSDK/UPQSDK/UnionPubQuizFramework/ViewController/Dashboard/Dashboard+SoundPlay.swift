//
//  Dashboard+SoundPlay.swift
//  RRApp
//
//  Created by Ganesh on 01/06/20.
//  Copyright © 2020 Dotsquares. All rights reserved.
//

import Foundation
import AVFoundation

extension DashboardVC{
 
    func isPlaySound(_ status:Bool) {
       // // print("gap check audio play",Date.timestamp)
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            beepPlayer.play()
          //// print("sound play start" ,Date.timestamp)
        } catch let errors {
           print(errors.localizedDescription)
         }
     }
    
    private func stopPlayAudio(){
//        if self.audioPlayer != nil{
//            self.audioPlayer?.stop()
//            self.audioPlayer?.delegate = nil
//            self.audioPlayer = nil
//        }
    }
    //MARK:- PLAY AUDIO SOUND WHEN TAP TO ANSWER ENABLED
    func playAudioTapToAnswer(){
        self.audioPlayer.play()
//        guard  let soundURL = Bundle.main.url(forResource: "DoorWell.mp3", withExtension: nil)  else{return}
//       // self.stopPlayAudio()
//        if self.audioPlayer == nil {
//            do {
//                try audioSession.setCategory(.playAndRecord, mode: .default)
//              //  try audioSession.setActive(true)
//
//                self.audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
//                self.audioPlayer?.numberOfLoops = 0
//                self.audioPlayer?.delegate = self
//                self.audioPlayer?.volume = 1.0
//                self.audioPlayer?.prepareToPlay()
//                self.audioPlayer?.play()
//             } catch let errors {
//               print(errors.localizedDescription)
//
//            }
//        }
    }
     
    
}


