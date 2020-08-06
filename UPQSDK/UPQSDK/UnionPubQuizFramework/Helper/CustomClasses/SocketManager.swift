//
//  SocketManager.swift
//  RRApp
//
//  Created by Ganesh on 19/06/19.
//  Copyright © 2019 Dotsquares. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager: SocketManager {
    let socketUrl = "https://uk-rrapp-socket.azurewebsites.net"
  static  let shared=SocketIOManager.init(socketURL: "https://uk-rrapp-socket.azurewebsites.net".makeURL()!)
    
//    var manager:SocketManager!
    var socket:SocketIOClient!
    
    
    override init(socketURL: URL, config: SocketIOClientConfiguration = [.log(true), .compress]) {
        super.init(socketURL: socketURL, config: config)
        socket =  self.defaultSocket
     }
    
//    func configurationUrl(_UrlString:String = "https://uk-rrapp-socket.azurewebsites.net"){
//        //WebLinked.Socket.rawValue
//        if let url =  URL(string: _UrlString){
//           // print("\n\n\n\n\n socket going to register url \(_UrlString)\n\n\n\n\n")
//            manager =   SocketManager(socketURL: url, config: [.log(false), .compress])
//            socket = manager.defaultSocket
//            // connectio of socket
//            socket.connect()
//
//        }
//
//
//
//    }
    
    
    
    func connectSocket(){
        //  let token =  Utility.getAccessToken()
        // self.manager.config = SocketIOClientConfiguration(arrayLiteral: .connectParams(["token" : token]))
       if socket ==  nil {
            socket =  defaultSocket
        }
        socket.connect()
        status()
    }
    
    func disconnectSocket(){
        socket.disconnect()
    }
    
    override func emitAll(_ event: String, _ items: SocketData...) {
        
    }
      func status(){
        
        switch socket.status {
        case .connected:
           print("**************************Socket Status is connected **************************")
            break
        case .connecting :
            print("************************** Socket Status is connecting **************************")
            break
        case .disconnected :
            print("************************** Socket Status is disconnected **************************")
            self.connect()
            break
        case .notConnected :
            self.connect()
             print("************************** Socket Status is notConnected **************************")
            
            break
            
        }
    }
    
}
