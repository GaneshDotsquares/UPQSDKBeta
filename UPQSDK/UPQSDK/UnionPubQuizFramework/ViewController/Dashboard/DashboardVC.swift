//
//  DashboardVC.swift
//  RRApp
//
//  Created by Ganesh on 27/05/19.
//  Copyright © 2019 Dotsquares. All rights reserved.
//

import UIKit
import Speech
//import Firebase
import AVFoundation
//import FirebaseCrashlytics
import googleapis
//import FirebaseMessaging


var pollQuizIDArray = [String]()

extension Array {
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}

extension Notification.Name {
    static let ReceivedGoogleData = Notification.Name("ReceivedGoogleData")
    static let ReceivedNotification = Notification.Name("ReceivedNotification")

}


class DashboardVC: UIViewController {
    
    var beepPlayer: AVAudioPlayer = AVAudioPlayer()
    var audioPlayer: AVAudioPlayer = AVAudioPlayer()

    
    
    var activeRecordingType = RecordingType.Apple
    var settingRecordingType = RecordingType.Apple

    
    // weblink to view reward
    var strRewrardLink = ""
    
    // Anouncement Message
    var strQuizMessage = ""
    
    
    
    //Google speech variables
    var audioData: NSMutableData!
    var finished = false
    var isQuiz = false
    var curentRecordedText:String? = ""
    
    var googleCloser :((String,Bool)->())?
    
    //Countable Variables for show counting upto 20 seconds
    @IBOutlet weak var lblCountDown: UILabel!
    var timeoutSeconds = 20
    var counter = 20
    var CountDowntimer:Timer? = Timer()
 
    // start timer
    func startTimerForStartPolling() {
        counter = timeoutSeconds
        lblCountDown?.text = counter.description
        self.imgMic?.image = UIImage(named: "tap_answer", in: Bundle(for: type(of: self)), compatibleWith: nil)  
        lblCountDown?.isHidden =  false
        counter = timeoutSeconds
        invalidCountTimer() // just in case this button is tapped multiple times
       
        // start the timer
        CountDowntimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    
    // called every time interval from the timer
    @objc func timerAction() {
        counter -= 1
        lblCountDown?.text = counter.description
        if counter <= 0{
             
            DispatchQueue.main.async {
                if Utility.isAutoRecardingEnabled == true{
                     Utility.debugPrint(any: "**APPSPECTOR**  Start listing in Hand free mode")
                    self.screenState =  self.activeRecordingType == .Apple ? .StartAppleListingForPOll:.StartGoogleListing
                    if  self.activeRecordingType == .Apple{
                        self.updateUIForStartAppleListingForPOll()
                    }
                    else{
                        self.updateUIForStartGoogleListing()
                    }
                    self.lblCountDown?.isHidden =  true
                    self.CountDowntimer?.invalidate()
                    self.CountDowntimer =  nil
                    self.btnMice.isUserInteractionEnabled =  true
                }
                else {
                     Utility.debugPrint(any: "**APPSPECTOR**  TIME OUT for tap to answer")
                    self.pollComment = nil
                    //                self.screenState = .Stop
                    self.updateUIForSetNormalState()
                    self.lblCountDown?.isHidden =  true
                    self.CountDowntimer?.invalidate()
                    self.CountDowntimer =  nil
                }
            }
            
        }
        
    }
    
    
    
    
    
    // for animation of mice
    var isMiceAnimationCompleted = true
    var isUserOnDriving = true
     
    
    
    //MARK: ****************** IBOutlet VARIABLE **********************
    @IBOutlet weak var imgStation:UIImageView!
    @IBOutlet weak var imgMic:UIImageView!
    @IBOutlet weak var imgIndicator:UIImageView!
    @IBOutlet weak var stOption: UIStackView!
    @IBOutlet weak var lblRecordedText: UILabel!
    @IBOutlet weak var lblsuggestion: UILabel!
    @IBOutlet weak var lblQues: UILabel!
    @IBOutlet weak var btnMice: UIButton!
    //    @IBOutlet weak var btnFmMode: UIButton!
    @IBOutlet weak var imgAppStore: UIImageView!
    
    
    var delayTime:Int =  0
    //****************** Socket IO VARIABLE **********************
    var manager = SocketIOManager.shared
    var socket = SocketIOManager.socket
    
    
    //MARK: ****************** SFSpeechRecognizer and Audio IO VARIABLE **********************
    let req = SFSpeechAudioBufferRecognitionRequest()
    var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: Language.instance.setlanguage()))
    
    
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    var audioSession:AVAudioSession = AVAudioSession.sharedInstance()
  
    var inputNode:AVAudioInputNode? = nil
    
    // For Audio REcord
    var audioRecorder: AVAudioRecorder!
    var fileName:String = ""
 
    var audioTextModelArray = [AudioTextTypeModel]()
    var isAudioRecording:Bool = false
    //    private var profileModel:ModelAwslogin!
    var isAudioRecordingGranted: Bool!
    var recordingSession: AVAudioSession!
    var screenState = MicRecordngStatus.StartAppleListingForComment{
        didSet{
            print(screenState)
            if screenState == .Error{
                
            }
        }
    }
    
    //MARK: ****************** Timer  VARIABLE **********************
    var timerForSeekProgress:Timer? = Timer() // timer decide that progress will be show in many seconds // 2
    //  var timerDrawSeekProgress:Timer? // timer decide that how many seconds progres will be completed
    
    var countForStopTalking = 1.5
    let storkeLayer = CAShapeLayer()
    var currentTime = 0.0
    
    // this is usr for current playing Station name
    private var station:String!
    
    // this is user for current location paramater which is send in commment and poll API
    var  coordinate = ["longitude": 0.0,"latitude": 0.0]
    
    
    // Notification parameters it will must be nil after poll commet API sended
    var pollComment:[String:AnyObject]?
    
    //MARK: ****************** Controller Delegate  **********************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.profileModel =  Utility.awsLoginModel
        self.speechRecognizer?.delegate = self
        self.addObserver()
        
        self.setupView()
        AudioController.sharedInstance.delegate = self
        self.getSettingsUpdate()
        
    }
     
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.profileModel =  Utility.awsLoginModel
      self.rippleEffect()
        self.setBlackColorOFnavigation()
        self.navigationController?.isNavigationBarHidden = true
        self.setTransparentNavigationBar()
        UIApplication.shared.isIdleTimerDisabled = true
        
