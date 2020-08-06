//
//  StationVC.swift
//  RRApp
//
//  Created by Ganesh on 27/05/19.
//  Copyright © 2019 Dotsquares. All rights reserved.
//

import UIKit
//import Firebase
//import FirebaseMessaging
class StationVC: UIViewController {
    @IBOutlet weak var collStation:UICollectionView!
    @IBOutlet weak var lblPlaceHolder:UILabel!

    var callback:((_ img:String, _ text:String)->Void)?
    private  var arrStationList : NSMutableArray!
    
    private var arrAllFavStationList:FavStationListModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = VCTitle.Station.rawValue
        collStation.delegate = self
        collStation.dataSource = self
        self.navigationController?.isNavigationBarHidden = false
        self.setTransparentNavigationBar()
        
        if let path = Bundle.main.path(forResource: "Stationlist", ofType: "plist") {
            self.arrStationList = NSMutableArray(contentsOfFile: path)
        }
        
        collStation.reloadData()
        self.lblPlaceHolder.text =  AlertMessage.PStationNotFound.rawValue
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.arrAllFavStationList = Utility.getFavStationList()
            self.collStation.reloadData()
        }
        
    }
    
 
    @IBAction func btnBackAction(_ sender:Any){
        self.didTapBack()
    }
    
    @IBAction func btnStatationAction(_ sender:Any){

    }
}


extension StationVC:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return self.arrStationList?.count ?? 0
        let count =  self.arrAllFavStationList?.allFavList?.count ?? 0
        self.lblPlaceHolder.isHidden = count == 0 ? false:true
        self.collStation.isHidden = !self.lblPlaceHolder.isHidden
        return count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "StationCollCell", for: indexPath) as!  StationCollCell
        // let dict = arrStationList?.object(at: indexPath.row) as? NSDictionary
         //  cell.imgStation.image = UIImage.init(named: dict?.object(forKey: "ImgTitle") as? String ?? "")
        cell.imgStation.setImage(with: self.arrAllFavStationList?.allFavList[indexPath.row].image, placeholder: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collStation.width/2)-5, height: (self.collStation.width/2)-5)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tenent =  self.arrAllFavStationList.allFavList[indexPath.row]
        self.setNameOnSocket(model: tenent)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
       }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension StationVC{
    
    //MARK:- suscribe a topic
    func handleSubscribeTouch( index:Int) {
        // [START subscribe_topic]
        guard  let dic = arrStationList?.object(at: index) as? NSDictionary else{return}
        Utility.showHud()
        let station = dic.object(forKey: "Title") as? String ?? ""
        let stationImage = dic.object(forKey: "ImgTitle") as? String ?? ""
        Messaging.messaging().subscribe(toTopic: station ) { error in
            if error != nil {return}
            print("Subscribed to \(station))")
            self.callback?(stationImage, station )
            self.didTapBack()
            Utility.DismissHud()
            
            if let model =  Utility.getUserProfileModel(){
                if let peviousStation = model.station,  station !=  peviousStation {
                    Utility.handleUNSubscribeTopic(topic: model.station ?? "")
                }
                model.stationImage = stationImage
                model.station = station
                Utility.setUserProfileModel(loginModel: model)
            }
            
           
         }
        
    }
  
    
    // here is set Uniqe name on Socket
    private func setNameOnSocket(model:StationListModel){
        if  let favListModel =  Utility.getFavStationList() {
            favListModel.favItem = model
            Utility.setFavStationList(favListModel)
            self.callback?(model.image ?? "", model.tenent )
          
            self.didTapBack()
        }
    }
    
    
}

