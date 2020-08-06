

import UIKit

//MARK:- ******************************  Alert Message   ************************************
enum AlertMessage : String {
    // For Edit Password View Controller
    case Ok                 = "OK"
    case Cancel             = "CANCEL"
    case Yes                = "Yes"
    case No                 = "No"
    case BEmail             = "Enter Email Address";
    case VEmail             = "Enter valid email address";
    case BfirstName         = "Enter first name";
    case BSurname           = "Enter surname";
    case BNickname          = "Enter nickname";
    case BMobile            = "Enter mobile number";
    case VMobile            = "Enter valid mobile number";
    case BStation           = "Please select the Radio Station.";
    case FBnotLogin         = "Oops some Error occurred while we are fetching login details from Facebook.";
    case FBNotEmailPermission    = "We are unable to fetch your email account details from Facebook. Please try again using different login method.";
    case PStationNotFound   = "Add Radio Station";
    case BRadioSelection    = "Please select the minimum one Radio Station.";
    case VspeehRecogniserNotAvailable    = "Sorry speech recognizer not found or network access not connected.\nNOTE: We need a network connection to send a comment or poll to the radio station.";
    case VspeehRecogniserNotSupport    = "The speech recognizer can not operate without network access.";
    case NoInternet =  "No internet connection found"
    case AppleLoginEmailConfirmation = "Union JACK Pub Quiz would require Email to communicate you for the Quiz result in case you win"
    case FailedToGetAppleLoginEmail = "Unable to get email address, please try some other login method"
    case TermCondtions = "Please accept Privacy Policy"
    case SendUsAcomment = "Send us a comment"
    case tapToStop =  "Tap to Stop Recording"
    case RecordingError   =  ""//Did not hear your feedback. \n Try again."

}


enum WebLinked : String {
    case privacy =  "https://www.unionjack.co.uk/privacy-policy"
    case StationList = "https://qb988yoj4f.execute-api.us-east-2.amazonaws.com/default/stations_list"// old
    case Callender =  "https://1xoxo44ci5.execute-api.us-east-2.amazonaws.com/default/calinder_rrapp?stationid="
}


//MARK:- ******************************  confirmation Message   ************************************
enum Confirmation : String {
    case exitApp = "Are you sure you want to exit the app?"
    case TapToCancel = "" //Tap to cancel
    
}


enum EnumSocialLoginType:String
{
    case Facebook = "Facebook"
    case Twitter = "Twitter"
    case Google_Plus = "Google Plus"
    case Linkedin = "Linkedin"
}

enum SocialLoginType:String{
   case Google = "Google"
   case Facebook = "Facebook"
   case Apple = "Apple"
   
}

enum EndType:String
{
    case profile             = "Facebook"
    case GetToken            = "/connect/token"
    case GetUserByExternalId = "/GetByExternalId"
    case PostUser            = "/api/User"
    case SendComment         = "mob-comment"
    case POLLComment         = "api/Poll/"
    case MultipleComment     = "/api/Comment/Multiple"
}

enum VCTitle:String
{
    case Station = "Station"
}

enum MicRecordngStatus:Int{
    case Runing = 0
    case StartAppleListingForComment = 1
    case StartAppleListingForPOll = 2
    case StartGoogleListing = 3
    case StartAudioListing = 4
    case StopAudioListing = 5
    case Error = 6
}

enum PermissionMessage : String {
    case mic              = "Mic permission not enabled. Do you want to give permission?"
    case speechRecognizer = "SpeechRecognizer permission not enabled. Do you want to give permission?"
    case camera           = "Camera permission not enabled. Do you want to give permission?"
    case location         = "Location permission is not enabled. Do you want to give permission?"
}


enum Key:String {
    case client_credentials = "client_credentials"
    case api1 = "api1"
    case Token_Authorization = "Basic bXZjOnNlY3JldA=="
    case Google_clientID     =  "566570808001-tk9npmjq6m85akk6i5jt6214frg2433n.apps.googleusercontent.com"
    //    case Google_clientID     =  "779484777857-3se821e3u20l52v5qgcsuej21q65s8p3.apps.googleusercontent.com"
    case Tenant = "Test"
}

enum HttpMethod : String{
    case post = "POST"
    case get  =  "GET"
    case put  = "PUT"
    case Delete  = "DELETE"
}

enum MicSelection : String{
    case isOn = "Handsfree"
    case isOff = "Tap to Answer"
}

enum Tenant:String{
    case Test      = "Dev"
    case Default   = "Default"
    case Jacaranda = "Jacaranda"
}


enum WeblinkType:Int{
    case Callender      = 1
    case like           = 2
    case Rewards        = 3
    case Voucher        = 4
    case TermCondition  = 5
    case Privacy        = 6
}


enum RecordingType:Int{
    case none = 0
    case Apple = 1
    case Google = 2
    case Audio = 3
}