//        DispatchQueue.main.asyncAfter(deadline: .now()) {
//            self.getSettingsUpdate()
//        }
        
        switch audioSession.recordPermission {
        case AVAudioSessionRecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSessionRecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSessionRecordPermission.undetermined:
            audioSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.isAudioRecordingGranted = true
                    } else {
                        self.isAudioRecordingGranted = false
                    }
                }
            }
            break
        default:
            break
        }
        
      //  Messaging.messaging().subscribe(toTopic: Utility.FirebaseTenent)
        self.checkRecogniserAvialable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopSpeechRecording()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setSpeechRec()
        self.checkStatusAuthorizationSpeechRecognizer()
        self.getCurrentLocation()
        SocketIOManager.shared.connectSocket()
        self.addNameSocket(Utility.FirebaseTenent)
        self.btnMice.isEnabled = true
        // PlayBeepSound.shared =  PlayBeepSound(fromUrl: beepSound)
        
        do {
            if  let beepSound  = Bundle.init(identifier: "Dotsquares.UnionPubQuizFramework")?.url(forResource: "play", withExtension: "mp3"){
            beepPlayer = try AVAudioPlayer(contentsOf: beepSound)
            beepPlayer.prepareToPlay()
            }
            
            if let soundURL = Bundle.init(identifier: "Dotsquares.UnionPubQuizFramework")?.url(forResource: "ring", withExtension: "mp3"){
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer.volume = 1.0
            audioPlayer.prepareToPlay()
            }
            
        }
        catch{
            print("unable to load beep player")
        }
        
    }
    class  func getObject()->DashboardVC{
             return  UIStoryboard(name: "UPQMain", bundle: Bundle(for: self)).instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
       }
    
     
    
    // MARK: -  Memory warning and handling Method.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func getCurrentLocation(){
        CustomLocationManager.sharedInstance().startLocationTracing { (lat, long, region, error) in
            if let latitude = lat, let longitude =  long {
                NSLog("Current Location Finded *************** \n latitude === \(latitude)\n longitude === \(longitude)")
                self.coordinate = ["longitude":longitude, "latitude":latitude]
            }
        }
    }
      
   
    
    
    private  func rippleEffect(){
        UIView.animate(withDuration: 2.0,
                       animations: {
                        self.imgMic.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 2.0, animations: {
                            self.imgMic.transform = CGAffineTransform.identity
                        }, completion: { (status) in
                            if status {
                                self.rippleEffect()
                            }
                        })
        })
    }
    
    var count = 0
  
    
    // animating seek bar on animating image
    func drowSeekProgress(_ recordedString:String?){
        
 
        if let comment =  recordedString{
            if !comment.isEmpty  && self.screenState != .Runing{
              self.callSendCommentApi(comment:comment, pollComment: self.pollComment)
             }
        }
        
        if !(self.curentRecordedText?.trimString() ?? "").isEmpty {
            self.isPlaySound(false)
        }
        if  self.activeRecordingType == .Audio {
            self.btnMice.isEnabled = true
            
        }else{
            self.isPlaySound(false)
        }
        
    }
    
    
    
    
    //MARK:- ****************** Notification add Observer  ******************
    func addObserver(){
         NotificationCenter.default.addObserver(self, selector: #selector(performNotificationAction(notification:)), name: .ReceivedNotification, object: nil)
     }
    
    //MARK:- ****************** Notification action perform ******************
    @objc func performNotificationAction(notification: NSNotification){
        
        guard let dict = notification.userInfo as? Dictionary<String, Any>   else{  return  }
        let newPollID = dict["PollId"] as? String ?? "00001210"
        _ = self.pollComment?["PollId"] as? String ?? "00001210"

        var isQuiz = dict["IsQuiz"] as? Bool ?? false
        if  let IsQuiz = dict["IsQuiz"] as? String, IsQuiz.lowercased() == "true"{  isQuiz = true  }
  
        if pollQuizIDArray.contains(newPollID)  && isQuiz ==  true{
            return
        }
       else if pollQuizIDArray.contains(newPollID) && isQuiz ==  false && self.pollComment !=  nil{
                   return
               }
        else{
            
            pollQuizIDArray.append(newPollID)
            self.curentRecordedText =  ""
            self.pollComment = dict as [String : AnyObject]
           DispatchQueue.main.async {
                self.lblsuggestion?.text = ""
                // here is return if previous notification packet allready exits.
                //  if  self.pollComment != nil {return}
               
                self.stopSpeechRecording()
                self.finishAudioRecording(success: false)
                self.stopGoogleAudio()
                
                self.invalidCountTimer()
                self.lblCountDown?.isHidden =  true
                 // check here what will be work apple SR or Google SR
                if let isApple =  self.pollComment?["SpeechToTextEngine"] as? String, isApple.lowercased() == "google"{
                     self.activeRecordingType = .Google
                 }else{
                     self.activeRecordingType = .Google
                }
                
                //here is set Time out option when user profile set TAP TO ANSWER
                self.timeoutSeconds = self.pollComment?["Timeout"] as? Int ?? 20
                
                self.curentRecordedText =  ""
                print("gap check POll recieved",Date.timestamp)
                if Utility.isAutoRecardingEnabled {
                    self.timeoutSeconds =   self.pollComment?["HandsFreeTimer"] as? Int ?? 0
                     if self.timeoutSeconds <= 0{
                        self.screenState =  self.activeRecordingType == .Apple ? .StartAppleListingForPOll:.StartGoogleListing
                        if  self.activeRecordingType == .Apple{
                            self.updateUIForStartAppleListingForPOll()
                        }
                        else{
                            self.updateUIForStartGoogleListing()
                        }
                    }
                     else{
                        self.playAudioTapToAnswer()
                         self.screenState = .Runing
                        self.startTimerForStartPolling()
                        self.imgMic.image =  UIImage(named: "handfree", in: Bundle(for: type(of: self)), compatibleWith: nil) 
                        self.lblsuggestion.text  = ""
                        self.btnMice.isUserInteractionEnabled =  false
                    }
                }
                else{
                    self.screenState =  self.activeRecordingType == .Apple ? .StartAppleListingForPOll:.StartGoogleListing
                    self.imgMic.image = UIImage(named: "tap_answer", in: Bundle(for: type(of: self)), compatibleWith: nil) 
                    self.lblQues?.text = self.pollComment?["QuestionText"] as? String
                    self.playAudioTapToAnswer()
                    self.startTimerForStartPolling()
                }
            }
            
            
        }
    }
    
}


