//
//  FMModeVC.swift
//  RRApp
//
//  Created by Ganesh on 21/10/19.
//  Copyright © 2019 Dotsquares. All rights reserved.
//

import UIKit

class FMModeVC: UIViewController {
    @IBOutlet weak var tblFmMode: UITableView!

    @IBOutlet weak var contHeightTbl: NSLayoutConstraint!
    var  arrString =  [FMMode]()
    var callBack:((_ fMMode:FMMode, _ index:Int)->())?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         // Do any additional setup after loading the view.
        tblFmMode.reloadData()
        if let mode = Utility.getFavStationList().favItem.modes{
            arrString = mode
        }
        
        contHeightTbl.constant  =  CGFloat((self.arrString.count*60))
        
        self.tblFmMode.reloadData()
    }
    
    class  func getObject()->FMModeVC{
        return  MainStoryboard.instantiateViewController(withIdentifier: "FMModeVC") as! FMModeVC
    }
    
      @IBAction func btnActionClose(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }

}
extension FMModeVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrString.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "FmTblCell") as! FmTblCell
        cell.lblName.text = self.arrString[indexPath.row].name.uppercased()
        cell.contentView.backgroundColor =  Utility.getUserMode().name.lowercased() == cell.lblName.text?.lowercased() ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1):#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            Utility.setUserMode(name: self.arrString[indexPath.row].name ?? "", time:self.arrString[indexPath.row].delay ??  "0")

            self.callBack?(self.arrString[indexPath.row], indexPath.row)
        }
    }
    
}


class FmTblCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!

}
