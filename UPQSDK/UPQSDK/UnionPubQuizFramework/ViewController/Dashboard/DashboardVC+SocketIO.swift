//
//  DashboardVC+SocketIO.swift
//  RRApp
//
//  Created by Ganesh on 19/06/19.
//  Copyright © 2019 Dotsquares. All rights reserved.
//

import Foundation
import SocketIO

extension DashboardVC{
    func addNameSocket(_ forTenent:String) {
       
       // print("*************** \(forTenent) is going to register ********************\n\n\n\n")
      
        SocketIOManager.shared.socket?.on(forTenent) {[weak self] data, ack in
            SocketIOManager.shared.status()
           Utility.debugPrint(any: "*************** \n\n\n\n Recieved Socket Response \n \(String(describing: data.last))********************\n\n\n\n")
           
            if let value  =  data.last as? String, let dict =  Utility.convertToDictionary(text: value){
                //        if let dict = data.last as? Dictionary<String, AnyObject>{
//                var isDashboardVC =  false
                guard let dashnav =  UnionPubQuiz.rootController?.topMostController() as? DashboardVC else{  return  }
                
                if let IsQuiz =  dict["IsQuiz"] as? Bool, IsQuiz ==  true{
                   Utility.debugPrint(any: "**APPSPECTOR** Quiz received via Socket")
                }
                else{
                     Utility.debugPrint(any: "**APPSPECTOR** Poll received via Socket")
                }
                
                let recievedTenent =  dict["Tenant"] as? String ?? ""
                let registerTenent = Utility.FirebaseTenent
               let newPollid = dict["PollId"] as? String
                                 let pollid = dashnav.pollComment?["PollId"] as? String
                if newPollid !=  pollid && (registerTenent.lowercased() ==  recievedTenent.lowercased()) && Utility.isUserLoginBefore ==  true{
                         NotificationCenter.default.post(name: .ReceivedNotification, object: nil, userInfo: dict)
                     return
                   
                }
            }
            
        }
    }
    
    
    class func removeNameSocket(_ forTenent:String) {
     SocketIOManager.shared.socket?.off(forTenent)
    }
    
    //remove all socket Url
    class func removeAllHandler(){
     SocketIOManager.shared.socket?.removeAllHandlers()
    }
    
     
}

