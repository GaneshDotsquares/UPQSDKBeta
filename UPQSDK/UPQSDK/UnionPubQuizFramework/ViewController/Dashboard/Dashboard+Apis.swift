//
//  Dashboard+Apis.swift
//  RRApp
//
//  Created by Ganesh on 01/06/20.
//  Copyright © 2020 Dotsquares. All rights reserved.
//

import Foundation
import UIKit
extension DashboardVC{
    // this api for send comment on server
    func callSendCommentApi(comment:String, pollComment:[String:Any]?){
       // print("message recorded ************ \n \(comment.trimString())")
        var  canShowHud =  false
 
        let profileData = Utility.getUserProfileModel()
        let name  =  profileData?.firstName?.trimString()
        let surname  = (profileData?.surname?.trimString() ?? "")
        
        var pollId = ""
        //  "tenant":self.station ?? Utility.getFavStationList()?.favItem.tenent as Any
        
        var encodedString = ""
        var commentforApi = ""
        var audioformat = ""
        if let isQiuz =  pollComment?["IsQuiz"] as? Bool,  isQiuz == true{
            audioformat = ""
            commentforApi =  comment.trimString()
            encodedString = ""
            canShowHud =  false
        }
        else if self.activeRecordingType == .Audio{
            audioformat = "flac"
            commentforApi = ""
            guard let commentAudioUrl = URL(string: comment) else {
                self.updateUIForSetNormalState()
                return
            }
            let audioData =  try? Data(contentsOf: commentAudioUrl, options: [.dataReadingMapped, .uncached])
            
            guard let str  =  (audioData?.base64EncodedString(options: .lineLength64Characters)) else {
                 self.updateUIForSetNormalState()
                return
                
            }
            encodedString = str
            canShowHud =  true
        }else{
            audioformat = ""
            commentforApi =  comment.trimString()
            encodedString = ""
            canShowHud =  false
        }
        
        _ = CoordinateModel(fromDictionary: ["latitude":Float(self.coordinate["latitude"] ?? 0.0), "longitude":Float(self.coordinate["longitude"] ?? 0.0)])
        let request = CommentReqModel(fromDictionary: ["coordinate":["latitude":Float(self.coordinate["latitude"] ?? 0.0), "longitude":Float(self.coordinate["longitude"] ?? 0.0)], "emailAddress":profileData?.emailAddress ?? "","firstName":name ?? "", "surname":surname,"audioFormat":audioformat,"audioRecording": encodedString,"tenant":Utility.FirebaseTenent,"text":commentforApi,"userId":profileData?.id ?? 0])
        
        var param = request.toDictionary()
        
        if let notificationPacket =  pollComment{
            pollId = notificationPacket["PollId"] as? String ?? ""
            let   pollParam = [
                "pollId"    : notificationPacket["PollId"]as Any,
                "redisUrl"    : notificationPacket["message"]as Any,
                "question"  : notificationPacket["QuestionText"]as Any,
                "answer"    : comment.trimString() as Any
                ] as [String : Any]
            
            pollParam.forEach { (k,v) in param[k] = v }
        }
        
        
        let commentUrl = getTypeUrl(type: "Comment")
        let pollUrl = getTypeUrl(type: "Poll")
        let CommentBaseUrl =  commentUrl.url ?? ""
        let pollUrlBaseUrl = "\(pollUrl.url ?? "")/\(pollId)/Respond"
        //        let CommentBaseUrl = baseUrl.comment.rawValue
        //        let pollUrlBaseUrl = baseUrl.poll.rawValue + "/\(pollId)/Respond"
        let url =  pollComment == nil ? CommentBaseUrl:pollUrlBaseUrl
        let keyForHeader = pollComment == nil ? commentUrl.key ?? "" : pollUrl.key ?? ""
       // print(url)
        // if !url.hasPrefix("http") {
        self.setStateAfterPostComment()
        //  }
        self.pollComment = nil
        WebServiceHelper.postRequest(httpMethod: .post, method: url, params:param as AnyObject, canShowHud: canShowHud, key:keyForHeader, completionHandler: { (code,success, dictionary, error) in
             //self.getSettingsUpdate()
                  DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                    self.getSettingsUpdate()
                }
          })
        
        
    }
    
    
    func setStateAfterPostComment(){
          btnMice?.isEnabled = false
        self.lblQues?.text = self.strQuizMessage
         self.imgMic?.image =   UIImage(named: "end", in: Bundle(for: type(of: self)), compatibleWith: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.btnMice?.isEnabled = true
            if self.pollComment == nil{
             self.updateUIForSetNormalState()
             }
        }
    }
    
    
    func getSettingsUpdate(){
           let tenantUrl = getTypeUrl(type: "Tenant")
           let strSetting = "\(tenantUrl.url ?? "")/\(Utility.FirebaseTenent)/Settings"
           // // print(strSetting)
           let parmas:[String:Any] = [:]
           
        WebServiceHelper.postRequest(httpMethod: .get, method: strSetting, params: parmas as AnyObject, canShowHud: false) { (code,status, dictionary, error) in
            //  print(dictionary)
            DispatchQueue.main.async{
                self.audioTextModelArray.removeAll()
                if error == nil{
                    if let controlsData = dictionary["controls"] as? [[String:Any]]
                    {
                        
                        for item in controlsData{
                            let obj:AudioTextTypeModel = AudioTextTypeModel(fromDictionary: item)
                            self.audioTextModelArray.append(obj)
                        }
                        
                        if self.audioTextModelArray.count>0{
                            for item in self.audioTextModelArray{
                                if item.key == "RecordingType"{
                                    if self.pollComment == nil{
                                        if item.value == "Text"{
                                            self.activeRecordingType = .Apple
                                            self.settingRecordingType = .Apple
                                            self.screenState =  .StartAppleListingForComment
                                         }else{
                                            self.screenState =  .StartAudioListing
                                            self.activeRecordingType = .Audio
                                             self.settingRecordingType = .Audio
                                         }
                                    }
                                }
                                if item.key == "BaseUrl"{
                                    self.strRewrardLink = item.value ?? ""
                                }
                                if item.key == "QuizMessage"{
                                    self.strQuizMessage = item.value ?? ""
                                    if self.pollComment == nil{
                                        self.lblQues?.text = self.strQuizMessage
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
        }
       }
       
    
    
}
