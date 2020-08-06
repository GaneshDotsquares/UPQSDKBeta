//
//  UrlVC.swift
//  RRApp
//
//  Created by Ganesh on 30/04/20.
//  Copyright © 2020 Dotsquares. All rights reserved.
//

import UIKit

class UrlVC: UIViewController {
    @IBOutlet weak var vwWeb: WebKit!
    var strUrl =  ""
    override func viewDidLoad() {
        super.viewDidLoad()
        vwWeb?.setupUI(strUrl: strUrl)
        
     }
    

   class  func getObject()->UrlVC{
        return  MainStoryboard.instantiateViewController(withIdentifier: "UrlVC") as! UrlVC
    }
    @IBAction func btnBackAction(_ sender:Any){
           self.dismiss(animated: true, completion: nil)
       }
}
