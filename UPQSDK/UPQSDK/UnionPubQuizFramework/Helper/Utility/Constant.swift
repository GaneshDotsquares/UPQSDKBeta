

import Foundation
import UIKit
import AVFoundation

 
let themeColor =  #colorLiteral(red: 0.6705882353, green: 0.1019607843, blue: 0.1764705882, alpha: 1)

//MARK:- ******************************  Station list   ************************************

 struct Constants {
   let  kDeviceType = "IOS"
}

public enum baseUrl: String{
    case comment = "https://comment.rrapp.co.za/api/Comment"
    case poll = "https://poll.rrapp.co.za/api/poll"
    case configuration = "https://configuration.rrapp.co.za/api/Tenant"
    case user = "https://user.rrapp.co.za/api/User"
}


internal func getTypeUrl(type:String)->BaseUrlLinks{
    let arr = Utility.getBaseURlModel()
    if let array = arr{
        for item in array{
            if item.name == type{
                return item
            }
        }
    }
    
    return BaseUrlLinks.init()
}

var beepAudioPlayer = AVAudioPlayer()
var beepAVPlayer = AVPlayer()
let beepSound  = Bundle.main.url(forResource: "play", withExtension: "mp3")


class UIConfigurataion : NSObject {
    internal static let backgroundColorViewController = #colorLiteral(red: 0.6705882353, green: 0.1019607843, blue: 0.1764705882, alpha: 1)
    internal static let textBackColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    internal static let textHrBlackLineColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    internal static let textRedColor = #colorLiteral(red: 0.6705882353, green: 0.1019607843, blue: 0.1764705882, alpha: 1)
    internal static let textWhiteColor = #colorLiteral(red: 0.6705882353, green: 0.1019607843, blue: 0.1764705882, alpha: 1)
 //  internal static let microphone = UIImage(named: "microphone", in: Bundle(for: type(of: self)), compatibleWith: nil)
    
}