extension DashboardVC {
    
    // MARK: -  Ends the current speech recording session.
    func stopSpeechRecording() {
        recognitionRequest?.shouldReportPartialResults = false
        self.audioEngine.inputNode.removeTap(onBus: 0)
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
       self.invalidTimer()
        
    }
    
    
    private func checkStatusAuthorizationSpeechRecognizer(){
        
        // here check mic permission status
        
        AVAudioSession().requestRecordPermission({ (status) in
            if status != true{
                DispatchQueue.main.async {
                    self.screenState = .StartAppleListingForComment
                    self.showPermissionAlert(message: PermissionMessage.mic.rawValue)
                }
                
            }
        })
        
        // here check speech recognizer status
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus != SFSpeechRecognizerAuthorizationStatus.authorized {
                self.showPermissionAlert(message: PermissionMessage.speechRecognizer.rawValue)
            }
        }
    }
}







extension DashboardVC{
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let player =  object as? AVPlayer, let _ = keyPath{
            if (player == beepAVPlayer && keyPath == "status") {
                if (beepAVPlayer.status == .failed) {
                   // print("AVPlayer Failed", Date().currentTiemStamp())
                    
                } else if (player.status == .readyToPlay) {
                   // print("AVPlayer StatusReady To Play", Date().currentTiemStamp())
                    // [self.songPlayer play];
                    
                    
                } else if (player.status == .unknown) {
                   // print("AVPlayer Unknown", Date().currentTiemStamp())
                    
                }
                if player.rate != 0 && player.error == nil {
                   // print("AVPlayer is playing.................", Date().currentTiemStamp())
                } else {
                   // print("AVPlayer is NOT playing.", Date().currentTiemStamp())
                }
                
            }
        }
        
    }
    
    
}
