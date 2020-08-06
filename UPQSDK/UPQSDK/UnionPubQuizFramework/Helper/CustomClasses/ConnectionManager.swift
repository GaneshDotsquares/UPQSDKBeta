//
//  ConnectionManager.swift
//  RRApp
//
//  Created by Ganesh on 19/06/19.
//  Copyright © 2019 Dotsquares. All rights reserved.
//

import Foundation

class ConnectionManager {
    
    static let sharedInstance = ConnectionManager()
    private var reachability : Reachability!
    
    func observeReachability(){
        self.reachability = try! Reachability()
        NotificationCenter.default.addObserver(self, selector:#selector(self.reachabilityChanged), name: NSNotification.Name.reachabilityChanged, object: nil)
        do {
            try self.reachability.startNotifier()
        }
        catch(let error) {
            print("Error occured while starting reachability notifications : \(error.localizedDescription)")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        guard    let reachability = note.object as? Reachability else{return}
        switch reachability.connection {
        case .cellular, .wifi:
            print("********************* \n\n\n\n  Network available via \(reachability.connection.description). *********************** \n\n\n")
            if Utility.isUserLoginBefore{
                SocketIOManager.shared.connectSocket()
//                  SocketIOManager.connectSocket()
             if   let vc = AppDelegate.shared.window?.rootViewController?.topMostController() as? DashboardVC{
                    vc.addNameSocket(Utility.FirebaseTenent)
                }
            }
            
            WebServiceHelper.getToken()
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                 WebServiceHelper.sendlocalComments()
            }
           
            break
//        case .wifi:
//            print("Network available via WiFi.")
//            break
        case .none:
             print("********************* \n\n\n  Network  is not available.. ***********************\n\n\n\n")
             break
        }
    }
}
